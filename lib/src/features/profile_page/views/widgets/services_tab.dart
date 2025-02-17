import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/no_content_message_widget.dart';
import '../../../service_details_page/views/service_details_page.dart';
import '../../providers/provider.dart';

class ServicesTab extends ConsumerWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(profileProvider.select((value) => value.services));

    if (services == null) {
      return const Center(
        child: LoadingIndicator(),
      );
    } else if (services.isEmpty) {
      return const NoContentMessageWidget(
        message: "No services are available",
        icon: Icons.photo,
      );
    } else {
      return SafeArea(
        child: GridView.builder(
          itemCount: services.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            final service = services[index];

            return GestureDetector(
              onTap: () {
                context.pushNamed(
                  ServiceDetailsPage.route,
                  extra: ServiceDetailsParam(
                    serviceID: service.id,
                    showActions: false,
                  ),
                );
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: service.medias.firstOrNull?.url ?? '',
                      fit: BoxFit.cover,
                      maxHeightDiskCache: 200,
                      maxWidthDiskCache: 200,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 1.0],
                          colors: [KColors.black50, Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        service.title ?? '',
                        color: KColors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
