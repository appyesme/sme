import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class DropDownItem<T extends Object?> {
  final String id;
  final String? title;
  final T? value;
  const DropDownItem({required this.id, this.title, this.value});

  @override
  bool operator ==(covariant DropDownItem<T> other) {
    if (identical(this, other)) return true;
    return other.id == id && other.title == title && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ value.hashCode;
}

class AppDropDown<T> extends StatelessWidget {
  final DropDownItem<T>? Function() value;
  final String hinttext;
  final List<DropDownItem<T>> items;
  final ValueChanged<DropDownItem<T>?>? onChanged;
  final bool showSearchBar;
  final FormFieldValidator<DropDownItem<T>?>? validator;
  final Widget? icon;
  final Widget? trailing;

  const AppDropDown({
    super.key,
    required this.value,
    required this.hinttext,
    this.items = const [],
    this.onChanged,
    this.showSearchBar = true,
    this.validator,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: DropdownButtonFormField2<DropDownItem<T>>(
        onChanged: onChanged,
        validator: validator,
        hint: AppText(
          hinttext,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          fontSize: 14.px,
          color: KColors.black40,
        ),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.px,
          color: KColors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
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
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          isDense: true,
          filled: true,
          fillColor: KColors.filled,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          elevation: 0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: KColors.black40),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        buttonStyleData: const ButtonStyleData(elevation: 10, decoration: BoxDecoration()),
        items: [
          ...items.map(
            (item) {
              return DropdownMenuItem<DropDownItem<T>>(
                value: item,
                child: AppText(
                  item.title ?? item.id,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
