import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services/appointments_api.dart';
import '../../../services/api_services/services_api.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../landing_page/providers/provider.dart';
import '../../payment_page/models/appointment_model.dart';
import '../../payment_page/models/payment_model.dart';
import '../views/widgets/show_rzp_init_dialog.dart';
import 'state.dart';

final appointmentProvider = StateNotifierProvider.autoDispose<BookAppointmentNotifier, BookAppointmentState>((ref) {
  final notifier = BookAppointmentNotifier(ref);
  return notifier;
});

class BookAppointmentNotifier extends StateNotifier<BookAppointmentState> {
  final Ref ref;
  BookAppointmentNotifier(this.ref) : super(const BookAppointmentState());

  void setState(BookAppointmentState value) => state = value;
  void update(BookAppointmentState Function(BookAppointmentState state) value) {
    final updated = value(state);
    setState(updated);
  }

  String? getServiceDayId(int dayInt) {
    final day = state.days?.where((element) => element.day == dayInt) ?? [];
    if (day.isNotEmpty && day.length == 1) return day.first.id!;
    return null;
  }

  void onDaySelected(DateTime day) {
    setState(state.copyWith(selectedDay: day, selectedTiming: null, homeServiceNeeded: false));
    final serviceDayId = getServiceDayId(day.weekday);
    if (serviceDayId != null) getAppointmentAvailableTimings(serviceDayId);
  }

  void getServiceById(String serviceID) async {
    final service = await ServicesApi.getServiceByID(serviceID);
    setState(state.copyWith(service: service));
  }

  void getAppointmentAvailableDays(String serviceID) async {
    final days = await AppointmentsApi.getAppointmentAvailableDays(serviceID);
    setState(state.copyWith(days: days));
    final serviceDayId = getServiceDayId(DateTime.now().weekday);
    if (serviceDayId != null) getAppointmentAvailableTimings(serviceDayId);
  }

  void verifyPaymentStatus(String serviceID) async {
    final days = await AppointmentsApi.verifyPaymentStatus(serviceID);
    setState(state.copyWith(days: days));
    final serviceDayId = getServiceDayId(DateTime.now().weekday);
    if (serviceDayId != null) getAppointmentAvailableTimings(serviceDayId);
  }

  void getAppointmentAvailableTimings(String serviceDayID) async {
    final timings =
        await AppointmentsApi.getAppointmentAvailableDayTimings(serviceDayID, state.selectedDay?.toIso8601String());
    setState(state.copyWith(timings: timings));
  }

  void getPrice() async {
    setState(state.copyWith(totalPrice: null));
    await Future.delayed(const Duration(milliseconds: 200));
    final price = await AppointmentsApi.getAppointmentPrice(state.service!.id!, state.homeServiceNeeded);
    setState(state.copyWith(totalPrice: price));
  }

  void bookAppointment(BuildContext context) async {
    if (state.totalPrice == null) return Toast.failure("Something is wrong with the total price");

    final appoinment = AppointmentModel(
      serviceTimingId: state.selectedTiming?.id,
      serviceId: state.service?.id,
      appointmentDate: state.selectedDay?.toIso8601String(),
      startTime: state.selectedTiming?.startTime,
      endTime: state.selectedTiming?.endTime,
      homeServiceNeeded: state.homeServiceNeeded,
    );

    DialogHelper.showloading(context);
    final bookedAppointment = await AppointmentsApi.bookAppointment(appoinment);
    DialogHelper.pop(context);
    if (bookedAppointment == null) return Toast.failure("Something is wrong. Please try again");

    PaymentStatus? paymentSucess;
    if (bookedAppointment.status == AppointmentStatus.INITIATED) {
      final payment = PaymentModel(
        title: state.service?.title ?? "Booking Service",
        description: state.service?.description ?? "Booking Service",
        phone: "9164825123",
        email: "appyesme@gmail.com",
        amount: state.totalPrice!,
        status: PaymentStatus.PENDING,
        orderId: bookedAppointment.orderId,
        appointmentId: bookedAppointment.appointmentId,
      );

      paymentSucess = await showRzpInitDialog(context, payment);
    } else {
      paymentSucess = PaymentStatus.PAID;
    }

    if (paymentSucess == PaymentStatus.PAID) {
      DialogHelper.pop(context); // Close payment success dialog
      DialogHelper.pop(context); // Go back
      ref.read(navigationProvider.notifier).setBottomNavTab(NavTab.Appointments);
    }
  }
}
