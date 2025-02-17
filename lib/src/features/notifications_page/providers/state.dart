import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/notification_model.dart';

part 'state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const NotificationsState._();

  const factory NotificationsState({
    List<NotificationModel>? notifications,
  }) = _NotificationsState;
}
