import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../add_service_page/views/add_service_page.dart';
import '../../../service_details_page/views/service_details_page.dart';
import '../../../service_timings_page/views/service_timings_page.dart';
import '../../models/service_model.dart';

class ServiceCard extends ConsumerWidget {
  final ServiceModel service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          ServiceDetailsPage.route,
          extra: ServiceDetailsParam(
            service: service,
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 0,
          color: KColors.filled,
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: KColors.white,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      service.medias.firstOrNull?.url ?? '',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        service.title ?? '',
                        maxLines: 2,
                        fontSize: 16,
                        color: KColors.black,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onTap: () {
                                context.push(
                                  AddServicePage.route,
                                  extra: service,
                                );
                              },
                              radius: 8,
                              height: 35,
                              width: 50,
                              fontSize: 12,
                              text: "Details",
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AppButton(
                              onTap: () {
                                context.pushNamed(
                                  ServiceTimingsPage.route,
                                  extra: service,
                                );
                              },
                              radius: 8,
                              width: 50,
                              height: 35,
                              fontSize: 12,
                              backgroundColor: KColors.bgColor,
                              text: "Timings",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
