import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class AppDatePicker extends StatelessWidget {
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? selectedDate;
  final Color textColor;
  final ValueChanged<DateTime?> onChanged;
  final String dateFormatPattern;
  final Widget? trailing;

  const AppDatePicker({
    super.key,
    this.hintText = "Select date",
    this.textColor = const Color(0xFFFFFFFF),
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateFormatPattern = 'd LLLL y',
    this.trailing,
    this.selectedDate,
  });

  String get _text {
    if (selectedDate == null) return hintText;
    return DateFormat(dateFormatPattern).format(DateTime.parse(selectedDate!));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        DateTime? result = await datePicker(context);
        if (result != null) onChanged(result);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: KColors.filled,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: KColors.white10, width: 1.5),
        ),
        child: AppText(
          _text,
          textAlign: TextAlign.left,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: selectedDate == null ? KColors.grey : KColors.white,
        ),
      ),
    );
  }

  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2300),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      barrierColor: Colors.black45,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: ThemeData(
              datePickerTheme: DatePickerThemeData(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: KColors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                dayStyle: const TextStyle(color: KColors.white),
                weekdayStyle: const TextStyle(color: KColors.white80),
                yearStyle: const TextStyle(color: KColors.white),
                headerHeadlineStyle: const TextStyle(color: KColors.grey, fontSize: 18),
                cancelButtonStyle: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(100, 45)),
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                      color: KColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                confirmButtonStyle: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(KColors.white),
                  minimumSize: WidgetStatePropertyAll(Size(100, 45)),
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(
                      fontSize: 18,
                      color: KColors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              colorScheme: const ColorScheme.dark(
                // Switch to a dark color scheme
                primary: KColors.secondary, // Highlight color for selected date
                onPrimary: KColors.white, // Text color for selected date
                surface: KColors.bgColor, // Background color for calendar
                onSurface: KColors.white, // Text color for unselected dates
                secondary: KColors.white, // Color for year picker
              ),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
