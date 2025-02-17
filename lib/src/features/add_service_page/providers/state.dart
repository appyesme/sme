import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/file_service/file_service.dart';
import '../../services_list_page/models/service_model.dart';

part 'state.freezed.dart';

// ignore: constant_identifier_names
enum ServiceStatus { PUBLISHED, DRAFTED }

@freezed
class AddServiceState with _$AddServiceState {
  const AddServiceState._();

  const factory AddServiceState({
    List<FileX>? images,
    @Default(ServiceModel.defaultValue) ServiceModel service,
  }) = _AddServiceState;

  AddServiceState removeImage(int index) {
    final updated = [...images!];
    updated.removeAt(index);
    return copyWith(images: updated);
  }
}
