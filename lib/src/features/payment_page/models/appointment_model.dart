import 'package:freezed_annotation/freezed_annotation.dart';

import '../../add_post_page/models/post_model.dart';
import '../../services_list_page/models/service_model.dart';
import 'payment_model.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

// ignore: constant_identifier_names
enum AppointmentStatus { INITIATED, BOOKED, ACCEPTED, REJECTED, COMPLETED }

// Freezed model for Appointment
@freezed
class AppointmentModel with _$AppointmentModel {
  static const AppointmentModel defaultValue = AppointmentModel();

  const factory AppointmentModel({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "service_id") String? serviceId,
    @JsonKey(name: "service_timing_id") String? serviceTimingId,
    @JsonKey(name: "appointment_date") String? appointmentDate,
    @JsonKey(name: "start_time") String? startTime,
    @JsonKey(name: "end_time") String? endTime,
    @Default(AppointmentStatus.INITIATED) AppointmentStatus status,
    @JsonKey(name: "home_service_needed") @Default(false) bool homeServiceNeeded,
    @JsonKey(name: "home_reach_time") String? homeReachTime,
    Author? candidate,

    // Some other apis are using this
    ServiceModel? service,
    PaymentModel? payment,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);
}
