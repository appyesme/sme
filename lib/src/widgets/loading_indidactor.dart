// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double scale;
  final double strokeWidth;
  const LoadingIndicator({
    super.key,
    this.color,
    this.scale = 50,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: scale,
      width: scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: strokeWidth,
            strokeCap: StrokeCap.round,
            color: color ?? KColors.bgColor,
          ),
        ],
      ),
    );
  }
}
