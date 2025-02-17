import 'package:freezed_annotation/freezed_annotation.dart';

import '../../add_post_page/models/post_model.dart';

part 'state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    List<PostModel>? posts,
  }) = _HomeState;

  HomeState removePost(String postId) {
    final updated = posts?.where((element) => element.id != postId).toList();
    return copyWith(posts: updated);
  }
}
