import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/file_service/file_service.dart';
import '../shared/shared.dart';

typedef ApiResponseType = Either<Failure, Success>;
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// This _MetricHttpClient class is used to monitor performance
/// of the application. Whenever any api gets triggered, then
/// `send` method will be called to update the performance.
class _MetricHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (kIsWeb) return _inner.send(request);

    late http.StreamedResponse response;
    final HttpMetric metric = FirebasePerformance.instance.newHttpMetric(request.url.toString(), HttpMethod.Get);
    try {
      await metric.start();
      response = await _inner.send(request);
      metric
        ..requestPayloadSize = request.contentLength
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}

class ApiHelper {
  static Map<String, String> get _headers => {
        if (authToken != null) "Authorization": "Bearer $authToken",
        "Content-Type": "application/json; charset=utf-8",
      };

  static final metricHttpClient = _MetricHttpClient();

  static Map<String, dynamic>? convertQueryPararmsToHttpsFormat(Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) return null;

    Map<String, dynamic> output = {};
    for (String key in queryParams.keys) {
      final valueOfkey = queryParams[key];
      if (valueOfkey is List) {
        final formatted = valueOfkey.map((value) => "$key=$value").join("&").split("=").sublist(1).join("=");
        output.addAll({key: formatted});
      } else {
        output.addAll({key: valueOfkey.toString()});
      }
    }

    return output;
  }

  static Uri _getUri(String path, {Map<String, dynamic>? queryParams}) {
    final isHttps = apiUrlV1.startsWith("https://");
    final schema = apiUrlV1.split("//")[1];
    if (isHttps) return Uri.https(schema, path, convertQueryPararmsToHttpsFormat(queryParams));
    return Uri.http(schema, path, convertQueryPararmsToHttpsFormat(queryParams));
  }

  static Future<ApiResponseType> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await metricHttpClient.get(uri, headers: _headers);
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } on http.ClientException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } catch (e) {
      log("$e", name: "CATCH - GET - $path");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await metricHttpClient.post(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers,
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } on http.ClientException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } catch (e) {
      log("$e", name: "CATCH - POST");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> delete(
    String path, {
    String? vesrion,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await metricHttpClient.delete(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers,
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - DELETE");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> put(String path, {Object? body, Map<String, dynamic>? queryParams}) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await metricHttpClient.put(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers,
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } on http.ClientException {
      return const Left(Failure("Slow internet. Please wait or try again later"));
    } catch (e) {
      log("$e", name: "CATCH - PUT");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Future<ApiResponseType> patch(
    String path, {
    String? vesrion,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      final response = await metricHttpClient.patch(
        uri,
        body: body == null ? null : json.encode(body),
        headers: _headers,
      );
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - PATCH");
      return const Left(Failure("Unable to reach the server"));
    }
  }

  static Either<Failure, Success> parseResponse(http.Response response) {
    final decodedResponse = json.decode(utf8.decode(response.bodyBytes, allowMalformed: true));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Right(Success(decodedResponse['data']));
    } else if (response.statusCode == 401) {
      // GoRouter.of(navigatorKey.currentContext!).goNamed(AuthPage.route);
      return const Left(Failure("Unauthorized"));
    } else {
      return Left(Failure("${decodedResponse['message']}"));
    }
  }

  static Future<ApiResponseType> uploadFile(
    String path,
    List<FileX> files, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _getUri(path, queryParams: queryParams);
      var request = http.MultipartRequest('POST', uri);
      for (var file in files) {
        var multipartFile = http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      request.headers.addAll(_headers);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return parseResponse(response);
    } on SocketException {
      return const Left(Failure("No internet connection"));
    } catch (e) {
      log("$e", name: "CATCH - PATCH");
      return const Left(Failure("Unable to reach the server"));
    }
  }
}

/// Return results
@immutable
class Success {
  final dynamic data;
  const Success(this.data);
}

@immutable
class Failure {
  final String message;
  const Failure(this.message);
}
