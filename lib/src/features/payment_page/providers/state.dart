import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState({
    Object? object,
  }) = _PaymentState;
}
