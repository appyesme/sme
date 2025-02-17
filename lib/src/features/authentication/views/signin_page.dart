import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/text_field.dart';
import '../providers/provider.dart';
import 'signup_page.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  static const String route = '/signin';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Form(
              key: ref.read(authProvider.notifier).signInFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 2.5,
                    child: Image.asset(
                      appLogo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      ref.watch(authProvider);
                      return const AppText(
                        "Sign in",
                        fontSize: 32,
                      );
                    },
                  ),
                  SizedBox(height: 30.px),
                  const AppText(
                    "Please sign in to continue with the app",
                    color: KColors.black50,
                  ),
                  SizedBox(height: 40.px),
                  AppTextField(
                    onChanged: (value) {
                      final provider = ref.read(authProvider.notifier);
                      provider.update((state) => state.copyWith(phoneNumber: value));
                    },
                    validator: (value) => value == null || value.length != 10 ? "Required" : null,
                    hintText: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: AppText("+91"),
                    ),
                  ),
                  SizedBox(height: 20.px),
                  AppButton(
                    onTap: () => ref.read(authProvider.notifier).onLoginTap(context),
                    text: "Get OTP",
                  ),
                  SizedBox(height: 20.px),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        "Don't have an account? ",
                        fontWeight: FontWeight.w400,
                        color: KColors.black60,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ref.read(authProvider.notifier).update((state) => state.copyWith(joinAsEntrepreneur: false));
                          context.pushNamed(SignUpPage.route);
                        },
                        child: const AppText(
                          "Sign Up",
                          fontWeight: FontWeight.w500,
                          color: KColors.purple,
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 20.px),
                  // AppButton(
                  //   onTap: () => checkAuthenticated(context, EnvOptions.USER_TOKEN),
                  //   text: "Bypass USER",
                  // ),
                  // SizedBox(height: 20.px),
                  // AppButton(
                  //   onTap: () => checkAuthenticated(context, EnvOptions.ENTREPR_TOKEN),
                  //   text: "Bypass ENTREPRENEUR",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
