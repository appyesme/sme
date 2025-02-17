import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.red, Colors.black],
                      ).createShader(bounds);
                    },
                    child: const AppText(
                      "404",
                      color: Colors.white,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w700,
                      fontSize: 72,
                      height: 1.0,
                    ),
                  ),
                  const AppText(
                    "Page not found",
                    color: Colors.black,
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.0,
                  ),
                  const SizedBox(height: 30),
                  const AppText(
                    "Oops! This page seems to be missing.\nPlease check the URL and try again.",
                    textAlign: TextAlign.center,
                    color: Colors.black87,
                  ),
                  const Spacer(),
                  const AppText(
                    "Buddy",
                    color: Colors.black,
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
