import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kcolors.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/tab_indicator.dart';
import '../../../widgets/text_field.dart';
import '../providers/provider.dart';
import 'widgets/searched_services.dart';
import 'widgets/searched_users.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  static const String route = "/search";

  @override
  ConsumerState<SearchPage> createState() => _SearchPage2State();
}

class _SearchPage2State extends ConsumerState<SearchPage> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  List<String> get tabs => ["Services", /* "Posts", */ "Users"];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Search"),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AppTextField(
                          controller: ref.read(searchProvider.notifier).searchController,
                          onChanged: ref.read(searchProvider.notifier).onSearchChanged,
                          hintText: "Search",
                          radius: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                TabBar(
                  controller: tabController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  indicatorWeight: 0.001,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  splashBorderRadius: BorderRadius.circular(25),
                  indicator: const MaterialIndicator(),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: KColors.purple,
                  ),
                  tabs: tabs.map((tab) => Tab(height: 60, text: tab)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      SearchedServicesWidget(),
                      // SearchedPostsWidget(),
                      SearchedUsersWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
