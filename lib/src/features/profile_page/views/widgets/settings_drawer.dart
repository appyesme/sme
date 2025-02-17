import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/auth_handler.dart';
import '../../../../core/shared/shared.dart';
import '../../../../utils/string_extension.dart';
import '../../../../widgets/app_text.dart';
import '../../../authentication/views/signin_page.dart';
import '../../../favourites_page/views/favourites_page.dart';

class SettingDrawer extends ConsumerWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          // leading: CupertinoButton(
          //   onPressed: () => Navigator.of(context).pop(),
          //   padding: const EdgeInsets.only(),
          //   child: const Icon(
          //     Icons.arrow_back,
          //     color: KColors.white,
          //   ),
          // ),
          title: const AppText(
            "Settings",
            fontSize: 20,
            color: KColors.white,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: KColors.purple,
          centerTitle: false,
          toolbarHeight: 60.px,
          shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
        ),
        body: Container(
          width: double.infinity,
          color: KColors.white,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoggedIn) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AppText(
                      "General",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isLoggedIn && !isENTREPRENEUR) ...[
                    SettingTile(
                      onTap: () {
                        context.pop(); // remove drawer.
                        context.pushReplacementNamed(FavouritesPage.route);
                      },
                      title: "Favourites",
                      leading: const Icon(CupertinoIcons.bookmark_fill, color: KColors.purple),
                    ),
                  ],
                  SettingTile(
                    onTap: () => logOut(context, () => context.goNamed(SignInPage.route)),
                    title: "Logout",
                    leading: const Icon(Icons.person, color: KColors.purple),
                    trailing: const Icon(Icons.logout, color: Colors.red),
                  ),
                  const Divider(height: 0, color: KColors.grey2, thickness: 5),
                ],

                ///
                ///
                /// MORE
                ///
                ///

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppText(
                    "More",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SettingTile(
                  onTap: () => "https://web-sme-app.web.app/privacy-policy".openLink(),
                  title: "Privacy Policy",
                  leading: const Icon(Icons.privacy_tip, color: KColors.purple),
                ),
                const Divider(height: 0, color: KColors.grey, thickness: 0.3),
                SettingTile(
                  onTap: () => "https://web-sme-app.web.app".openLink(),
                  title: "Terms & Conditions",
                  leading: const Icon(Icons.admin_panel_settings, color: KColors.purple),
                ),

                const Divider(height: 0, color: KColors.grey, thickness: 0.3),
                SettingTile(
                  onTap: () => "https://web-sme-app.web.app".openLink(),
                  title: "Support",
                  leading: const Icon(Icons.help, color: KColors.purple),
                ),
                const Divider(height: 0, color: KColors.grey, thickness: 0.3),
                SettingTile(
                  onTap: () {},
                  title: "App Version",
                  trailing: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      return AppText(
                        "v${snapshot.data?.version ?? '-'}",
                        color: KColors.black,
                        fontWeight: FontWeight.w400,
                      );
                    },
                  ),
                  leading: const Icon(Icons.build, color: KColors.purple),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback onTap;
  const SettingTile({
    super.key,
    required this.title,
    this.trailing,
    this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: onTap,
        tileColor: KColors.white,
        title: AppText(title),
        minLeadingWidth: 20,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
