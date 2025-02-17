import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile_page/models/user_model.dart';

part 'state.freezed.dart';

@freezed
class FavouritesState with _$FavouritesState {
  const factory FavouritesState({
    List<UserModel>? users,
  }) = _FavouritesState;
}
