import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services_list_page/models/service_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

// ignore: constant_identifier_names
enum PostStatus { DRAFTED, PUBLISHED }

@freezed
class PostModel with _$PostModel {
  static const PostModel defaultValue = PostModel();

  const factory PostModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "service_id") String? serviceId,
    String? description,
    @Default(PostStatus.DRAFTED) PostStatus? status,
    @Default(0) @JsonKey(name: 'total_likes') int totalLikes,
    Author? author,
    @Default(false) bool liked,
    @JsonKey(name: 'medias') @Default([]) List<PostMedia> medias,
    ServiceModel? service,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}

@freezed
class Author with _$Author {
  const factory Author({
    String? id,
    String? email,
    String? name,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phone,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

@freezed
class PostMedia with _$PostMedia {
  const factory PostMedia({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "post_id") String? postId,
    @JsonKey(name: "file_name") String? fileName,
    @JsonKey(name: "storage_path") String? storagePath,
    String? url,
  }) = _PostMedia;

  factory PostMedia.fromJson(Map<String, dynamic> json) => _$PostMediaFromJson(json);
}

@freezed
class PostLike with _$PostLike {
  const factory PostLike({
    String? id,
    @JsonKey(name: 'post_id') String? postId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _PostLike;

  factory PostLike.fromJson(Map<String, dynamic> json) => _$PostLikeFromJson(json);
}
