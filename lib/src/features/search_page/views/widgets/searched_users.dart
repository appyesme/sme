import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../profile_page/views/profile_page.dart';
import '../../providers/provider.dart';

class SearchedUsersWidget extends ConsumerWidget {
  const SearchedUsersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(searchProvider.select((value) => value.searched?.users));

    if (users == null) {
      return const Center(
        child: AppText(
          "Hey, you came back.\nSearch something...",
          textAlign: TextAlign.center,
        ),
      );
    }
    if (users.isEmpty) {
      return const Center(
        child: AppText(
          "No entrepreneurs",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.separated(
        itemCount: users.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final user = users[index];

          return GestureDetector(
            onTap: () {
              DialogHelper.unfocus(context);
              context.pushNamed(
                ProfilePage.route,
                extra: user.id,
              );
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                ProfileAvatar(
                  image: user.photoUrl,
                  scale: 40,
                  errorIconSize: 24,
                ),
                SizedBox(width: 5.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        user.name ?? "-",
                        maxLines: 2,
                        color: KColors.black,
                      ),
                      if ((user.expertises ?? "").isNotEmpty)
                        AppText(
                          user.expertises ?? "-",
                          maxLines: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: KColors.black,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
