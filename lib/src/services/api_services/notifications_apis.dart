import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';

@immutable
abstract class NotificationsApi {
  static int limit = 15;

  static Future<bool> markAsRead(String noitifictionId) async {
    String path = "/v1/notifications/$noitifictionId/mark-as-read";
    final response = await ApiHelper.put(path);
    return response.fold((error) => false, (success) => true);
  }
}
