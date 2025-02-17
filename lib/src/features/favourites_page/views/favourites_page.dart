import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../widgets/app_text.dart';
import 'widgets/favourite_users_widget.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  static const String route = '/favourites';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(
            "Favourites",
            fontSize: 20,
            color: KColors.white,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: KColors.purple,
          centerTitle: false,
          toolbarHeight: 60.px,
          shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
        ),
        body: const FavouriteUsersWidget(),
      ),
    );
  }
}
