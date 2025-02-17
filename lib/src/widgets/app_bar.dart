import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';
import '../core/shared/auth_handler.dart';
import '../features/notifications_page/views/notifications_page.dart';
import '../features/profile_page/views/profile_page.dart';
import 'app_text.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppText(
        title,
        fontSize: 20,
        color: KColors.white,
        fontWeight: FontWeight.w500,
      ),
      automaticallyImplyLeading: false,
      backgroundColor: KColors.purple,
      centerTitle: false,
      toolbarHeight: 60.px,
      shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      actions: [
        CupertinoButton(
          onPressed: () => context.pushNamed(NotificationsPage.route),
          padding: const EdgeInsets.only(),
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              final count = ref.watch(unreadNotificationProvider);

              return Badge(
                isLabelVisible: count > 0,
                backgroundColor: KColors.secondary,
                padding: const EdgeInsets.all(2),
                label: Text(NumberFormat.compact().format(count).toString()),
                child: const Icon(
                  CupertinoIcons.bell,
                  color: KColors.white,
                  size: 32,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        CupertinoButton(
          onPressed: () => context.pushNamed(ProfilePage.route),
          padding: const EdgeInsets.only(),
          child: const Icon(
            CupertinoIcons.person_alt_circle,
            color: KColors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
