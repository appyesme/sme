import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/drop_down.dart';
import '../../../../widgets/loading_indidactor.dart';
import '../../../../widgets/multiselect_dropdrown.dart';
import '../../../../widgets/svg_icon.dart';
import '../../../../widgets/text_field.dart';
import '../../../profile_page/models/user_model.dart';
import '../providers/provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({
    super.key,
    required this.user,
  });

  static const String route = "/edit-profile";

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(editProfileProvider.notifier).setUser(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(editProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Edit profile",
          fontSize: 20,
          color: KColors.white,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: KColors.purple,
        centerTitle: false,
        toolbarHeight: 60.px,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      ),
      body: Builder(builder: (context) {
        if (details == null) return const Center(child: LoadingIndicator());

        return Form(
          key: ref.read(editProfileProvider.notifier).formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: AppText(
                    "Full Name",
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                AppTextField(
                  initialValue: details.name,
                  onChanged: (name) {
                    final provider = ref.read(editProfileProvider.notifier);
                    provider.update((value) => value?.copyWith(name: name));
                  },
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 28,
                      color: KColors.purple,
                    ),
                  ),
                  hintText: "Enter full name",
                  // height: 45,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: AppText(
                    "Email",
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                AppTextField(
                  initialValue: details.email,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.email_outlined,
                      size: 28,
                      color: KColors.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                ///
                ///
                ///
                ///
                if (isLoggedIn && isENTREPRENEUR) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: AppText("Expertises"),
                  ),
                  const SizedBox(height: 5),
                  Consumer(
                    builder: (_, ref, __) {
                      final expertises = ref.watch(editProfileProvider.select((value) => value?.expertises));

                      return MultiSelectDropDown<String>(
                        selected: () {
                          return expertises?.map((tag) => DropDownItem(id: tag, title: tag, value: tag)).toList() ??
                              [];
                        },
                        validator: (value) => value == null || value.isEmpty == true ? "Required" : null,
                        onChanged: (values) {
                          final provider = ref.read(editProfileProvider.notifier);
                          final expertises = values.map((e) => e.id).toList();
                          provider.update((value) => value?.copyWith(expertises: expertises));
                        },
                        icon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgIcon(SvgIcons.email),
                        ),
                        hinttext: "Select your expertises",
                        items: ["Beautician", "Makeup Artist", "Nail Artist"].map((e) => DropDownItem<String>(id: e)).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 20.px),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: AppText("Total work experience"),
                  ),
                  const SizedBox(height: 5),
                  AppTextField(
                    initialValue: details.totalWorkExperience?.toString(),
                    onChanged: (value) {
                      final provider = ref.read(editProfileProvider.notifier);
                      provider.update((state) => state?.copyWith(totalWorkExperience: int.tryParse(value ?? '')));
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
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: AppText(
                      "About",
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AppTextField(
                    initialValue: details.about,
                    onChanged: (about) {
                      final provider = ref.read(editProfileProvider.notifier);
                      provider.update((value) => value?.copyWith(about: about));
                    },
                    hintText: "Type here...",
                    radius: 12,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 10,
                    maxLength: 250,
                  ),
                ],
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: AppButton(
        onTap: () => ref.read(editProfileProvider.notifier).onSaveTap(context),
        width: 120,
        text: "Save",
      ),
    );
  }
}
