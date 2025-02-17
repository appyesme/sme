import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services_list_page/models/service_model.dart';

part 'state.freezed.dart';

@freezed
class ServicesListState with _$ServicesListState {
  const ServicesListState._();

  const factory ServicesListState({
    List<ServiceModel>? services,
  }) = _ServicesListState;

  ServicesListState deleteService(String serviceId) {
    final updated = [...services!];
    updated.removeWhere((element) => element.id == serviceId);
    return copyWith(services: updated);
  }
}
