import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_timing_model.freezed.dart';
part 'service_timing_model.g.dart';

@freezed
class ServiceTimingModel with _$ServiceTimingModel {
  static const ServiceTimingModel defaultValue = ServiceTimingModel();

  const factory ServiceTimingModel({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "service_day_id") String? serviceDayId,
    @JsonKey(name: "start_time") String? startTime,
    @JsonKey(name: "end_time") String? endTime,
    @JsonKey(name: "people_per_slot") int? peoplePerSlot,
    @Default(false) bool enabled,

    // Some other reponse have this field.
    @JsonKey(name: "remaining_slots") String? remainingSlots,
  }) = _ServiceTimingModel;

  factory ServiceTimingModel.fromJson(Map<String, dynamic> json) => _$ServiceTimingModelFromJson(json);
}
