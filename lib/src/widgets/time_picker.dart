import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';

class AppTimePicker extends StatelessWidget {
  final String? selectedTime;
  final String? value;
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<String> onChanged;
  final String pattern;
  final Widget? trailing;

  const AppTimePicker({
    super.key,
    this.selectedTime,
    this.value,
    this.hintText = "Select time",
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onChanged,
    this.pattern = 'hh:mm a',
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? timeResp = await timePicker(context);
        if (timeResp == null) return;

        /// result.hour will returns sometime 9:09 but
        /// we need hour with 2 digit thats why here used condition and formation
        /// So _hour will become 09:09

        var hour = timeResp.hour.toString().length == 1 ? "0${timeResp.hour}" : timeResp.hour.toString();
        var minuteValue = timeResp.format(context).split(" ")[0].split(":")[1];
        var minute = minuteValue.toString().length == 1 ? "0$minuteValue" : minuteValue.toString();
        var time = "$hour:$minute:00";

        final today = DateTime.now().toString().split(" ").first;
        final datetime = "${today}T$time";
        onChanged.call(datetime);
      },
      child: Container(
        height: 45,
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: AppText(
          selectedTime == null ? hintText : DateFormat(pattern).format(DateTime.parse(selectedTime!)),
          textAlign: TextAlign.center,
          color: selectedTime == null ? Colors.grey : KColors.black,
        ),
      ),
    );
  }

  Future<TimeOfDay?> timePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
