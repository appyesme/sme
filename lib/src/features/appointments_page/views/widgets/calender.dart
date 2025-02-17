import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../utils/string_extension.dart';
import '../../../../widgets/app_text.dart';
import '../../providers/provider.dart';

class CalendarWidget extends ConsumerWidget {
  final bool isWeekView;
  const CalendarWidget({super.key, required this.isWeekView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentsProvider);
    final selectedDay = state.selectedDay ?? DateTime.now();

    return TableCalendar(
      onDaySelected: (day, focus) {
        ref.read(appointmentsProvider.notifier).onDaySelected(day, focus);
        if (!isWeekView) GoRouter.of(context).pop();
      },
      availableGestures: AvailableGestures.horizontalSwipe,
      focusedDay: selectedDay,
      currentDay: DateTime.now(),
      selectedDayPredicate: (day) {
        final formated = "$day".toDate();
        final selected = "$selectedDay".toDate();
        return formated == selected ? true : false;
      },
      // eventLoader: (day) {
      //   final events = state.challenges ?? [];
      //   final filtered = events.where((e) => "$day".toDate() == "${e.challengeDate}".toDate());
      //   return [if (filtered.isNotEmpty) filtered.first];
      // },
      calendarFormat: isWeekView ? CalendarFormat.week : CalendarFormat.month,
      firstDay: DateTime.utc(2010, 10, 16),
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
        todayDecoration: BoxDecoration(color: Colors.transparent),
        todayTextStyle: TextStyle(color: Colors.black),
        selectedTextStyle: TextStyle(color: Colors.black),
        selectedDecoration: BoxDecoration(
          color: KColors.grey1,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekHeight: isWeekView ? 0 : 30,
      rowHeight: isWeekView ? 55 : 40,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        headerPadding: EdgeInsets.symmetric(horizontal: 16),
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
        leftChevronMargin: EdgeInsets.symmetric(vertical: 15),
        rightChevronMargin: EdgeInsets.symmetric(vertical: 15),
        leftChevronPadding: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (a, b) => !isWeekView ? null : const SizedBox(),
        defaultBuilder: (_, day, __) => weekView(day, isWeekView, selectedDay),
        outsideBuilder: (_, day, __) => weekView(day, isWeekView, selectedDay),
        disabledBuilder: (_, day, __) => weekView(day, isWeekView, selectedDay),
        selectedBuilder: (_, day, __) => weekView(day, isWeekView, selectedDay),
        todayBuilder: (_, day, __) => weekView(day, isWeekView, selectedDay),
      ),
    );
  }

  Widget? weekView(DateTime day, bool isWeekView, DateTime selectedDay) {
    if (!isWeekView) return null;
    final selected = "$selectedDay".toDate();
    final focused = "$day".toDate();
    final today = "${DateTime.now()}".toDate();

    return _UnExpandedDayWidget(
      day: day,
      isToday: today == focused,
      isSelected: focused == selected,
      isWeekView: isWeekView,
    );
  }
}

class _UnExpandedDayWidget extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool isWeekView;
  const _UnExpandedDayWidget({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isWeekView,
  });

  Color get borderColor {
    if (isWeekView && isSelected) return KColors.purple;
    return Colors.transparent;
  }

  Color? get backgroundColor => isToday ? KColors.purple : Colors.white;

  Color get textColor {
    if (isToday) return Colors.white;
    if (isWeekView && isSelected) return KColors.purple;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: AppText(
                "$day".toDate("EEE"),
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: AppText(
                day.day.toString(),
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
