import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? height;
  final String? fontFamily;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.height,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : overflow,
      style: TextStyle(
        fontSize: (fontSize ?? 14).px,
        decoration: decoration,
        height: height,
        fontFamily: fontFamily ?? "Poppins",
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? KColors.black,
      ),
    );
  }
}
