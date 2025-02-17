import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account_model.freezed.dart';
part 'bank_account_model.g.dart';

@freezed
class BankAccountModel with _$BankAccountModel {
  const factory BankAccountModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "account_name") String? accountName,
    @JsonKey(name: "account_number") String? accountNumber,
    @JsonKey(name: "ifsc_code") String? ifscCode,
    String? upi,
  }) = _BankAccountModel;

  factory BankAccountModel.fromJson(Map<String, dynamic> json) => _$BankAccountModelFromJson(json);
}
