import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/file_service/file_service.dart';
import '../../services_list_page/models/service_model.dart';
import '../models/post_model.dart';

part 'state.freezed.dart';

@freezed
class AddPostState with _$AddPostState {
  const AddPostState._();

  const factory AddPostState({
    List<ServiceModel>? services,
    List<FileX>? images,
    @Default([]) List<String> certificates,
    @Default(false) bool update,
    @Default(PostModel.defaultValue) PostModel post,
    String? searchtext,
  }) = _AddPostState;

  AddPostState removeMedia(int index) {
    final updated = [...images!];
    updated.removeAt(index);
    return copyWith(images: updated);
  }
}

@freezed
class CroppedImage with _$CroppedImage {
  const factory CroppedImage({
    required String path,
    Uint8List? croppedImage,
  }) = _CroppedImage;
}
