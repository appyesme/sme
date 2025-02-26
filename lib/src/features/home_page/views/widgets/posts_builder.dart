import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/shared/shared.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/no_content_message_widget.dart';
import '../../../add_post_page/views/add_post_page.dart';
import '../../providers/provider.dart';
import 'post_card.dart';

class PostsBuilder extends ConsumerStatefulWidget {
  const PostsBuilder({super.key});

  @override
  ConsumerState<PostsBuilder> createState() => _PostsBuilderState();
}

class _PostsBuilderState extends ConsumerState<PostsBuilder> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keeps widget alive in memory

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for keeping alive

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
        padding: EdgeInsets.only(bottom: userType == UserType.USER ? 0 : 10),
        sliver: SliverList.separated(
          key: const PageStorageKey<String>('imageList'),
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
