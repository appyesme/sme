import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/no_content_message_widget.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../profile_page/views/profile_page.dart';
import '../../providers/provider.dart';

class FavouriteUsersWidget extends ConsumerWidget {
  const FavouriteUsersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(favouritesProvider.select((value) => value.users));

    if (users == null) {
      return const Center(
        child: LoadingIndicator(),
      );
    } else if (users.isEmpty) {
      return const NoContentMessageWidget(
        message: "You haven't added any\nfavoutire users yet.",
        icon: Icons.photo,
      );
    } else {
      return SafeArea(
        child: GridView.builder(
          itemCount: users.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            final user = users[index];

            return GestureDetector(
              onTap: () => context.pushNamed(ProfilePage.route, extra: user.id),
              child: ClipRRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProfileAvatar(
                        image: user.photoUrl ?? '',
                        scale: 80,
                        errorIconSize: 32,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: KColors.bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          user.name ?? '',
                          color: KColors.white,
                          maxLines: 1,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
