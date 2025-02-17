import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double fontSize;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;

  const AppButton({
    super.key,
    this.text,
    this.onTap,
    this.child,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.backgroundColor = KColors.purple,
    this.borderColor = Colors.transparent,
    this.radius = 8.0,
    this.width = double.infinity,
    this.height = 50,
    this.elevation = 1.0,
    this.padding,
    this.fontWeight,
  }) : assert(text == null || child == null);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(padding),
        elevation: WidgetStateProperty.all(elevation),
        animationDuration: const Duration(milliseconds: 100),
        minimumSize: WidgetStateProperty.all(Size(width.px, height.px)),
        overlayColor: WidgetStateProperty.all(const Color(0x67424242)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: borderColor!),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(backgroundColor),
      ),
      child: child ??
          AppText(
            text!,
            fontSize: fontSize.px,
            color: textColor,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
    );
  }
}
