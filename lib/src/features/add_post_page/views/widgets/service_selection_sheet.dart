import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../services_list_page/models/service_model.dart';
import '../../providers/provider.dart';

Future<ServiceModel?> showSelectServiceSheet(BuildContext context) {
  return showModalBottomSheet<ServiceModel?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: true,
    useSafeArea: true,
    elevation: 0,
    barrierColor: Colors.black26,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            color: KColors.purple,
            child: const Row(
              children: [
                Expanded(
                  child: AppText(
                    "Select Services",
                    fontSize: 18,
                    color: KColors.white,
                  ),
                ),
              ],
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
                        final services = ref.watch(addPostProivder.select((value) => value.services));

                        if (services == null) {
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
                        } else if (services.isEmpty) {
                          return const SliverFillRemaining(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    "No services are available",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SliverPadding(
                            padding: const EdgeInsets.all(10),
                            sliver: SliverGrid.builder(
                              itemCount: services.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final service = services[index];

                                final media = service.medias.firstOrNull;

                                return GestureDetector(
                                  onTap: () {
                                    if (userId != service.createdBy) return;
                                    GoRouter.of(context).pop(service);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(media?.url ?? ''),
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.bottomLeft,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [KColors.black10, KColors.black60],
                                          ),
                                        ),
                                        child: AppText(
                                          service.title ?? '',
                                          fontSize: 16,
                                          color: KColors.white,
                                          maxLines: 3,
                                        ),
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
        ],
      ),
    ),
  );
}
