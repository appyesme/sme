import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../utils/dailog_helper.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../models/payment_model.dart';
import '../providers/provider.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final PaymentModel payment;
  const PaymentPage({super.key, required this.payment});

  static const String route = '/payments';

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    DialogHelper.unfocus(context);
    controller = AnimationController(
      vsync: this,
      lowerBound: 30,
      upperBound: 50,
      duration: const Duration(seconds: 2),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();

    // INIT PROVIDER
    ref.read(paymentProvider.notifier).init(widget.payment);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _buildCircle(controller.value, 100, 1.0),
                  _buildCircle(controller.value, 70, 0.6),
                  _buildCircle(controller.value, 50, 0.3),
                  Consumer(
                    builder: (_, ref, __) {
                      final object = ref.watch(paymentProvider.select((value) => value.object));
                      if (object is PaymentSuccessResponse) {
                        return Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 64.px,
                          color: Colors.green,
                        );
                      }
                      return const SizedBox();
                    },
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Consumer(
            builder: (_, ref, __) {
              final object = ref.watch(paymentProvider.select((value) => value.object));
              return getStatusWidget(object);
            },
          )
        ],
      ),
    );
  }

  Widget getStatusWidget(Object? value) {
    if (value is PaymentSuccessResponse) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              "Payment Success",
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            AppButton(
              onTap: () => context.pop(PaymentStatus.PAID),
              text: "Check Appointments",
              fontSize: 12,
              height: 45,
              radius: 60,
              backgroundColor: Colors.green,
            )
          ],
        ),
      );
    } else if (value is PaymentFailureResponse) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              "Payment failed",
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            AppText(
              "Reason: ${value.message ?? ''}",
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () => context.pop(PaymentStatus.FAILED),
                    text: "Close",
                    fontSize: 12,
                    height: 45,
                    backgroundColor: KColors.black10,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: AppButton(
                    onTap: () => ref.read(paymentProvider.notifier).openCheckout(),
                    text: "Try Again",
                    fontSize: 12,
                    height: 45,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else if (value is ExternalWalletResponse) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText(
            "Payment failed",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10),
          AppText(
            "Reason: Something went wrong from ${value.walletName ?? ''}",
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              AppButton(
                onTap: () => context.pop(PaymentStatus.FAILED),
                text: "Close",
                width: 150,
              ),
              const SizedBox(width: 5),
              AppButton(
                onTap: () => ref.read(paymentProvider.notifier).openCheckout(),
                text: "Try Again",
                width: 150,
              ),
            ],
          )
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: AppText(
          "Payment Processing",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget _buildCircle(double animationValue, double heightPercentage, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: animationValue / heightPercentage, // Bouncing effect
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                KColors.purple, // First color of the gradient
                Colors.black87, // Second color of the gradient
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
