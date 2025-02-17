import 'package:freezed_annotation/freezed_annotation.dart';

import '../../add_service_page/providers/state.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  static const ServiceModel defaultValue = ServiceModel();

  const factory ServiceModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "expertises") String? expertises,
    @JsonKey(name: "charge") double? charge,
    @JsonKey(name: "additional_charge") double? additionalCharge,
    @JsonKey(name: "home_available") @Default(false) bool homeAvailable,
    @JsonKey(name: "salon_available") @Default(false) bool salonAvailable,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "status") @Default(ServiceStatus.DRAFTED) ServiceStatus status,
    //
    @Default([]) List<ServiceMediaModel> medias,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
}

@freezed
class ServiceMediaModel with _$ServiceMediaModel {
  static const ServiceMediaModel defaultValue = ServiceMediaModel();

  const factory ServiceMediaModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "service_id") String? serviceId,
    @JsonKey(name: "file_name") String? fileName,
    @JsonKey(name: "storage_path") String? storagePath,
    String? url,
  }) = _ServiceMediaModel;

  factory ServiceMediaModel.fromJson(Map<String, dynamic> json) => _$ServiceMediaModelFromJson(json);
}
