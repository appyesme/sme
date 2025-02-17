import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

// ignore: constant_identifier_names
enum PaymentStatus { PENDING, PAID, FAILED, CANCELLED, REFUNDED }

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    String? title,
    String? description,
    String? phone,
    String? email,
    double? amount,
    @Default(PaymentStatus.PENDING) PaymentStatus status,
    @JsonKey(name: "order_id") String? orderId,
    @JsonKey(name: "appointment_id") String? appointmentId,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}
