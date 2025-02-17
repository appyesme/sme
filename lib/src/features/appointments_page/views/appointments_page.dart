import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indidactor.dart';
import '../../../widgets/not_logged_in.dart';
import '../providers/provider.dart';
import 'widgets/appointment_card.dart';
import 'widgets/calender.dart';

class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  static const String route = '/appointments';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const AppBarWidget(title: "Bookings"),
        body: Consumer(
          builder: (_, WidgetRef ref, __) {
            return RefreshIndicator(
              onRefresh: () => ref.read(appointmentsProvider.notifier).getBookedAppointments(),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              notificationPredicate: (notification) => notification.metrics.axis == Axis.vertical,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: CalendarWidget(isWeekView: true)),
                  Builder(
                    builder: (context) {
                      final appointments = ref.watch(appointmentsProvider.select((value) => value.appointments));

                      if (userId == null) {
                        return const SliverFillRemaining(child: NotLoggedInWidget());
                      } else if (appointments == null) {
                        return const SliverFillRemaining(child: LoadingIndicator());
                      } else if (appointments.isEmpty) {
                        return const SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                "You have no appointments",
                                textAlign: TextAlign.center,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList.separated(
                            itemCount: appointments.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              return Badge(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(2),
                                backgroundColor: KColors.grey2,
                                label: AppText(
                                  (index + 1).toString(),
                                  fontSize: 12,
                                ),
                                child: AppointmentCard(
                                  appointment: appointments[index],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
