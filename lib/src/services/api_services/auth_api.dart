import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../core/shared/shared.dart';
import '../../utils/custom_toast.dart';
import '../file_service/file_service.dart';

@immutable
abstract class AuthApi {
  static Future<bool> verifyJwtTokenExpiration() async {
    String path = "/auth/jwt/verify";
    final response = await ApiHelper.get(path, queryParams: {"token": authToken});
    return response.fold((l) => false, (r) => r.data != null);
  }

  static Future<Map<String, dynamic>?> sendOTP(String phoneNumber, {required bool isSignIn}) async {
    String path = "/auth/phone/send-otp";
    final response = await ApiHelper.post(
      path,
      queryParams: {"type": isSignIn ? "SIGNIN" : "SIGNUP"},
      body: {"phone_number": phoneNumber},
    );
    return response.fold((l) => Toast.info(l.message), (r) => r.data);
  }

  static Future<Map<String, dynamic>?> signUp(Map<String, dynamic> body) async {
    String path = "/auth/signup";
    final response = await ApiHelper.post(path, body: body);
    return response.fold((l) => Toast.failure(l.message), (r) => r.data);
  }

  static Future<bool?> uploadVerificationDocs(String userId, List<FileX> files) async {
    final path = "/auth/$userId/upload/verification-docs";
    final response = await ApiHelper.uploadFile(path, files);
    return response.fold<bool?>((l) => Toast.failure(l.message), (r) => true);
  }

  static Future<Map<String, dynamic>?> verifyOtp(String phoneNumber, String otp) async {
    String path = "/auth/phone/verify";
    final response = await ApiHelper.post(
      path,
      body: {"phone_number": phoneNumber, "otp": otp},
    );
    return response.fold<Map<String, dynamic>?>((l) => Toast.failure(l.message), (r) => r.data);
  }

  static Future<bool> resendOtp(String phoneNumber) async {
    String path = "/auth/phone/resend";
    final response = await ApiHelper.post(path, body: {"phone_number": phoneNumber});
    return response.fold<bool>((l) => false, (r) => true);
  }
}
