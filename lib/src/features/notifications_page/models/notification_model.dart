import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    String? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'user_id') required String userId,
    @Default([]) List<NotificationAction> actions,
    String? title,
    String? body,
    @Default(false) bool read,
    @Default(true) bool visible,
    @JsonKey(name: 'fcm_status') String? fcmStatus,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}

// ignore: constant_identifier_names
enum NotificationActionResourceType { SERVICE }

@freezed
class NotificationAction with _$NotificationAction {
  const factory NotificationAction({
    NotificationActionResourceType? resource,
    @JsonKey(name: 'resource_id') String? resourceID,
  }) = _NotificationAction;

  factory NotificationAction.fromJson(Map<String, dynamic> json) => _$NotificationActionFromJson(json);
}
