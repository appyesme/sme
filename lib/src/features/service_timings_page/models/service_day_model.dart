import 'package:freezed_annotation/freezed_annotation.dart';

import 'service_timing_model.dart';

part 'service_day_model.freezed.dart';
part 'service_day_model.g.dart';

@freezed
class ServiceDayModel with _$ServiceDayModel {
  static const ServiceDayModel defaultValue = ServiceDayModel();

  const factory ServiceDayModel({
    String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "service_id") String? serviceId,
    int? day,
    @Default(false) bool enabled,
    List<ServiceTimingModel>? timings,
  }) = _ServiceDayModel;

  factory ServiceDayModel.fromJson(Map<String, dynamic> json) => _$ServiceDayModelFromJson(json);
}
