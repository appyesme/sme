import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/notifications_page/models/notification_model.dart';
import '../../features/payment_page/models/appointment_model.dart';
import '../../features/payment_page/models/payment_model.dart';
import '../../features/profile_page/models/user_model.dart';
import '../file_service/file_service.dart';
import 'notifications_apis.dart';

@immutable
abstract class UsersApi {
  static Future<PaymentStatus?> verifyPaymentStatus(String appointmentId) async {
    const path = "/v1/payments/verify/status";
    final response = await ApiHelper.get(path, queryParams: {"appointment_id": appointmentId});
    return response.fold<PaymentStatus?>(
      (l) => null,
      (r) => r.data["status"] == "PAID" ? PaymentStatus.PAID : PaymentStatus.PENDING,
    );
  }

  static Future<List<AppointmentModel>?> getBookedAppointments(String? date) async {
    const path = "/v1/users/appointments";
    final response = await ApiHelper.get(path, queryParams: {"date": date});

    return response.fold<List<AppointmentModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => AppointmentModel.fromJson(e)).toList(),
    );
  }

  static Future<UserModel?> getUserDetails(String profileId) async {
    String path = "/v1/users/$profileId/details";
    final response = await ApiHelper.get(path);
    return response.fold<UserModel?>((l) => null, (r) => UserModel.fromJson(r.data));
  }

  static Future<UserModel?> updateUserDetails(UserModel details) async {
    String path = "/v1/users/details";
    final response = await ApiHelper.put(path, body: {
      "name": details.name,
      "email": details.email,
      "about": details.about,
      "expertises": details.expertises,
      "total_work_experience": details.totalWorkExperience,
    });
    return response.fold((l) => null, (r) => UserModel.fromJson(r.data));
  }

  static Future<String?> uploadPhoto({required FileX photo}) async {
    const path = "/v1/users/photo/upload";
    final response = await ApiHelper.uploadFile(path, [photo]);
    return response.fold<String?>((l) => null, (r) => r.data);
  }

  static Future<List<NotificationModel>?> getNotifications({int page = 1}) async {
    String path = "/v1/users/notifications";
    final response = await ApiHelper.get(path, queryParams: {"page": page, "limit": NotificationsApi.limit});

    return response.fold(
      (error) => null,
      (success) => List.from(success.data ?? []).map((e) => NotificationModel.fromJson(e)).toList(),
    );
  }

  static Future<int> getNotificationUnreadCount() async {
    String path = "/v1/users/notifications/unread-count";
    final response = await ApiHelper.get(path);
    return response.fold<int>((error) => 0, (success) => int.tryParse("${success.data}") ?? 0);
  }

  static Future<List<UserModel>?> getFavouriteUsers() async {
    String path = "/v1/users/favourites";
    final response = await ApiHelper.get(path);

    return response.fold(
      (error) => null,
      (success) => List.from(success.data ?? []).map((e) => UserModel.fromJson(e)).toList(),
    );
  }

  static Future<bool> addToFavourite(String profileId) async {
    String path = "/v1/users/$profileId/favourite";
    final response = await ApiHelper.post(path);
    return response.fold<bool>((l) => false, (r) => r.data != null);
  }

  static Future<bool> removeToFavourite(String profileId) async {
    String path = "/v1/users/$profileId/favourite";
    final response = await ApiHelper.delete(path);
    return response.fold<bool>((l) => false, (r) => r.data != null);
  }
}
