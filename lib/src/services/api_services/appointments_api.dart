import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/book_appointment_page/models/booked_appoinment.dart';
import '../../features/payment_page/models/appointment_model.dart';
import '../../features/service_timings_page/models/service_day_model.dart';
import '../../features/service_timings_page/models/service_timing_model.dart';
import '../../utils/custom_toast.dart';

@immutable
abstract class AppointmentsApi {
  static Future<List<ServiceDayModel>?> getAppointmentAvailableDays(String? serviceID) async {
    String path = "/v1/appointments/available-days";
    final response = await ApiHelper.get(path, queryParams: {"service_id": serviceID});
    return response.fold<List<ServiceDayModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceDayModel.fromJson(e)).toList(),
    );
  }

  static Future<List<ServiceDayModel>?> verifyPaymentStatus(String? serviceID) async {
    String path = "/v1/appointments/available-days";
    final response = await ApiHelper.get(path, queryParams: {"service_id": serviceID});
    return response.fold<List<ServiceDayModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceDayModel.fromJson(e)).toList(),
    );
  }

  static Future<List<ServiceTimingModel>?> getAppointmentAvailableDayTimings(
    String? serviceDayId,
    String? date,
  ) async {
    String path = "/v1/appointments/available-timings";
    final response = await ApiHelper.get(path, queryParams: {
      "service_day_id": serviceDayId,
      "date": date,
    });
    return response.fold<List<ServiceTimingModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceTimingModel.fromJson(e)).toList(),
    );
  }

  static Future<double?> getAppointmentPrice(String serviceId, bool homeServiceNeeded) async {
    String path = "/v1/appointments/price";
    final response = await ApiHelper.get(
      path,
      queryParams: {
        "service_id": serviceId,
        "home_service_needed": homeServiceNeeded,
      },
    );
    return response.fold<double?>((l) => null, (r) {
      log("${r.data?["amount"]}");
      return double.tryParse("${r.data?["amount"]}")?.toDouble();
    });
  }

  static Future<BookedAppointment?> bookAppointment(AppointmentModel appointment) async {
    String path = "/v1/appointments/book";
    final response = await ApiHelper.post(path, body: {
      "service_id": appointment.serviceId,
      "service_timing_id": appointment.serviceTimingId,
      "appointment_date": appointment.appointmentDate,
      "start_time": appointment.startTime,
      "end_time": appointment.endTime,
      "home_service_needed": appointment.homeServiceNeeded,
      "home_reach_time": appointment.homeReachTime,
    });
    return response.fold<BookedAppointment?>((l) => null, (r) => BookedAppointment.fromJson(r.data));
  }

  static Future<AppointmentModel?> acceptAppointment(String appointmentId) async {
    String path = "/v1/appointments/$appointmentId/accept";
    final response = await ApiHelper.put(path);
    return response.fold<AppointmentModel?>(
      (l) => Toast.failure(l.message),
      (r) => AppointmentModel.fromJson(r.data),
    );
  }

  static Future<AppointmentModel?> rejectAppointment(String appointmentId) async {
    String path = "/v1/appointments/$appointmentId/reject";
    final response = await ApiHelper.put(path);
    return response.fold<AppointmentModel?>(
      (l) => Toast.failure(l.message),
      (r) => AppointmentModel.fromJson(r.data),
    );
  }

  static Future<bool> markAsCompleted(String appointmentId) async {
    String path = "/v1/appointments/$appointmentId/completed";
    final response = await ApiHelper.post(path);
    return response.fold<bool>((l) => false, (r) => r.data != null);
  }

  static Future<AppointmentModel?> appointmentPaymentCompleted(AppointmentModel appointment) async {
    String path = "/v1/appointments/book";
    final response = await ApiHelper.post(path, body: {
      "service_id": appointment.serviceId,
      "service_timing_id": appointment.serviceTimingId,
      "appointment_date": appointment.appointmentDate,
      "start_time": appointment.startTime,
      "end_time": appointment.endTime,
    });
    return response.fold<AppointmentModel?>((l) => null, (r) => AppointmentModel.fromJson(r.data));
  }
}
