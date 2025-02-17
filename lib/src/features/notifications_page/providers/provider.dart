import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/auth_handler.dart';
import '../../../services/api_services/notifications_apis.dart';
import '../../../services/api_services/users_apis.dart';
import '../models/notification_model.dart';
import 'state.dart';

final notificationsProvider = StateNotifierProvider.autoDispose<NotificationsNotifier, NotificationsState>((ref) {
  final notifier = NotificationsNotifier(ref)..getNotifications();

  notifier.scrollController.addListener(notifier.fetchNextPage);
  ref.onDispose(() {
    notifier.scrollController.removeListener(notifier.fetchNextPage);
    notifier.scrollController.dispose();
  });
  return notifier;
});

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final Ref ref;
  NotificationsNotifier(this.ref) : super(const NotificationsState());

  void setState(NotificationsState value) => state = value;
  late final scrollController = ScrollController();

  final double _loadMoreThreshold = 200.0;
  int _page = 0;
  bool _isFetchingNotifications = false;
  bool noMoreNotifications = false;

  void fetchNextPage() async {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - _loadMoreThreshold) {
      if (_isFetchingNotifications || noMoreNotifications) return;

      _isFetchingNotifications = true;
      final notifications = await getNotifications();
      _isFetchingNotifications = false;

      if (notifications == null || notifications.isEmpty) {
        noMoreNotifications = true;
      } else if (notifications.length < 15) {
        noMoreNotifications = true;
      }
    }
  }

  void update(NotificationsState Function(NotificationsState state) value) {
    final updated = value(state);
    setState(updated);
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final notifications = (await UsersApi.getNotifications(page: _page)) ?? <NotificationModel>[];
    final updated = [...(state.notifications ?? <NotificationModel>[]), ...notifications];
    setState(state.copyWith(notifications: updated));
    _page++;
    return notifications;
  }

  Future<void> markAsRead(int index, String noitifictionId) async {
    final success = await NotificationsApi.markAsRead(noitifictionId);
    if (success) {
      var notifications = [...state.notifications!];
      notifications[index] = notifications[index].copyWith(read: true);
      setState(state.copyWith(notifications: notifications));
      ref.read(unreadNotificationProvider.notifier).update((state) => state - 1);
    }
  }
}
