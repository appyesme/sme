import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/no_content_message_widget.dart';
import '../../add_service_page/views/add_service_page.dart';
import '../providers/provider.dart';
import 'widgets/service_card.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const String route = '/services';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const AppBarWidget(title: "My Services"),
        floatingActionButton: Builder(builder: (context) {
          if (!isLoggedIn || !isENTREPRENEUR) return const SizedBox();

          return FloatingActionButton.extended(
            heroTag: "service_list",
            shape: const StadiumBorder(),
            onPressed: () => context.pushNamed(AddServicePage.route),
            backgroundColor: KColors.purple,
            icon: const Icon(Icons.add, color: KColors.white),
            label: const AppText("Add New Service", color: KColors.white),
          );
        }),
        body: Consumer(
          builder: (context, ref, child) {
            final services = ref.watch(servicesListProvider.select((value) => value.services));

            return Stack(
              children: [
                if (services == null) ...[
                  const Positioned.fill(
                    child: NoContentMessageWidget(
                      message: "No services added",
                      icon: Icons.settings,
                    ),
                  ),
                ],
                Positioned.fill(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(servicesListProvider.notifier).getServices();
                    },
                    child: ListView.separated(
                      itemCount: services?.length ?? 0,
                      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final service = services![index];
                        return ServiceCard(service: service);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
