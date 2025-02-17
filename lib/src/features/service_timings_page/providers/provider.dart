import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services/services_api.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../models/service_day_model.dart';
import '../models/service_timing_model.dart';
import '../views/widgets/time_slot_selection_sheet.dart';
import 'state.dart';

final editServiceTimingProvider =
    StateNotifierProvider.autoDispose<EditServiceTimingsNotifier, EditServiceTimingsState>((ref) {
  final notifier = EditServiceTimingsNotifier();
  return notifier;
});

class EditServiceTimingsNotifier extends StateNotifier<EditServiceTimingsState> {
  EditServiceTimingsNotifier() : super(const EditServiceTimingsState());

  void setState(EditServiceTimingsState value) => state = value;

  void update(EditServiceTimingsState Function(EditServiceTimingsState state) value) {
    final updated = value(state);
    setState(updated);
  }

  void updateTimings(List<ServiceTimingModel> Function(List<ServiceTimingModel> timings) value) {
    final updated = state.selectedDay?.copyWith(timings: value([...state.selectedDay?.timings ?? []]));
    setState(state.copyWith(selectedDay: updated));
  }

  Future<void> getServiceDays() async {
    final days = await ServicesApi.getServiceDays(state.service.id!);
    days?.sort((a, b) => a.day!.compareTo(b.day!));
    setState(state.copyWith(days: days ?? state.days ?? <ServiceDayModel>[]));
  }

  Future<void> changeServiceDayEnableStatus(int index, bool enabled, String serviceDayId) async {
    final day = await ServicesApi.changeServiceDayEnableStatus(serviceDayId, enabled);
    if (day != null) setState(state.changeDayStatus(index, day.enabled));
  }

  void openSlotModalSheet(BuildContext context, ServiceDayModel? day) async {
    if (day == null || !day.enabled) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(state.copyWith(selectedDay: day));
    showTimeSlotSelectionSheet(context, day);

    await Future.delayed(const Duration(milliseconds: 250));
    final timings = await ServicesApi.getTimings(day.id!);
    final updated = state.selectedDay?.copyWith(timings: timings ?? <ServiceTimingModel>[]);
    setState(state.copyWith(selectedDay: updated));
  }

  Future<void> removeTiming(BuildContext context, int index, ServiceTimingModel timing) async {
    DialogHelper.showloading(context);
    final result = await ServicesApi.deleteTiming(timing.serviceDayId!, timing.id!);
    DialogHelper.pop(context);

    if (result != null) {
      setState(state.removeTiming(index));
      Toast.success("Service timings deleted successfully");
    }
  }

  Future<void> saveTimings(BuildContext context) async {
    DialogHelper.showloading(context);
    final timings = await ServicesApi.saveTimings(
      state.selectedDay!.id!,
      state.selectedDay!.timings!,
    );
    DialogHelper.pop(context);
    if (timings != null) {
      final updated = state.selectedDay?.copyWith(timings: timings);
      setState(state.copyWith(selectedDay: updated));
      Toast.success("Service timings saved successfully");
    } else {
      Toast.failure("Failed to save service timings");
    }
  }
}
