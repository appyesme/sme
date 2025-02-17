import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/text_field.dart';
import '../../service_timings_page/views/widgets/time_slot_widget.dart';
import '../../services_list_page/models/service_model.dart';
import '../providers/provider.dart';
import '../providers/state.dart';
import 'widgets/image_builder.dart';

class AddServicePage extends ConsumerStatefulWidget {
  final ServiceModel? service;
  const AddServicePage({
    super.key,
    this.service,
  });

  static const String route = '/add-service';

  @override
  ConsumerState<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends ConsumerState<AddServicePage> {
  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = ref.read(createServiceProvider.notifier);
        provider.update((state) => state.copyWith(service: widget.service!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Create Service",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: ref.read(createServiceProvider.notifier).formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      ///
                      ///
                      const ServiceImageBuilder(),

                      ///
                      ///
                      ///
                      ///
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: AppText("Service Title"),
                      ),
                      AppTextField(
                        initialValue: widget.service?.title,
                        onChanged: (value) {
                          final provider = ref.read(createServiceProvider.notifier);
                          provider.updateService((state) => state.copyWith(title: value));
                        },
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        hintText: "Enter title",
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: AppText("Service Expertise"),
                      ),
                      AppTextField(
                        initialValue: widget.service?.expertises,
                        onChanged: (value) {
                          final provider = ref.read(createServiceProvider.notifier);
                          provider.updateService((state) => state.copyWith(expertises: value));
                        },
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        hintText: "Enter expertise (e.g Nail artist)",
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: AppText("Service type"),
                      ),
                      Consumer(
                        builder: (_, ref, __) {
                          final home = ref.watch(createServiceProvider.select((value) => value.service.homeAvailable));
                          final salon =
                              ref.watch(createServiceProvider.select((value) => value.service.salonAvailable));

                          return Row(
                            children: [
                              Expanded(
                                child: DaySlotTile(
                                  day: "Home",
                                  value: home,
                                  bgColor: KColors.grey1,
                                  onToggle: (value) {
                                    final provider = ref.read(createServiceProvider.notifier);
                                    provider.updateService((state) => state.copyWith(homeAvailable: value));
                                  },
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: DaySlotTile(
                                  day: "Salon",
                                  value: salon,
                                  bgColor: KColors.grey1,
                                  onToggle: (value) {
                                    final provider = ref.read(createServiceProvider.notifier);
                                    provider.updateService((state) => state.copyWith(salonAvailable: value));
                                  },
                                  onTap: () {},
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: KColors.purple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final home =
                                ref.watch(createServiceProvider.select((value) => value.service.homeAvailable));

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 5, bottom: 10),
                                            child: AppText("Service Charge"),
                                          ),
                                          AppTextField(
                                            initialValue: widget.service?.charge?.toString(),
                                            onChanged: (value) {
                                              final provider = ref.read(createServiceProvider.notifier);
                                              provider.updateService(
                                                (state) => state.copyWith(
                                                  charge: double.tryParse("$value"),
                                                ),
                                              );
                                            },
                                            validator: (value) => value == null || value.isEmpty ? "Required" : null,
                                            hintText: "Enter charge",
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (home) ...[
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 5, bottom: 10),
                                              child: AppText("Additional charge"),
                                            ),
                                            AppTextField(
                                              initialValue: widget.service?.additionalCharge?.toString(),
                                              onChanged: (value) {
                                                final provider = ref.read(createServiceProvider.notifier);
                                                provider.updateService(
                                                  (state) => state.copyWith(
                                                    additionalCharge: double.tryParse("$value"),
                                                  ),
                                                );
                                              },
                                              validator: (value) => value == null || value.isEmpty ? "Required" : null,
                                              hintText: "Enter charge",
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (home) ...[
                                  const SizedBox(height: 20),
                                  const AppText('For Home Service:'),
                                  const SizedBox(height: 5),
                                  const AppText(
                                    "An additional charge applies for home services.",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: AppText("Service Description"),
                      ),
                      AppTextField(
                        initialValue: widget.service?.description,
                        onChanged: (value) {
                          final provider = ref.read(createServiceProvider.notifier);
                          provider.updateService((state) => state.copyWith(description: value));
                        },
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        hintText: "Type description",
                        maxLength: 500,
                        minLines: 10,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10),
                        child: AppText("Address"),
                      ),
                      AppTextField(
                        initialValue: widget.service?.address,
                        onChanged: (value) {
                          final provider = ref.read(createServiceProvider.notifier);
                          provider.updateService((state) => state.copyWith(address: value));
                        },
                        radius: 5,
                        minLines: 4,
                        hintText: "Enter address",
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 25),
              child: AppButton(
                onTap: () {
                  final provider = ref.read(createServiceProvider.notifier);
                  provider.createUpdateService(context, ServiceStatus.PUBLISHED);
                },
                text: widget.service != null ? "Update" : "Create",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange = 0}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(text: truncated, selection: newSelection, composing: TextRange.empty);
  }
}
