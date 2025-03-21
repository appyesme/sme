import 'package:freezed_annotation/freezed_annotation.dart';

import '../../service_timings_page/models/service_day_model.dart';
import '../../service_timings_page/models/service_timing_model.dart';
import '../../services_list_page/models/service_model.dart';

part 'state.freezed.dart';

@freezed
class BookAppointmentState with _$BookAppointmentState {
  const factory BookAppointmentState({
    ServiceModel? service,
    DateTime? selectedDay,
    List<ServiceDayModel>? days,
    List<ServiceTimingModel>? timings,
    ServiceTimingModel? selectedTiming,
    @Default(false) bool homeServiceNeeded,
    String? selectedTimeToAriveHome,
    double? totalPrice,
  }) = _BookAppointmentState;
}
