import 'package:flutter/material.dart';

import '../../../payment_page/models/payment_model.dart';
import '../../../payment_page/views/payment_page.dart';

Future<PaymentStatus?> showRzpInitDialog(BuildContext context, PaymentModel payment) {
  return showDialog<PaymentStatus?>(
    context: context,
    useSafeArea: true,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (context) => Dialog(
      child: PopScope(
        canPop: false,
        child: PaymentPage(
          payment: payment,
        ),
      ),
    ),
  );
}
