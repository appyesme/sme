import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../env_options.dart';
import '../../../utils/custom_toast.dart';
import '../models/payment_model.dart';
import 'state.dart';

final paymentProvider = StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>((ref) {
  final notifier = PaymentNotifier(ref);
  ref.onDispose(() => notifier._razorpay.clear());
  return notifier;
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref ref;
  PaymentNotifier(this.ref) : super(const PaymentState());

  late final Razorpay _razorpay;
  late PaymentModel? _payment;
  void setResponse(Object response) => state = state.copyWith(object: response);

  void init(PaymentModel payment) {
    _payment = payment;
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, setResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, setResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, setResponse);
    openCheckout();
  }

  void openCheckout() {
    if (_payment == null) {
      Toast.failure("Payment details not available to process.");
    } else {
      var options = {
        'key': EnvOptions.RAZORPAY_KEY_ID,
        'amount': _payment!.amount, // Amount is calculated from backend.
        'currency': "INR",
        'name': _payment?.orderId?.toUpperCase(),
        'description': "Booking service.",
        "order_id": _payment!.orderId,
        'timeout': 120, // in seconds
        'prefill': {
          'contact': _payment!.phone,
          'email': _payment!.email,
        },
        // 'external': {
        //   'wallets': ['tez', 'phonepe', 'paytmmp']
        // }
      };

      _razorpay.open(options);
    }
  }
}
