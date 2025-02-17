import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/kcolors.dart';
import '../../providers/provider.dart';

class CalenderWidget extends ConsumerWidget {
  const CalenderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableDays = ref.watch(appointmentProvider.select((value) => value.days));
    final selectedDay = ref.watch(appointmentProvider.select((value) => value.selectedDay)) ?? DateTime.now();

    return TableCalendar(
      onDaySelected: (day, focus) => ref.read(appointmentProvider.notifier).onDaySelected(day),
      enabledDayPredicate: (day) {
        if (availableDays == null || availableDays.isEmpty) return false;
        return day.isAfter(DateTime.now()) && availableDays.map((e) => e.day).contains(day.weekday);
      },
      availableGestures: AvailableGestures.horizontalSwipe,
      focusedDay: selectedDay,
      currentDay: DateTime.now(),
      // selectedDayPredicate: (day) {
      //   final formated = "$day".toDate();
      //   final selected = "$selectedDay".toDate();
      //   return formated == selected ? true : false;
      // },
      calendarFormat: CalendarFormat.month,
      firstDay: DateTime.now().subtract(const Duration(days: 1)),
      lastDay: DateTime.utc(2030, 3, 14),
      calendarStyle: const CalendarStyle(
        markerDecoration: BoxDecoration(
          color: KColors.secondary,
          shape: BoxShape.circle,
        ),
        markersAlignment: Alignment.center,
        markersMaxCount: 1,
        markerSize: 6,
        cellMargin: EdgeInsets.all(5),
        markersOffset: PositionedOffset(top: 0, bottom: 0),
        todayDecoration: BoxDecoration(
          color: KColors.black10,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: Colors.black),
        selectedTextStyle: TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: KColors.purple,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekHeight: 50,
      rowHeight: 50,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        headerPadding: EdgeInsets.zero,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
        leftChevronMargin: EdgeInsets.symmetric(vertical: 15),
        rightChevronMargin: EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
