import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class NoContentMessageWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  const NoContentMessageWidget({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: KColors.grey,
            size: 84,
          ),
          AppText(
            message,
            color: KColors.grey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
