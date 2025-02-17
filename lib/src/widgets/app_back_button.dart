import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/app_icons.dart';
import '../core/constants/kcolors.dart';
import 'svg_icon.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  const AppBackButton({super.key, this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: KColors.black10,
          shape: BoxShape.circle,
        ),
        child: SvgIcon(
          SvgIcons.arrowback,
          color: iconColor ?? KColors.black,
          size: 24.px,
        ),
      ),
    );
  }
}
