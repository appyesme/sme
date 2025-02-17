import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/shared.dart';
import '../../../services/api_services/services_api.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../services_list_page/models/service_model.dart';
import 'state.dart';

final servicesListProvider = StateNotifierProvider.autoDispose<ServicesListNotifier, ServicesListState>((ref) {
  final notifier = ServicesListNotifier()..getServices();
  return notifier;
});

class ServicesListNotifier extends StateNotifier<ServicesListState> {
  ServicesListNotifier() : super(const ServicesListState());

  void setState(ServicesListState value) => state = value;

  void update(ServicesListState Function(ServicesListState state) value) {
    final updated = value(state);
    setState(updated);
  }

  Future<void> getServices() async {
    final services = await ServicesApi.getServices(profileID: userId);
    setState(state.copyWith(services: services ?? state.services ?? <ServiceModel>[]));
  }

  Future<void> deleteService(BuildContext context, String serviceId) async {
    final canDelete = await DialogHelper.showDeleteWarning(context);
    if (canDelete == true) {
      DialogHelper.showloading(context);
      final service = await ServicesApi.deleteService(serviceId);
      DialogHelper.pop(context);
      if (service?.id != null) {
        setState(state.deleteService(serviceId));
        DialogHelper.pop(context); // GO back to list page
      } else {
        Toast.failure("Unable to delete service.");
      }
    }
  }

  void updateService(ServiceModel? service) {
    final index = state.services!.indexWhere((item) => item.id == service?.id);
    final services = [...state.services!];
    index == -1 ? services.add(service!) : services[index] = service!;
    setState(state.copyWith(services: services));
  }
}
