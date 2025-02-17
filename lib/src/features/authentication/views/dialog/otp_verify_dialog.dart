import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../providers/provider.dart';

Future<String?> showOtpDialog(BuildContext context, {required ValueChanged<String> onVerifyOtpTap}) {
  String otp = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black38,
    builder: (context) {
      return Consumer(
        builder: (_, WidgetRef ref, __) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                    "OTP Verification",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.px),
                  const AppText(
                    "We have sent otp to your phone number. Please enter that to continue.",
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.px),
                  Pinput(
                    onChanged: (value) => otp = value,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: KColors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: KColors.black60),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.px),
                  OtpTimerButton(
                    controller: ref.read(authProvider.notifier).controller,
                    onPressed: ref.read(authProvider.notifier).requestRetryOtp,
                    duration: 30,
                    loadingIndicator: const CircularProgressIndicator(strokeWidth: 2),
                    text: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: KColors.black60,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    buttonType: ButtonType.text_button,
                  ),
                  SizedBox(height: 10.px),
                  AppButton(
                    onTap: () => otp.length != 4 ? () {} : onVerifyOtpTap(otp),
                    text: "Verify",
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
