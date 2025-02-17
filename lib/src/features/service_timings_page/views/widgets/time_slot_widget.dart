import 'package:flutter/material.dart';

import '../../../../widgets/app_text.dart';

class DaySlotTile extends StatelessWidget {
  final String? day;
  final bool value;
  final Color? bgColor;
  final VoidCallback onTap;
  final ValueChanged<bool>? onToggle;

  const DaySlotTile({
    super.key,
    this.day,
    required this.value,
    this.bgColor,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  day!,
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
