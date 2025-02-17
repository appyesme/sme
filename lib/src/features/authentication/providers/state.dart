import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/file_service/file_service.dart';

part 'state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(false) bool joinAsEntrepreneur,
    String? fullname,
    @Default([]) List<String> expertises,
    int? totalExperience,
    String? phoneNumber,
    String? aadharCardNumber,
    String? panCardNumber,
    String? email,
    @Default([]) List<FileX> documents,
  }) = _AuthState;

  AuthState setDocuments(List<FileX> value) => copyWith(documents: value);
}
