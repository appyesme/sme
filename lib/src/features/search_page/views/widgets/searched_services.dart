import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../../widgets/app_text.dart';
import '../../../service_details_page/views/service_details_page.dart';
import '../../providers/provider.dart';

class SearchedServicesWidget extends ConsumerWidget {
  const SearchedServicesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(searchProvider.select((value) => value.searched?.services));

    if (services == null) {
      return const Center(
        child: AppText(
          "Hey, you came back.\nSearch something...",
          textAlign: TextAlign.center,
        ),
      );
    }
    if (services.isEmpty) {
      return const Center(
        child: AppText(
          "No services",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return GridView.builder(
        itemCount: services.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          final service = services[index];

          return GestureDetector(
            onTap: () {
              DialogHelper.unfocus(context);
              context.pushNamed(
                ServiceDetailsPage.route,
                extra: ServiceDetailsParam(
                  serviceID: service.id,
                  showActions: false,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    service.url ?? '',
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.7],
                    colors: [KColors.white10, KColors.black60],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(
                    service.title ?? '',
                    maxLines: 2,
                    fontSize: 12,
                    color: KColors.white,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
