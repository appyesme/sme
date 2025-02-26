import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/search_page/models/searched_model.dart';

@immutable
abstract class SearchApi {
  static Future<SearchedModel?> search(String? query) async {
    String path = "/v1/searches";
    final response = await ApiHelper.get(path, queryParams: {"query": query});
    return response.fold<SearchedModel?>((l) => null, (r) => SearchedModel.fromJson(r.data));
  }
}
