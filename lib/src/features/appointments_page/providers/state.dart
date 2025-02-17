import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../payment_page/models/appointment_model.dart';

part 'state.freezed.dart';

@freezed
class AppointmentsState with _$AppointmentsState {
  const factory AppointmentsState({
    DateTime? selectedDay,
    List<AppointmentModel>? appointments,
  }) = _AppointmentsState;
}

extension AppointmentsStatusExt on AppointmentStatus {
  Color get color {
    if (this == AppointmentStatus.INITIATED) return const Color(0xFFE86A03);
    if (this == AppointmentStatus.BOOKED) return const Color(0xFF04905B);
    if (this == AppointmentStatus.CANCELLED) return const Color(0xFFD7B300);
    if (this == AppointmentStatus.COMPLETED) return const Color(0xFF0048D7);

    return const Color(0xFFE86A03);
  }
}
