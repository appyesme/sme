import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/expansion_tile.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/time_picker.dart';
import '../../service_timings_page/views/widgets/time_slot_widget.dart';
import '../providers/provider.dart';
import 'widgets/calender_widget.dart';
import 'widgets/service_selection_dialog.dart';

class BookAppointmentPage extends ConsumerStatefulWidget {
  final String serviceId;
  const BookAppointmentPage({super.key, required this.serviceId});

  static const String route = '/book-appointment';

  @override
  ConsumerState<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends ConsumerState<BookAppointmentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = ref.read(appointmentProvider.notifier);
      provider.getServiceById(widget.serviceId);
      provider.getAppointmentAvailableDays(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Book Appointment",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                ///
                ///
                /// LinearProgressIndicator
                ///
                ///
                SliverToBoxAdapter(child: Consumer(
                  builder: (context, ref, child) {
                    final length = ref.watch(appointmentProvider.select((value) => value.days?.length));
                    return length == null ? const LinearProgressIndicator() : const SizedBox();
                  },
                )),

                ///
                ///
                /// Calender
                ///
                ///
                const SliverToBoxAdapter(child: CalenderWidget()),

                ///
                ///
                /// Do need home service
                ///
                ///
                Consumer(
                  builder: (context, ref, child) {
                    final homeAvailable = ref.watch(
                      appointmentProvider.select(
                        (value) => value.service?.homeAvailable,
                      ),
                    );

                    if (homeAvailable == true) {
                      final homeServiceNeeded = ref.watch(
                        appointmentProvider.select(
                          (value) => value.homeServiceNeeded,
                        ),
                      );

                      final timeToAriveHome = ref.watch(
                        appointmentProvider.select(
                          (value) => value.selectedTimeToAriveHome,
                        ),
                      );

                      return SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DaySlotTile(
                                day: "Home service needed",
                                value: homeServiceNeeded,
                                bgColor: KColors.grey1,
                                onToggle: (value) {
                                  final provider = ref.read(appointmentProvider.notifier);
                                  provider.update(
                                    (state) => state.copyWith(
                                      homeServiceNeeded: value,
                                      selectedTimeToAriveHome: null,
                                    ),
                                  );
                                },
                                onTap: () {
                                  /// nothing to do here. Check [onToggle]
                                },
                              ),
                              const SizedBox(height: 5),
                              AppExpansionTile(
                                expand: homeServiceNeeded,
                                content: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: KColors.grey1,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: AppText(
                                              'Select a time to arrive home',
                                              color: KColors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 120,
                                            child: AppTimePicker(
                                              selectedTime:
                                                  timeToAriveHome == null ? null : "2024-10-10T$timeToAriveHome",
                                              hintText: "Select",
                                              onChanged: (value) {
                                                final time = value.split("T")[1];
                                                final provider = ref.read(appointmentProvider.notifier);
                                                provider
                                                    .update((state) => state.copyWith(selectedTimeToAriveHome: time));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Address
                                      const SizedBox(height: 10),
                                      AppTextField(
                                        filledColor: KColors.white,
                                        minLines: 5,
                                        maxLines: 5,
                                        hintText: "Enter home address to find you",
                                        validator: (value) => value == null ? "Required" : null,
                                        onChanged: (value) {
                                          final provider = ref.read(appointmentProvider.notifier);
                                          provider.update((state) => state.copyWith(homeAddress: value));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Note:',
                                      color: KColors.secondary,
                                      fontSize: 12,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: AppText(
                                        "An additional charge applies for home services.",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }
                  },
                ),

                ///
                ///
                /// Timings
                ///
                ///
                Consumer(
                  builder: (context, ref, child) {
                    final timings = ref.watch(appointmentProvider.select((value) => value.timings));

                    if (timings == null) {
                      return SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40.0),
                          margin: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: KColors.grey1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const AppText(
                            "Selecte a day\nto see available timings",
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    } else if (timings.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40.0),
                          margin: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: KColors.bluelite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const AppText(
                            "No slots are available. There might be all slots are booked",
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }

                    final selectedTiming = ref.watch(appointmentProvider.select((value) => value.selectedTiming));

                    return SliverPadding(
                      padding: const EdgeInsets.all(16.0).copyWith(bottom: 60),
                      sliver: SliverList.separated(
                        itemCount: timings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final timing = timings[index];

                          final start = "2024-10-10T${timing.startTime}Z".toDate("hh:mm a");
                          final end = "2024-10-10T${timing.endTime}Z".toDate("hh:mm a");

                          final isSelected = selectedTiming?.id == timing.id;

                          return GestureDetector(
                            onTap: () => ref
                                .read(appointmentProvider.notifier)
                                .update((state) => state.copyWith(selectedTiming: timing)),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? KColors.purple : KColors.black50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppText(
                                      "$start - $end",
                                      color: KColors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      const AppText(
                                        "Remaining slots",
                                        color: KColors.white,
                                        fontSize: 12,
                                      ),
                                      AppText(
                                        "${timing.remainingSlots ?? 0}",
                                        color: KColors.white,
                                        fontSize: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          ///
          ///
          ///
          ///
          ///
          Consumer(
            builder: (_, WidgetRef ref, __) {
              final selectedTiming = ref.watch(appointmentProvider.select((value) => value.selectedTiming));

              if (selectedTiming == null) return const SizedBox();

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: KColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: KColors.black10,
                      spreadRadius: 10,
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: AppButton(
                  onTap: () async {
                    final state = ref.read(appointmentProvider);
                    if (state.homeServiceNeeded && state.selectedTimeToAriveHome == null) {
                      return Toast.failure("Please select time to arrive home");
                    }

                    ref.read(appointmentProvider.notifier).getPrice();
                    final proceed = await showFinalPriceDialog(context);
                    if (proceed == true) ref.read(appointmentProvider.notifier).bookAppointment(context);
                  },
                  text: "Book Now",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String title;
  final String value;
  const NewWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppText(
            title,
            color: KColors.black,
          ),
        ),
        const AppText(" : ", color: KColors.black),
        Expanded(
          flex: 3,
          child: AppText(
            value,
            fontWeight: FontWeight.w400,
            color: KColors.black,
          ),
        ),
      ],
    );
  }
}
