import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/add_post_page/models/post_model.dart';
import '../../utils/custom_toast.dart';
import '../file_service/file_service.dart';

@immutable
abstract class PostsApi {
  static int limit = 15;

  static Future<List<PostModel>?> getPosts({String? profileID, int page = 0}) async {
    String path = "/posts";
    final response = await ApiHelper.get(
      path,
      queryParams: {
        "page": page,
        "limit": PostsApi.limit,
        if (profileID != null) "profile_id": profileID,
      },
    );

    return response.fold(
      (error) => null,
      (success) => List.from(success.data ?? []).map((e) => PostModel.fromJson(e)).toList(),
    );
  }

  static Future<bool?> deletePost(String postId) async {
    String path = "/posts/$postId";
    final resp = await ApiHelper.delete(path);
    return resp.fold<bool?>((l) => Toast.failure<bool?>(l.message), (r) => r.data != null);
  }

  static Future<PostMedia?> deletePostMedia(String postId, String mediaId) async {
    String path = "/posts/$postId/medias/$mediaId";
    final response = await ApiHelper.delete(path);
    return response.fold<PostMedia?>((l) => null, (r) => PostMedia.fromJson(r.data));
  }

  static Future<PostModel?> createUpdatePost(Map<String, dynamic> data) async {
    String path = "/posts";
    final response = await ApiHelper.post(path, body: data);
    return response.fold<PostModel?>((l) => null, (r) => PostModel.fromJson(r.data));
  }

  static Future<List<PostMedia>> uploadPostMedias(String postId, List<FileX> files) async {
    final path = "/posts/$postId/medias";
    final response = await ApiHelper.uploadFile(path, files);

    return response.fold<List<PostMedia>>(
      (l) => [],
      (r) => List.from(r.data ?? []).map((e) => PostMedia.fromJson(e)).toList(),
    );
  }

  static Future<PostLike?> likePost(String postId) async {
    String path = "/posts/$postId/likes";
    final response = await ApiHelper.post(path);
    return response.fold<PostLike?>((l) => null, (r) => PostLike.fromJson(r.data));
  }

  static Future<PostLike?> unlikePost(String postId) async {
    String path = "/posts/$postId/likes";
    final response = await ApiHelper.delete(path);
    return response.fold<PostLike?>((l) => null, (r) => PostLike.fromJson(r.data));
  }
}
