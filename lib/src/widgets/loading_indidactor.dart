import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  const LoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Column(
        children: [
          const Spacer(),
          CircularProgressIndicator(
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            color: color ?? KColors.purple,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
