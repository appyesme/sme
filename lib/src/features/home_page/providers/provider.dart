import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_config.dart';
import '../../../core/shared/auth_handler.dart';
import '../../../services/api_services/auth_api.dart';
import '../../../services/api_services/posts_apis.dart';
import '../../add_post_page/models/post_model.dart';
import '../../landing_page/views/landing_page.dart';
import 'state.dart';

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>((ref) {
  final notifier = HomeNotifier()
    ..getPosts()
    ..verifyJwtTokenExpiration();

  notifier.scrollController.addListener(notifier.fetchNextPage);
  ref.onDispose(() {
    notifier.scrollController.removeListener(notifier.fetchNextPage);
    notifier.scrollController.dispose();
  });
  return notifier;
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void setState(HomeState value) => state = value;
  late final scrollController = ScrollController();

  final double _loadMoreThreshold = 200.0;
  int _page = 0;
  bool _isFetchingPosts = false;
  bool noMorePosts = false;

  Future<void> verifyJwtTokenExpiration() async {
    final valid = await AuthApi.verifyJwtTokenExpiration();
    if (!valid && navigatorKey.currentContext != null) {
      logOut(navigatorKey.currentContext!, () => navigatorKey.currentContext!.goNamed(LandingPage.route));
    }
  }

  void fetchNextPage() async {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - _loadMoreThreshold) {
      if (_isFetchingPosts || noMorePosts) return;

      _isFetchingPosts = true;
      final posts = await getPosts();
      _isFetchingPosts = false;

      if (posts == null || posts.isEmpty) {
        noMorePosts = true;
      } else if (posts.length < PostsApi.limit) {
        noMorePosts = true;
      }
    }
  }

  Future<List<PostModel>?> getPosts({bool refresh = false}) async {
    if (refresh) _page = 0;
    final posts = (await PostsApi.getPosts(page: _page)) ?? <PostModel>[];
    final updated = refresh ? posts : [...(state.posts ?? <PostModel>[]), ...posts];
    setState(state.copyWith(posts: updated));
    _page++;
    return posts;
  }

  void updatePost(PostModel? post) {
    final index = state.posts!.indexWhere((item) => item.id == post?.id);
    final services = [...state.posts!];
    index == -1 ? services.add(post!) : services[index] = post!;
    setState(state.copyWith(posts: services));
  }

  void removePost(String postId) => setState(state.removePost(postId));
}
