import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services_list_page/models/service_model.dart';
import '../models/service_day_model.dart';
import '../models/service_timing_model.dart';

part 'state.freezed.dart';

@freezed
class EditServiceTimingsState with _$EditServiceTimingsState {
  const EditServiceTimingsState._();

  const factory EditServiceTimingsState({
    @Default(ServiceModel.defaultValue) ServiceModel service,
    List<ServiceDayModel>? days,
    ServiceDayModel? selectedDay,
  }) = _EditServiceTimingsState;

  EditServiceTimingsState changeDayStatus(int index, bool enabled) {
    final updated = [...days!];
    updated[index] = updated[index].copyWith(enabled: enabled);
    return copyWith(days: updated);
  }

  EditServiceTimingsState setSlotSelecttionDay(ServiceDayModel? day) => copyWith(selectedDay: day);

  EditServiceTimingsState addTiming() {
    final timings = [...(selectedDay!.timings ?? <ServiceTimingModel>[]), const ServiceTimingModel()];
    final updated = selectedDay?.copyWith(timings: timings);
    return copyWith(selectedDay: updated);
  }

  EditServiceTimingsState removeTiming(int index) {
    final timings = [...(selectedDay!.timings ?? <ServiceTimingModel>[])];
    timings.removeAt(index);
    final updated = selectedDay?.copyWith(timings: timings);
    return copyWith(selectedDay: updated);
  }
}

extension IntExt on int {
  String getDayName() {
    switch (this) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Invalid day";
    }
  }
}
