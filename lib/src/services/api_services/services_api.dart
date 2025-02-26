import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/service_timings_page/models/service_day_model.dart';
import '../../features/service_timings_page/models/service_timing_model.dart';
import '../../features/services_list_page/models/service_model.dart';
import '../../utils/custom_toast.dart';
import '../file_service/file_service.dart';

@immutable
abstract class ServicesApi {
  static Future<List<ServiceModel>?> getServices({String? profileID}) async {
    String path = "/v1/services";
    final response = await ApiHelper.get(
      path,
      queryParams: {
        if (profileID != null) "profile_id": profileID,
      },
    );

    return response.fold<List<ServiceModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceModel.fromJson(e)).toList(),
    );
  }

  static Future<ServiceModel?> getServiceByID(String serviceID) async {
    String path = "/v1/services/$serviceID";
    final response = await ApiHelper.get(path);
    return response.fold<ServiceModel?>((l) => null, (r) => ServiceModel.fromJson(r.data));
  }

  static Future<List<ServiceDayModel>?> getServiceDays(String serviceId) async {
    String path = "/v1/services/$serviceId/days";
    final response = await ApiHelper.get(path);
    return response.fold<List<ServiceDayModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceDayModel.fromJson(e)).toList(),
    );
  }

  static Future<ServiceModel?> deleteService(String serviceId) async {
    String path = "/v1/services/$serviceId";
    final response = await ApiHelper.delete(path);
    return response.fold<ServiceModel?>((l) => null, (r) => ServiceModel.fromJson(r.data));
  }

  static Future<ServiceModel?> deleteServiceImage(String serviceId, String serviceImageId) async {
    String path = "/v1/services/$serviceId/medias/$serviceImageId";
    final response = await ApiHelper.delete(path);
    return response.fold<ServiceModel?>((l) => null, (r) => ServiceModel.fromJson(r.data));
  }

  static Future<ServiceModel?> createUpdateService(ServiceModel service) async {
    String path = "/v1/services/${service.id ?? ''}";
    final isUpdate = service.id != null;

    final body = {
      if (isUpdate) "id": service.id,
      "title": service.title,
      "expertises": service.expertises,
      "charge": service.charge,
      "additional_charge": service.additionalCharge,
      "home_available": service.homeAvailable,
      "salon_available": service.salonAvailable,
      "description": service.description,
      "address": service.address,
      "status": service.status.name,
    };

    final response = await (isUpdate ? ApiHelper.put(path, body: body) : ApiHelper.post(path, body: body));
    return response.fold<ServiceModel?>((l) => null, (r) => ServiceModel.fromJson(r.data));
  }

  static Future<List<ServiceMediaModel>> uploadServiceMedia(String serviceId, List<FileX> files) async {
    String path = "/v1/services/$serviceId/medias";
    final response = await ApiHelper.uploadFile(path, files);
    return response.fold<List<ServiceMediaModel>>(
      (l) => [],
      (r) => List.from(r.data ?? []).map((e) => ServiceMediaModel.fromJson(e)).toList(),
    );
  }

  static Future<ServiceDayModel?> changeServiceDayEnableStatus(String serviceDayId, bool enabled) async {
    String path = "/v1/services-days/$serviceDayId";
    final response = await ApiHelper.patch(path, body: {"enabled": enabled});
    return response.fold<ServiceDayModel?>((l) => null, (r) => ServiceDayModel.fromJson(r.data));
  }

  static Future<bool?> deleteTiming(String serviceDayId, String serviceTimingId) async {
    String path = "/v1/services-days/$serviceDayId/timings/$serviceTimingId";
    final response = await ApiHelper.delete(path);
    return response.fold<bool?>((l) => Toast.failure(l.message), (r) => r.data != null);
  }

  static Future<List<ServiceTimingModel>?> getTimings(String serviceDayId) async {
    String path = "/v1/services-days/$serviceDayId/timings";
    final response = await ApiHelper.get(path);
    return response.fold<List<ServiceTimingModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceTimingModel.fromJson(e)).toList(),
    );
  }

  static Future<List<ServiceTimingModel>?> saveTimings(String serviceDayId, List<ServiceTimingModel> timings) async {
    String path = "/v1/services-days/$serviceDayId/timings";
    final response = await ApiHelper.put(
      path,
      body: timings.where((i) => i.startTime != null && i.endTime != null).map(
        (item) {
          return {
            "id": item.id,
            "start_time": item.startTime,
            "end_time": item.endTime,
            "people_per_slot": item.peoplePerSlot ?? 1,
            "enabled": item.enabled,
          };
        },
      ).toList(),
    );

    return response.fold<List<ServiceTimingModel>?>(
      (l) => null,
      (r) => List.from(r.data ?? []).map((e) => ServiceTimingModel.fromJson(e)).toList(),
    );
  }
}
