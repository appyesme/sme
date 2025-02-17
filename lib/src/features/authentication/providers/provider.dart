import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

import '../../../core/enums/enums.dart';
import '../../../core/shared/auth_handler.dart';
import '../../../services/api_services/auth_api.dart';
import '../../../services/file_service/file_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/dailog_helper.dart';
import '../../../utils/string_extension.dart';
import '../views/dialog/all_info_correct.dart';
import '../views/dialog/otp_verify_dialog.dart';
import 'state.dart';

final authProvider = StateNotifierProvider.autoDispose<LoginNotifier, AuthState>(
  (ref) {
    final notifier = LoginNotifier(ref);
    return notifier;
  },
);

class LoginNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  LoginNotifier(this.ref) : super(const AuthState());

  void setState(AuthState value) => state = value;

  OtpTimerButtonController controller = OtpTimerButtonController();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void onLoginTap(BuildContext context) async {
    final validated = signInFormKey.currentState?.validate() ?? false;
    if (!validated) return;
    DialogHelper.unfocus(context);
    final phoneNumber = state.phoneNumber!.prefix91();

    DialogHelper.showloading(context);
    final response = await AuthApi.sendOTP(phoneNumber, isSignIn: true);
    DialogHelper.pop(context);
    if (response != null) {
      Toast.success("OTP has sent to $phoneNumber");
      showOtpDialog(
        context,
        onVerifyOtpTap: (otp) async {
          if (otp.length == 4) {
            DialogHelper.showloading(context);
            final result = await AuthApi.verifyOtp(phoneNumber, otp);
            DialogHelper.pop(context); // Close loading dialog.
            DialogHelper.pop(context); // Close OTP dialog.
            if (result != null) {
              Toast.success(result["message"] ?? "Verification failed");
              if (result["token"] != null) {
                checkAuthenticated(context, result["token"]);
              } else {
                context.pop();
              }
            }
          }
        },
      );
    }
  }

  void pickDocuments() async {
    final docs = await FileServiceX.pickImages();
    if (docs == null || docs.isEmpty) return;
    setState(state.setDocuments(docs));
  }

  void update(AuthState Function(AuthState) value) {
    final updated = value(state);
    setState(updated);
  }

  void signUp(BuildContext context) async {
    if (!(signUpFormKey.currentState?.validate() ?? false)) return;
    if (state.joinAsEntrepreneur && state.documents.isEmpty) return Toast.warning("Select certificates");
    DialogHelper.unfocus(context);

    final allInfoCorrect = state.joinAsEntrepreneur ? await showAllInfoCorrectDialog(context) : true;
    if (allInfoCorrect != true) return;

    final phoneNumber = state.phoneNumber!.prefix91();

    DialogHelper.showloading(context);
    final sendOtpResponse = await AuthApi.sendOTP(phoneNumber, isSignIn: false);
    DialogHelper.pop(context);

    if (sendOtpResponse == null) return;

    Toast.success("OTP has been sent to $phoneNumber");

    showOtpDialog(
      context,
      onVerifyOtpTap: (otp) async {
        if (otp.length == 4) {
          DialogHelper.showloading(context);
          final otpVerified = await AuthApi.verifyOtp(phoneNumber, otp);
          if (otpVerified != null) {
            // If OTP verification is successful, then only create an account.
            final payload = {
              "name": state.fullname,
              "email": state.email,
              "phone_number": phoneNumber,
              "user_type": state.joinAsEntrepreneur ? UserType.ENTREPRENEUR.name : UserType.USER.name,
              if (state.joinAsEntrepreneur) ...{
                "total_work_experience": state.totalExperience,
                "expertises": state.expertises,
                "aadhar_number": state.aadharCardNumber,
                "pan_number": state.panCardNumber,
              }
            };

            final accountCreated = await AuthApi.signUp(payload);

            if (accountCreated != null) {
              // UPload Documents only if the signup user is "Entrepreneur"
              if (state.joinAsEntrepreneur) {
                await AuthApi.uploadVerificationDocs(
                  accountCreated["id"],
                  state.documents,
                );
              }
              Toast.success(accountCreated["message"] ?? '');
              DialogHelper.pop(context); // remove loading dialog.
            }

            if (accountCreated == null) return;

            // If "Entrepreneur", token is null otherwise token will be available.
            DialogHelper.pop(context); // Close OTP dialog.
            if (accountCreated["token"] != null) checkAuthenticated(context, accountCreated["token"]);
          }

          DialogHelper.pop(context); // Go back to signin page.
        }
      },
    );
  }

  void requestRetryOtp() async {
    controller.loading();
    final result = await AuthApi.resendOtp(state.phoneNumber!.prefix91());
    if (!result) Toast.failure("Something went wrong, please retry");
    result ? controller.startTimer() : controller.enableButton();
  }
}
