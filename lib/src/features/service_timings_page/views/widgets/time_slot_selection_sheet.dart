import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/text_field.dart';
import '../../../../widgets/time_picker.dart';
import '../../models/service_day_model.dart';
import '../../providers/provider.dart';
import '../../providers/state.dart';

Future<void> showTimeSlotSelectionSheet(BuildContext context, ServiceDayModel day) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: true,
    useSafeArea: true,
    elevation: 0,
    barrierColor: Colors.black26,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SlotTile(day: day),
  );
}

class SlotTile extends StatelessWidget {
  final ServiceDayModel day;
  const SlotTile({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              color: KColors.purple,
              child: Row(
                children: [
                  const Expanded(
                    child: AppText(
                      "Slot Selection : ",
                      fontSize: 18,
                      color: KColors.white,
                    ),
                  ),
                  AppText(
                    day.day!.getDayName(),
                    fontSize: 18,
                    color: KColors.white,
                  ),
                ],
              ),
            ),
            const ColoredBox(
              color: KColors.black10,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        "Start\nTime",
                        fontSize: 12,
                        textAlign: TextAlign.center,
                        color: KColors.black,
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        "End\nTime",
                        fontSize: 12,
                        color: KColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        "People\nper slot",
                        fontSize: 12,
                        color: KColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Flexible(
              child: DraggableScrollableSheet(
                minChildSize: 0.4,
                initialChildSize: 0.75,
                maxChildSize: 1,
                expand: false,
                builder: (context, scrollController) {
                  return CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      Consumer(
                        builder: (_, ref, __) {
                          final timings = ref.watch(
                            editServiceTimingProvider.select(
                              (value) => value.selectedDay?.timings,
                            ),
                          );

                          if (timings == null) {
                            return const SliverFillRemaining(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadingIndicator(),
                                  ],
                                ),
                              ),
                            );
                          } else if (timings.isEmpty) {
                            return const SliverFillRemaining(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      "No slots added",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SliverPadding(
                              padding: EdgeInsets.only(top: timings.isEmpty ? 0 : 20),
                              sliver: SliverList.separated(
                                itemCount: timings.length,
                                separatorBuilder: (a, b) => const SizedBox(height: 10),
                                itemBuilder: (BuildContext context, int index) {
                                  final timing = timings[index];

                                  final start = timing.startTime == null ? null : "2024-10-10T${timing.startTime}";
                                  final end = timing.endTime == null ? null : "2024-10-10T${timing.endTime}";

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Card(
                                      elevation: 0,
                                      child: Padding(
                                        key: ValueKey(index),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppTimePicker(
                                                    selectedTime: start,
                                                    onChanged: (value) {
                                                      final provider = ref.read(editServiceTimingProvider.notifier);
                                                      provider.updateTimings(
                                                        (timings) {
                                                          final formatted = value.split("T")[1];
                                                          timings[index] = timing.copyWith(startTime: formatted);
                                                          return timings;
                                                        },
                                                      );
                                                    },
                                                    hintText: "Start",
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: AppTimePicker(
                                                    selectedTime: end,
                                                    onChanged: (value) {
                                                      final provider = ref.read(editServiceTimingProvider.notifier);
                                                      provider.updateTimings(
                                                        (timings) {
                                                          final formatted = value.split("T")[1];
                                                          timings[index] = timing.copyWith(endTime: formatted);
                                                          return timings;
                                                        },
                                                      );
                                                    },
                                                    hintText: "End",
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: AppTextField(
                                                    initialValue: timing.peoplePerSlot?.toString(),
                                                    onChanged: (value) {
                                                      final people = int.tryParse("$value");
                                                      final provider = ref.read(editServiceTimingProvider.notifier);
                                                      provider.updateTimings(
                                                        (timings) {
                                                          timings[index] = timing.copyWith(peoplePerSlot: people);
                                                          return timings;
                                                        },
                                                      );
                                                    },
                                                    hintText: "Total",
                                                    contentPadding: const EdgeInsets.all(12),
                                                    textAlign: TextAlign.center,
                                                    filledColor: KColors.white,
                                                    borderColor: KColors.grey,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    final provider = ref.read(editServiceTimingProvider.notifier);
                                                    provider.removeTiming(context, index, timing);
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: KColors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        AppText("Delete"),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          CupertinoIcons.delete,
                                                          color: KColors.secondary,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                const AppText(
                                                  "Enable",
                                                ),
                                                const SizedBox(width: 10),
                                                Switch.adaptive(
                                                  value: timing.enabled,
                                                  onChanged: (value) {
                                                    final provider = ref.read(editServiceTimingProvider.notifier);
                                                    provider.updateTimings(
                                                      (timings) {
                                                        timings[index] = timing.copyWith(enabled: value);
                                                        return timings;
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            ///
            ///
            ///
            ///
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5).copyWith(
                bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  const Divider(),
                  Consumer(
                    builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppButton(
                              height: 50,
                              onTap: () {
                                final provider = ref.read(editServiceTimingProvider.notifier);
                                provider.update((state) => state.addTiming());
                              },
                              text: "Add+",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppButton(
                              height: 50,
                              onTap: () {
                                DialogHelper.unfocus(context);
                                final provider = ref.read(editServiceTimingProvider.notifier);
                                provider.saveTimings(context);
                              },
                              backgroundColor: KColors.bgColor,
                              text: "Save",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
