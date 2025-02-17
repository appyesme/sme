import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../providers/provider.dart';

Future<bool?> showFinalPriceDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    useSafeArea: true,
    // elevation: 0,
    barrierColor: KColors.black60,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              color: KColors.bgColor,
              alignment: Alignment.center,
              child: const AppText(
                "Total Charges for this service",
                fontSize: 16,
                color: KColors.white,
              ),
            ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                final price = ref.watch(appointmentProvider.select((value) => value.totalPrice));

                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (price == null) ...[
                        const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CupertinoActivityIndicator(),
                        ),
                      ] else ...[
                        AppText(
                          'Rs. ${price + 87.89}',
                          fontSize: 24,
                          color: KColors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                        const SizedBox(height: 10),
                        AppText(
                          'Rs. $price',
                          color: KColors.secondary,
                          fontSize: 32,
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          onTap: () => context.pop(true),
                          text: "Pay",
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
