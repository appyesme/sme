import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/shared.dart';
import '../../../services/api_services/appointments_api.dart';
import '../../../services/api_services/users_apis.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../book_appointment_page/views/widgets/show_rzp_init_dialog.dart';
import '../../payment_page/models/appointment_model.dart';
import '../../payment_page/models/payment_model.dart';
import 'state.dart';

final appointmentsProvider = StateNotifierProvider.autoDispose<AppointmentsNotifier, AppointmentsState>((ref) {
  final notifier = AppointmentsNotifier()..getBookedAppointments();
  return notifier;
});

class AppointmentsNotifier extends StateNotifier<AppointmentsState> {
  AppointmentsNotifier() : super(const AppointmentsState());

  void setState(AppointmentsState value) => state = value;
  void update(AppointmentsState Function(AppointmentsState state) value) {
    final updated = value(state);
    setState(updated);
  }

  void onDaySelected(day, focus) {
    final updated = state.copyWith(selectedDay: day);
    setState(updated);
    getBookedAppointments();
  }

  Future<void> getBookedAppointments() async {
    if (userId == null) return;
    final appointments = await UsersApi.getBookedAppointments((state.selectedDay ?? DateTime.now()).toIso8601String());
    setState(state.copyWith(appointments: appointments ?? <AppointmentModel>[]));
  }

  Future<void> completePayment(BuildContext context, PaymentModel payment) async {
    DialogHelper.showloading(context);
    var status = await UsersApi.verifyPaymentStatus(payment.appointmentId!);
    DialogHelper.pop(context);
    if (status == null) return Toast.failure("Something is wrong with the payment status");

    status = status == PaymentStatus.PAID ? PaymentStatus.PAID : await showRzpInitDialog(context, payment);
    if (status == PaymentStatus.PAID) {
      final updated = state.appointments?.map((item) {
        if (item.id != payment.appointmentId) return item;
        return item.copyWith(status: AppointmentStatus.BOOKED, payment: null);
      }).toList();

      setState(state.copyWith(appointments: updated));
    }
  }

  Future<void> markAsCompleted(BuildContext context, String appointmentId) async {
    DialogHelper.showloading(context);
    final bool status = await AppointmentsApi.markAsCompleted(appointmentId);
    DialogHelper.pop(context);

    if (status) {
      final updated = state.appointments?.map((item) {
        if (item.id != appointmentId) return item;
        return item.copyWith(status: AppointmentStatus.COMPLETED);
      }).toList();

      setState(state.copyWith(appointments: updated));
    }
  }
}
