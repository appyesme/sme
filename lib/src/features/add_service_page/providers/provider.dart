import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_services/services_api.dart';
import '../../../services/file_service/file_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../services_list_page/models/service_model.dart';
import '../../services_list_page/providers/provider.dart';
import 'state.dart';

final createServiceProvider = StateNotifierProvider.autoDispose<AddServiceNotifier, AddServiceState>((ref) {
  final notifier = AddServiceNotifier(ref);
  return notifier;
});

// ignore: constant_identifier_names
const MAX_SERVICE_IMAGE_COUNT = 4;

class AddServiceNotifier extends StateNotifier<AddServiceState> {
  final Ref ref;
  AddServiceNotifier(this.ref) : super(const AddServiceState());

  void setState(AddServiceState value) => state = value;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void update(AddServiceState Function(AddServiceState state) value) {
    final updated = value(state);
    setState(updated);
  }

  void updateService(ServiceModel Function(ServiceModel state) value) {
    final updated = value(state.service);
    setState(state.copyWith(service: updated));
  }

  void pickImages() async {
    final images = await FileServiceX.pickImages();
    if (images == null || images.isEmpty) return;

    final totalSelectedCount = [...state.images ?? <FileX>[], ...state.service.medias].length;
    final remainCount = MAX_SERVICE_IMAGE_COUNT - totalSelectedCount;
    final filtered = images.length <= remainCount ? images : images.sublist(0, remainCount);
    final all = [...state.images ?? <FileX>[], ...filtered];
    setState(state.copyWith(images: all));
  }

  void removeImage(BuildContext context, int index, {ServiceMediaModel? media}) async {
    if (media?.id != null) {
      DialogHelper.showloading(context);
      final deleted = await ServicesApi.deleteServiceImage(media!.serviceId!, media.id!);
      final medias = [...state.service.medias];
      medias.removeWhere((element) => element.id == deleted!.id);
      final updated = state.service.copyWith(medias: medias);
      setState(state.copyWith(service: updated));
      DialogHelper.pop(context);
    } else {
      setState(state.removeImage(index));
    }
  }

  Future<void> createUpdateService(BuildContext context, ServiceStatus status) async {
    final validated = formKey.currentState?.validate() ?? false;
    if (!validated) return;

    final images = [...state.images ?? [], state.service.medias];

    if (images.isEmpty) return Toast.failure("Select images");
    if (!state.service.homeAvailable && !state.service.salonAvailable) {
      return Toast.failure("Select atleast one service type");
    }

    DialogHelper.unfocus(context);
    DialogHelper.showloading(context);
    var service = await ServicesApi.createUpdateService(state.service.copyWith(status: status));
    if (service?.id != null) {
      if (state.images != null && state.images!.isNotEmpty) {
        final medias = await ServicesApi.uploadServiceMedia(service!.id!, state.images!);
        service = service.copyWith(medias: medias);
      }

      context.pop();
      Toast.success("Service saved successfully.");
      service = service?.copyWith(medias: [...state.service.medias, ...service.medias]);
      ref.read(servicesListProvider.notifier).updateService(service);
    } else {
      Toast.failure("Unable to create service");
    }

    context.pop();
  }
}
