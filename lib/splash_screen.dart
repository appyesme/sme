import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/constants/kcolors.dart';
import 'src/core/shared/auth_handler.dart';
import 'src/core/shared/shared.dart';
import 'src/utils/dailog_helper.dart';
import 'src/widgets/app_text.dart';
import 'src/widgets/loading_indidactor.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String route = "/splash";

  @override
  Widget build(BuildContext context) {
    DialogHelper.unfocus(context);
    return Scaffold(
      backgroundColor: KColors.purple,
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Spacer(),
          AspectRatio(
            aspectRatio: 2,
            child: Image.asset(
              appLogo,
            ),
          ),
          const SizedBox(height: 20),
          const LoadingIndicator(color: KColors.white),
          const Spacer(),
          const AppText(
            appName,
            fontSize: 32,
            color: KColors.white,
          ),
          const SizedBox(height: 40),
          Consumer(
            builder: (_, WidgetRef ref, __) {
              return TweenAnimationBuilder(
                tween: IntTween(begin: 0, end: 1), // Use IntTween for integer tweening
                duration: const Duration(seconds: 1),
                onEnd: () => checkAuthenticated(context, null),
                builder: (context, value, child) {
                  return const SizedBox();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
