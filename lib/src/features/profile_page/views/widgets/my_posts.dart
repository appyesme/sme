import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/no_content_message_widget.dart';
import '../../providers/provider.dart';
import '../modal_sheet/view_post_sheet.dart';

class MyPostsTab extends ConsumerWidget {
  const MyPostsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(profileProvider.select((value) => value.posts));

    if (posts == null) {
      return const Center(
        child: LoadingIndicator(),
      );
    } else if (posts.isEmpty) {
      return const NoContentMessageWidget(
        message: "Gallery is empty",
        icon: Icons.photo,
      );
    } else {
      return SafeArea(
        child: GridView.builder(
          itemCount: posts.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () => viewPostSheet(context, post),
              child: ClipRRect(
                child: ColoredBox(
                  color: KColors.grey2,
                  child: CachedNetworkImage(
                    imageUrl: post.medias.firstOrNull?.url ?? '',
                    fit: BoxFit.cover,
                    maxHeightDiskCache: 200,
                    maxWidthDiskCache: 200,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
