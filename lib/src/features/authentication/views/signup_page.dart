import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/kcolors.dart';
import '../../../utils/dailog_helper.dart';
import '../../../utils/view_document_dialog.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/drop_down.dart';
import '../../../widgets/expansion_tile.dart';
import '../../../widgets/multiselect_dropdrown.dart';
import '../../../widgets/svg_icon.dart';
import '../../../widgets/text_field.dart';
import '../providers/provider.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  static const String route = '/signup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Sign Up",
          fontSize: 20,
          color: KColors.white,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Form(
            key: ref.read(authProvider.notifier).signUpFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.px),
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final joinAsEntrepreneur = ref.watch(authProvider.select((value) => value.joinAsEntrepreneur));

                    return Center(
                      child: AppText(
                        joinAsEntrepreneur ? "Joining as\nEntrepreneur" : "Joining as\nService Seeker",
                        fontWeight: FontWeight.w500,
                        color: KColors.bgColor,
                        textAlign: TextAlign.center,
                        fontSize: 22,
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(fullname: value));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  hintText: 'Enter Full Name',
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgIcon(SvgIcons.email),
                  ),
                ),
                SizedBox(height: 20.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(email: value));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  hintText: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgIcon(SvgIcons.email),
                  ),
                ),
                SizedBox(height: 20.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(phoneNumber: value));
                  },
                  validator: (value) => value == null || value.length != 10 ? "Required" : null,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: AppText("+91"),
                    ),
                  ),
                ),
                const JoinAsEntrepreneurWidget(),
                SizedBox(height: 20.px),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: KColors.purple,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: AppText(
                          "By clicking on the sign up, you will be agreeing to the our terms and conditions.",
                          fontWeight: FontWeight.w400,
                          color: KColors.black40,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.px),
                AppButton(
                  onTap: () => ref.read(authProvider.notifier).signUp(context),
                  text: "Sign Up",
                ),
                SizedBox(height: 40.px),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Flexible(
                //       child: AppText(
                //         "Join as Entrepreneur",
                //         fontWeight: FontWeight.w400,
                //         color: KColors.black60,
                //       ),
                //     ),
                //     SizedBox(width: 20.px),
                //     Consumer(
                //       builder: (_, WidgetRef ref, __) {
                //         final joinAsEntrepreneur = ref.watch(authProvider.select((value) => value.joinAsEntrepreneur));
                //         return Switch.adaptive(
                //           value: joinAsEntrepreneur,
                //           activeColor: KColors.purple,
                //           onChanged: (value) {
                //             final provider = ref.read(authProvider.notifier);

                //             provider.update(
                //               (state) => state.copyWith(
                //                 joinAsEntrepreneur: value,
                //                 documents: [],
                //                 expertises: [],
                //               ),
                //             );
                //           },
                //         );
                //       },
                //     ),
                //   ],
                // ),
                // SizedBox(height: 40.px),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      "Already have an account ? ",
                      fontWeight: FontWeight.w400,
                      color: KColors.black60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const AppText(
                        "Sign In",
                        fontWeight: FontWeight.w500,
                        color: KColors.purple,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40.px),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JoinAsEntrepreneurWidget extends ConsumerWidget {
  const JoinAsEntrepreneurWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinAsEntrepreneur = ref.watch(authProvider.select((value) => value.joinAsEntrepreneur));

    return AppExpansionTile(
      expand: joinAsEntrepreneur,
      content: !joinAsEntrepreneur
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.px),
                Consumer(
                  builder: (_, ref, __) {
                    final expertises = ref.watch(authProvider.select((state) => state.expertises));
                    return MultiSelectDropDown<String>(
                      selected: () => expertises.map((tag) => DropDownItem(id: tag, title: tag, value: tag)).toList(),
                      validator: (value) => value == null || value.isEmpty == true ? "Required" : null,
                      onChanged: (values) {
                        final provider = ref.read(authProvider.notifier);
                        final expertises = values.map((e) => e.id).toList();
                        provider.update((state) => state.copyWith(expertises: expertises));
                      },
                      icon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgIcon(SvgIcons.email),
                      ),
                      hinttext: "Select your expertises",
                      items: ["Beautician", "Makeup Artist", "Nail Artist"]
                          .map((e) => DropDownItem<String>(id: e))
                          .toList(),
                    );
                  },
                ),
                SizedBox(height: 20.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(totalExperience: int.tryParse(value ?? '')));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  hintText: 'Enter total work experience',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgIcon(SvgIcons.email),
                  ),
                ),
                SizedBox(height: 20.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(aadharCardNumber: value));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  hintText: 'Enter aadhar number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgIcon(SvgIcons.email),
                  ),
                ),
                SizedBox(height: 20.px),
                AppTextField(
                  onChanged: (value) {
                    final provider = ref.read(authProvider.notifier);
                    provider.update((state) => state.copyWith(panCardNumber: value));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  hintText: 'Enter PAN number',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgIcon(SvgIcons.email),
                  ),
                ),
                SizedBox(height: 20.px),
                Consumer(
                  builder: (context, ref, child) {
                    final documents = ref.watch(authProvider.select((value) => value.documents));

                    return CupertinoButton(
                      onPressed: ref.read(authProvider.notifier).pickDocuments,
                      padding: const EdgeInsets.only(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: KColors.purple.withValues(alpha: 0.1),
                          border: Border.all(color: KColors.black10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            if (documents.isEmpty) ...[
                              const Icon(
                                CupertinoIcons.doc_append,
                                color: KColors.bgColor,
                                size: 34,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: AppText(
                                    "Upload your certificate that shows you are profesional or trained.",
                                    fontWeight: FontWeight.w400,
                                    color: KColors.black40,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Icon(CupertinoIcons.chevron_right, size: 20, color: Colors.black)
                            ] else ...[
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      ...documents.map(
                                        (document) {
                                          return GestureDetector(
                                            onTap: () {
                                              DialogHelper.unfocus(context);
                                              previewDocument(context, document);
                                            },
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              margin: const EdgeInsets.symmetric(horizontal: 2),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(
                                                    File(document.path),
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
                              )
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
