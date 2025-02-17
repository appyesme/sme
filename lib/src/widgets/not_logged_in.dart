import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/kcolors.dart';
import '../core/shared/shared.dart';
import '../features/authentication/views/signin_page.dart';
import 'app_button.dart';
import 'app_text.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Welcome icon or avatar
          const Icon(
            Icons.person_outline_rounded,
            size: 80,
            color: KColors.bgColor,
          ),
          const SizedBox(height: 20),
          // Engaging message
          const AppText(
            "Welcome to $appName",
            textAlign: TextAlign.center,
            fontSize: 18,
            color: Colors.black87,
          ),
          const SizedBox(height: 10),
          const AppText(
            "Sign in to access personalized recommendations, save your favorite content, "
            "and explore exclusive features crafted just for you.",
            textAlign: TextAlign.center,
            fontSize: 12,
            color: KColors.black60,
          ),
          const SizedBox(height: 30),
          // CTA button for login
          AppButton(
            onTap: () {
              context.goNamed(
                SignInPage.route,
              );
            },
            text: "Login in Now",
            radius: 60,
            height: 40,
            fontSize: 14,
            width: 80,
          ),
          const SizedBox(height: 20),
          const AppText(
            "Join, thousands of users already enjoying the full experience!",
            textAlign: TextAlign.center,
            fontSize: 12,
            color: KColors.black40,
          ),
        ],
      ),
    );
  }
}
