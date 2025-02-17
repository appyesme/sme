import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../widgets/app_text.dart';
import '../../services_list_page/models/service_model.dart';
import '../providers/provider.dart';
import '../providers/state.dart';
import 'widgets/time_slot_widget.dart';

class ServiceTimingsPage extends ConsumerStatefulWidget {
  final ServiceModel? service;
  const ServiceTimingsPage({super.key, this.service});

  static const String route = '/service-timings';

  @override
  ConsumerState<ServiceTimingsPage> createState() => _ServiceTimingsPageState();
}

class _ServiceTimingsPageState extends ConsumerState<ServiceTimingsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = ref.read(editServiceTimingProvider.notifier);
        provider.update((state) => state.copyWith(service: widget.service!));
        provider.getServiceDays();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Service Timings",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (_, ref, __) {
            final days = ref.watch(editServiceTimingProvider.select((value) => value.days)) ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(7, (index) {
                  final dayName = (index + 1).getDayName();
                  final day = days.isEmpty ? null : days.singleWhere((item) => item.day == (index + 1));

                  return Column(
                    children: [
                      DaySlotTile(
                        day: dayName,
                        value: day == null ? false : day.enabled,
                        onToggle: (value) {
                          if (day == null) return;
                          final provider = ref.read(editServiceTimingProvider.notifier);
                          provider.changeServiceDayEnableStatus(index, value, day.id!);
                        },
                        onTap: () => ref.read(editServiceTimingProvider.notifier).openSlotModalSheet(context, day),
                      ),
                      const Divider(height: 0),
                    ],
                  );
                })
              ],
            );
          },
        ),
      ),
    );
  }
}
