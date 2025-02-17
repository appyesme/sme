import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services_list_page/models/service_model.dart';

part 'state.freezed.dart';

@freezed
class ServiceDetailsState with _$ServiceDetailsState {
  const factory ServiceDetailsState({
    String? selectedImage,
    ServiceModel? service,
  }) = _ServiceDetailsState;
}
