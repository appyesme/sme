import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/shared.dart';
import '../../../services/api_services/posts_apis.dart';
import '../../../services/api_services/services_api.dart';
import '../../../services/file_service/file_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../home_page/providers/provider.dart';
import '../models/post_model.dart';
import '../views/widgets/service_selection_sheet.dart';
import 'state.dart';

// ignore: constant_identifier_names
const int MAX_POST_MEDIA_COUNT = 4;

final addPostProivder = StateNotifierProvider.autoDispose<AddPostNotifier, AddPostState>(
  (ref) {
    final notifier = AddPostNotifier(ref)
      ..getMyServices()
      ..getDraftPosts();

    ref.onDispose(() {
      notifier.descriptionController.dispose();
    });

    return notifier;
  },
);

class AddPostNotifier extends StateNotifier<AddPostState> {
  final Ref ref;
  AddPostNotifier(this.ref) : super(const AddPostState());

  void setState(AddPostState value) => state = value;

  late final TextEditingController descriptionController = TextEditingController();

  void update(AddPostState Function(AddPostState state) value) {
    final updated = value(state);
    setState(updated);
  }

  Future<void> getMyServices() async {
    final result = await ServicesApi.getServices(profileID: userId);
    setState(state.copyWith(services: result));
  }

  Future<void> getDraftPosts() async {
    // final result = await PostsApi.getDraftPosts();
    // setState(state.copyWith(draftPosts: result));
  }

  void pickImages() async {
    final images = await FileServiceX.pickImages();
    if (images == null || images.isEmpty) return;

    final totalSelectedCount = [...state.images ?? <FileX>[], ...state.post.medias].length;
    final remainCount = MAX_POST_MEDIA_COUNT - totalSelectedCount;
    final filtered = images.length <= remainCount ? images : images.sublist(0, remainCount);
    final all = [...state.images ?? <FileX>[], ...filtered];
    setState(state.copyWith(images: all));
  }

  void editPost(PostModel post) {
    descriptionController.text = post.description ?? '';
    setState(state.copyWith(post: post));
  }

  void deleteMedia(BuildContext context, int index, {PostMedia? media}) async {
    if (media?.id != null) {
      DialogHelper.showloading(context);
      final deleted = await PostsApi.deletePostMedia(media!.postId!, media.id!);
      final medias = [...state.post.medias];
      medias.removeWhere((element) => element.id == deleted!.id);
      final updated = state.post.copyWith(medias: medias);
      setState(state.copyWith(post: updated));
      DialogHelper.pop(context);
    } else {
      setState(state.removeMedia(index));
    }
  }

  void deletePost(BuildContext context, String postId) async {
    DialogHelper.showloading(context);
    final result = await PostsApi.deletePost(postId);
    DialogHelper.pop(context);
    if (result != null && result) {
      ref.read(homeProvider.notifier).removePost(postId);
      context.pop(); // Go back to select challenges page.
    }
  }

  void selectService(BuildContext context) async {
    final service = await showSelectServiceSheet(context);
    if (service != null) {
      final updated = state.copyWith(post: state.post.copyWith(service: service));
      setState(updated);
    }
  }

  Future<void> submit(BuildContext context, WidgetRef ref, PostStatus status) async {
    final post = state.post;
    final images = [...state.images ?? [], ...post.medias];

    final isPublished = status == PostStatus.PUBLISHED;
    if ((images.isEmpty && isPublished) /* || post.description == null */) return;

    DialogHelper.unfocus(context);
    final payload = {
      "id": post.id,
      "service_id": post.service?.id,
      // "description": post.description,
      "status": status.name,
    };

    // CREATE or UPDATE Post
    DialogHelper.showloading(context);
    var createdPost = await PostsApi.createUpdatePost(payload);

    if (createdPost?.id == null) {
      Toast.failure(post.id == null ? "Unable to create post" : "Unable to update post");
    } else {
      if (state.images != null && state.images!.isNotEmpty) {
        final medias = await PostsApi.uploadPostMedias(createdPost!.id!, state.images!);
        createdPost = createdPost.copyWith(medias: medias);
      }
      DialogHelper.pop(context);
      ref.read(homeProvider.notifier).updatePost(createdPost);
    }
    DialogHelper.pop(context);
  }
}
