import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../services/api_services/appointments_api.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading_indidactor.dart';
import '../../authentication/views/signin_page.dart';
import '../../book_appointment_page/views/book_appointment_page.dart';
import '../../services_list_page/models/service_model.dart';
import '../../services_list_page/providers/provider.dart';
import '../providers/provider.dart';

class ServiceDetailsParam {
  final String? serviceID;
  final ServiceModel? service;
  final bool showActions;

  const ServiceDetailsParam({
    this.serviceID,
    this.service,
    this.showActions = true,
  });
}

class ServiceDetailsPage extends ConsumerStatefulWidget {
  final ServiceDetailsParam params;

  const ServiceDetailsPage({super.key, required this.params});

  static const String route = '/service-details';

  @override
  ConsumerState<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends ConsumerState<ServiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = ref.read(serviceDetailsProvider.notifier);
      widget.params.serviceID != null
          ? provider.getServiceByID(widget.params.serviceID!)
          : provider.setService(widget.params.service!);
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.params.service == null || widget.params.serviceID == null);

    final state = ref.watch(serviceDetailsProvider);
    final service = state.service;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Service Details",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (service == null) ...[
                    const SliverFillRemaining(
                      child: Center(
                        child: LoadingIndicator(),
                      ),
                    ),
                  ] else ...[
                    SliverList.list(
                      children: [
                        InteractiveViewer(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              repeat: ImageRepeat.noRepeat,
                              fit: BoxFit.cover,
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              imageUrl: state.selectedImage ?? '',
                              errorWidget: (context, url, error) => const SizedBox(),
                              placeholder: (context, url) => const LoadingIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...service.medias.map(
                                  (item) {
                                    final selected = item.url == state.selectedImage;
                                    return GestureDetector(
                                      onTap: () {
                                        if (selected) return;
                                        final provider = ref.read(serviceDetailsProvider.notifier);
                                        provider.setState(state.copyWith(selectedImage: item.url));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: SizedBox(
                                            height: 60.px,
                                            width: 60.px,
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: ColorFiltered(
                                                    colorFilter: ColorFilter.mode(
                                                      selected ? Colors.black38 : Colors.transparent,
                                                      BlendMode.colorBurn,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      repeat: ImageRepeat.noRepeat,
                                                      fit: BoxFit.cover,
                                                      fadeInDuration: Duration.zero,
                                                      fadeOutDuration: Duration.zero,
                                                      imageUrl: item.url ?? '',
                                                      errorWidget: (context, url, error) => const SizedBox(),
                                                      placeholder: (context, url) => const LoadingIndicator(),
                                                    ),
                                                  ),
                                                ),
                                                if (selected) ...[
                                                  const Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                service.title ?? '',
                                fontSize: 18,
                              ),
                              const SizedBox(height: 15),
                              FutureBuilder<double?>(
                                future: AppointmentsApi.getAppointmentPrice(service.id!, false),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const LoadingIndicator(
                                      scale: 20,
                                      strokeWidth: 2,
                                    );
                                  }

                                  return AppText(
                                    '₹${snapshot.data ?? '-'}/-',
                                    maxLines: 1,
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: KColors.secondary,
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              AppText(
                                service.description ?? '',
                                fontWeight: FontWeight.w400,
                              ),
                              const SizedBox(height: 15),
                              const Divider(color: KColors.grey1, thickness: 5),
                              const SizedBox(height: 15),
                              NewWidget(
                                title: "Expertise in",
                                value: service.expertises ?? '',
                              ),
                              const SizedBox(height: 10),
                              NewWidget(
                                title: "Home service",
                                value: service.homeAvailable ? "Yes" : "No",
                              ),
                              const SizedBox(height: 10),
                              NewWidget(
                                title: "Salon service",
                                value: service.salonAvailable ? "Yes" : "No",
                              ),
                              const SizedBox(height: 10),
                              NewWidget(
                                title: "Address",
                                value: service.address ?? '-',
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),

            ///
            ///
            ///
            ///
            ///
            if (service != null) ...[
              if (service.createdBy == userId && isENTREPRENEUR) ...[
                if (widget.params.showActions) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onTap: () => ref.read(servicesListProvider.notifier).deleteService(context, service.id!),
                            backgroundColor: KColors.white,
                            borderColor: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                AppText(
                                  "Delete",
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else if (!isENTREPRENEUR) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onTap: () {
                            if (isLoggedIn) {
                              context.pushNamed(BookAppointmentPage.route, extra: service.id!);
                            } else {
                              context.pushNamed(SignInPage.route);
                            }
                          },
                          child: const AppText(
                            "Book",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
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
