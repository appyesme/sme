import 'package:freezed_annotation/freezed_annotation.dart';

import '../../payment_page/models/appointment_model.dart';

part 'booked_appoinment.freezed.dart';
part 'booked_appoinment.g.dart';

@freezed
class BookedAppointment with _$BookedAppointment {
  const factory BookedAppointment({
    @JsonKey(name: "appointment_id") required String appointmentId,
    @JsonKey(name: "service_id") required String serviceId,
    required double amount,
    required String currency,
    @JsonKey(name: "order_id") required String orderId,
    required AppointmentStatus status,
  }) = _BookedAppointment;

  factory BookedAppointment.fromJson(Map<String, dynamic> json) => _$BookedAppointmentFromJson(json);
}
