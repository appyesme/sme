import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/shared.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_text.dart';
import '../../add_post_page/views/add_post_page.dart';
import '../../landing_page/providers/provider.dart';
import '../../search_page/providers/provider.dart';
import '../providers/provider.dart';
import 'widgets/posts_builder.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const String route = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const AppBarWidget(title: appName),
        floatingActionButton: Builder(builder: (context) {
          if (!isLoggedIn || !isENTREPRENEUR) return const SizedBox();

          return FloatingActionButton.extended(
            heroTag: "home",
            shape: const StadiumBorder(),
            onPressed: () => context.pushNamed(AddPostPage.route),
            backgroundColor: KColors.purple,
            icon: const Icon(Icons.add, color: KColors.white),
            label: const AppText("Add Post", color: KColors.white),
          );
        }),
        body: RefreshIndicator(
          notificationPredicate: (notification) => notification.metrics.axisDirection == AxisDirection.down,
          onRefresh: () => ref.read(homeProvider.notifier).getPosts(refresh: true),
          child: CustomScrollView(
            controller: ref.read(homeProvider.notifier).scrollController,
            key: const PageStorageKey("home-page"),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isLoggedIn && !isENTREPRENEUR) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        ...["Beautician", "Makeup Artist", "Nail Artist"].map(
                          (item) {
                            return GestureDetector(
                              onTap: () {
                                ref.read(navigationProvider.notifier).setBottomNavTab(NavTab.Search);
                                ref.read(searchProvider.notifier).searchController.text = item;
                                ref.read(searchProvider.notifier).onSearchChanged(item);
                              },
                              child: Chip(
                                label: AppText(item),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              ///
              /// Posts
              ///
              ///

              const PostsBuilder()
            ],
          ),
        ),
      ),
    );
  }
}
