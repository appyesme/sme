import 'package:freezed_annotation/freezed_annotation.dart';

import '../../add_post_page/models/post_model.dart';

part 'searched_model.freezed.dart';
part 'searched_model.g.dart';

@freezed
class SearchedModel with _$SearchedModel {
  static const SearchedModel defaultValue = SearchedModel();

  const factory SearchedModel({
    @Default([]) List<SearchedService> services,
    @Default([]) List<PostModel> posts,
    @Default([]) List<SearchedUser> users,
  }) = _SearchedModel;

  factory SearchedModel.fromJson(Map<String, dynamic> json) => _$SearchedModelFromJson(json);
}

@freezed
class SearchedService with _$SearchedService {
  const factory SearchedService({
    String? id,
    String? title,
    String? description,
    String? address,
    double? charge,
    String? url,
    @JsonKey(name: "additional_charge") double? additionalCharge,
    @JsonKey(name: "home_available") @Default(false) bool homeAvailable,
    @JsonKey(name: "salon_available") @Default(false) bool salonAvailable,
  }) = _SearchedService;

  factory SearchedService.fromJson(Map<String, dynamic> json) => _$SearchedServiceFromJson(json);
}

@freezed
class SearchedUser with _$SearchedUser {
  const factory SearchedUser({
    String? id,
    String? name,
    @JsonKey(name: "photo_url") String? photoUrl,
    String? expertises,
  }) = _SearchedUser;

  factory SearchedUser.fromJson(Map<String, dynamic> json) => _$SearchedUserFromJson(json);
}
