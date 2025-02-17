import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_services/services_api.dart';
import '../../../utils/custom_toast.dart';
import '../../services_list_page/models/service_model.dart';
import 'state.dart';

final serviceDetailsProvider = StateNotifierProvider.autoDispose<ServiceDetailsNotifier, ServiceDetailsState>((ref) {
  final notifier = ServiceDetailsNotifier();
  return notifier;
});

class ServiceDetailsNotifier extends StateNotifier<ServiceDetailsState> {
  ServiceDetailsNotifier() : super(const ServiceDetailsState());

  void setState(ServiceDetailsState value) => state = value;

  void setService(ServiceModel service) => setState(
        state.copyWith(
          service: service,
          selectedImage: service.medias.firstOrNull?.url,
        ),
      );

  void getServiceByID(String serviceID) async {
    final service = await ServicesApi.getServiceByID(serviceID);
    service != null ? setService(service) : Toast.failure("Something is wrong");
  }
}
