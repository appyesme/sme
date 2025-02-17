import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indidactor.dart';
import '../../../widgets/no_content_message_widget.dart';
import '../../service_details_page/views/service_details_page.dart';
import '../models/notification_model.dart';
import '../providers/provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  static const String route = '/notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Notifications",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: Consumer(
        builder: (_, WidgetRef ref, __) {
          final length = ref.watch(notificationsProvider.select((value) => value.notifications?.length));

          if (length == null) return const Center(child: LoadingIndicator());
          if (length == 0) {
            return const Center(
              child: NoContentMessageWidget(
                icon: Icons.notifications,
                message: "No notifications",
              ),
            );
          } else {
            return ListView.separated(
              controller: ref.read(notificationsProvider.notifier).scrollController,
              itemCount: length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (BuildContext context, int index) {
                return NotificationCard(index: index);
              },
            );
          }
        },
      ),
    );
  }
}

class NotificationCard extends ConsumerWidget {
  const NotificationCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationsProvider.select((value) => value.notifications?.elementAt(index)));

    return GestureDetector(
      onTap: () {
        if (notification?.read == false) {
          ref.watch(notificationsProvider.notifier).markAsRead(index, notification!.id!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        color: notification?.read == true ? null : const Color(0x2061529B),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: KColors.grey1,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.bell,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          notification?.title ?? '',
                          fontWeight: FontWeight.w500,
                          color: KColors.black,
                        ),
                      ),
                      const SizedBox(width: 5),
                      AppText(
                        "2024-10-10T12:15:56Z".toTimeAgo(),
                        color: KColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AppText(
                    notification?.body ?? '',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: KColors.black,
                  ),
                  if (notification?.actions.isNotEmpty ?? false) ...[
                    const SizedBox(height: 5),
                    NotificationActionsBuilder(
                      actions: notification!.actions,
                      onSeeServiceTap: () {
                        if (notification.read == false) {
                          ref.watch(notificationsProvider.notifier).markAsRead(index, notification.id!);
                        }
                      },
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationActionsBuilder extends ConsumerWidget {
  final List<NotificationAction> actions;
  final VoidCallback onSeeServiceTap;
  const NotificationActionsBuilder({
    super.key,
    required this.actions,
    required this.onSeeServiceTap,
  });

  void onActionTap(BuildContext context, NotificationAction action) {
    switch (action.resource) {
      case NotificationActionResourceType.SERVICE:
        onSeeServiceTap.call();
        context.pushNamed(
          ServiceDetailsPage.route,
          extra: ServiceDetailsParam(
            serviceID: action.resourceID,
            showActions: false,
          ),
        );

      default:
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(alignment: WrapAlignment.spaceEvenly, children: [
      ...actions.map(
        (action) {
          return GestureDetector(
            onTap: () => onActionTap(context, action),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: AppText(
                "See service",
                color: KColors.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    ]);
  }
}
