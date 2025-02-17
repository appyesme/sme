import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String?>? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final double radius;
  final bool isPassword;
  final String? initialValue;
  final List<TextInputFormatter> inputFormatters;
  final Widget? icon;
  final Widget? trailing;
  final Color? filledColor;
  final Color? borderColor;
  final bool unfocusOnTapOutside;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    this.keyboardType,
    this.textAlign,
    this.maxLines,
    this.minLines,
    this.validator,
    this.radius = 8,
    this.isPassword = false,
    this.initialValue,
    this.inputFormatters = const [],
    this.icon,
    this.trailing,
    this.filledColor,
    this.borderColor,
    this.unfocusOnTapOutside = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: (value) => onChanged?.call(value.trim().isEmpty ? null : value),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      minLines: minLines ?? 1,
      maxLines: minLines ?? maxLines ?? 1,
      enabled: enabled,
      autofocus: autofocus,
      maxLength: maxLength,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.px,
        color: KColors.black,
        fontWeight: FontWeight.w400,
      ),
      onTapOutside: (event) => !unfocusOnTapOutside ? null : FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: filledColor ?? KColors.filled,
        contentPadding: contentPadding ?? const EdgeInsets.all(16),
        hintText: hintText,
        hintMaxLines: 1,
        hintStyle: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          fontSize: 14.px,
          color: KColors.black40,
        ),
        prefixIcon: icon,
        prefixIconConstraints: BoxConstraints(maxHeight: 40.sw, maxWidth: 40.sw),
        suffixIcon: trailing,
        errorStyle: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          color: Colors.red,
          fontSize: 12.px,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor ?? KColors.black10, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor ?? KColors.black10, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor ?? KColors.black10, width: 0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor ?? Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor ?? Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
