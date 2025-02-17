import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/no_content_message_widget.dart';
import '../../../add_post_page/views/add_post_page.dart';
import '../../providers/provider.dart';
import 'post_card.dart';

class PostsBuilder extends ConsumerWidget {
  const PostsBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(homeProvider.select((state) => state.posts?.length));

    if (length == null) {
      return const SliverFillRemaining(
        child: Center(
          child: LoadingIndicator(),
        ),
      );
    } else if (length == 0) {
      return const SliverFillRemaining(
        child: Center(
          child: NoContentMessageWidget(
            message: "No Posts",
            icon: Icons.task,
          ),
        ),
      );
    } else {
      final posts = ref.read(homeProvider.select((state) => state.posts));

      return SliverPadding(
        padding: const EdgeInsets.only(bottom: 80),
        sliver: SliverList.separated(
          itemCount: posts?.length ?? 0,
          separatorBuilder: (context, index) => const SizedBox(height: 2),
          itemBuilder: (context, index) {
            final post = posts![index];

            return PostCard(
              post: post,
              onEditTap: () {
                context.pushNamed(
                  AddPostPage.route,
                  extra: post,
                );
              },
            );
          },
        ),
      );
    }
  }
}
