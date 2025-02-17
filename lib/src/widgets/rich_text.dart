import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/constants/kcolors.dart';

class AppRichText extends StatelessWidget {
  final int? maxLines;
  final TextOverflow? overflow;
  final List<RichTextEntity> texts;

  const AppRichText({
    super.key,
    required this.texts,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        children: texts.map(
          (text) {
            return TextSpan(
              text: text.text,
              recognizer: TapGestureRecognizer()..onTap = text.onTap,
              style: TextStyle(
                fontFamily: text.fontFamily ?? "Poppins",
                color: text.color ?? KColors.black,
                decoration: text.decoration,
                fontSize: text.fontSize ?? 18,
                fontWeight: text.fontWeight,
                height: text.height,
                fontStyle: text.fontStyle,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class RichTextEntity {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final double? height;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final VoidCallback? onTap;

  RichTextEntity(
    this.text, {
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.decoration,
    this.height,
    this.fontStyle,
    this.fontFamily,
    this.onTap,
  });
}
