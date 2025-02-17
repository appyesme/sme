import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/searched_model.dart';

part 'state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    SearchedModel? searched,
  }) = _SearchState;
}
