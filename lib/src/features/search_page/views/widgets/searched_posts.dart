import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../../widgets/app_text.dart';
import '../../../profile_page/views/modal_sheet/view_post_sheet.dart';
import '../../providers/provider.dart';

class SearchedPostsWidget extends ConsumerWidget {
  const SearchedPostsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(searchProvider.select((value) => value.searched?.posts));

    if (posts == null) {
      return const Center(
        child: AppText(
          "Hey, you came back.\nSearch something...",
          textAlign: TextAlign.center,
        ),
      );
    }
    if (posts.isEmpty) {
      return const Center(
        child: AppText(
          "No posts were found",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return GridView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          final post = posts[index];

          return GestureDetector(
            onTap: () {
              DialogHelper.unfocus(context);
              viewPostSheet(context, post);
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    post.medias.firstOrNull?.url ?? '',
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.7],
                    colors: [KColors.white10, KColors.black60],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(
                    post.description ?? '',
                    maxLines: 2,
                    fontSize: 12,
                    color: KColors.white,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
