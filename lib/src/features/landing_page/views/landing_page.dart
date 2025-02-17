import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/shared/auth_handler.dart';
import '../../../core/shared/shared.dart';
import '../../../services/api_services/users_apis.dart';
import '../../../widgets/app_text.dart';
import '../../appointments_page/views/appointments_page.dart';
import '../../home_page/providers/provider.dart';
import '../../home_page/views/home_page.dart';
import '../../search_page/views/search_page.dart';
import '../../services_list_page/views/services_list_page.dart';
import '../providers/provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});
  static const String route = "/";

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _getNotifications();
  }

  void _getNotifications() {
    if (isLoggedIn) {
      UsersApi.getNotificationUnreadCount().then((value) {
        ref.read(unreadNotificationProvider.notifier).state = value;
      });
    }
  }

  List<IconData> get _icons => [
        Icons.home,
        if (!isENTREPRENEUR) Icons.search,
        if (isLoggedIn && isENTREPRENEUR) Icons.book,
        Icons.account_box,
      ];

  List<NavTab> get _tabs => [
        NavTab.Home,
        if (!isENTREPRENEUR) NavTab.Search,
        if (isLoggedIn && isENTREPRENEUR) NavTab.Services,
        NavTab.Appointments,
      ];

  List<Widget> get _widgets => [
        const HomePage(),
        if (!isENTREPRENEUR) const SearchPage(),
        if (isLoggedIn && isENTREPRENEUR) const ServicesPage(),
        const MyAppointmentsPage(),
      ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentNavTab = ref.watch(navigationProvider);

    return PopScope(
      canPop: currentNavTab == NavTab.Home,
      onPopInvokedWithResult: (didPop, result) {
        if (currentNavTab == NavTab.Home) return;
        ref.read(navigationProvider.notifier).setBottomNavTab(NavTab.Home);
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _tabs.indexOf(currentNavTab),
          children: _widgets,
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(color: KColors.purple),
          child: SafeArea(
            child: Container(
              height: 60.px,
              color: Colors.transparent,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    _tabs.length,
                    (index) {
                      return Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            ref.read(navigationProvider.notifier).setBottomNavTab(_tabs[index]);
                            // if (tabname == NavTab.home && currentNavTab == NavTab.home) {
                            //   ref.read(homeProvider.notifier).scrollToTop();
                            // }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Here consumer added bcoz all tab providers should listen till user logs out.
                              /// And avoid whole widget rebuild in this screen.
                              Consumer(builder: (context, ref, child) {
                                ref.watch(homeProvider);
                                return const SizedBox.shrink();
                              }),
                              Icon(
                                _icons[index],
                                size: 24,
                                color: _tabs[index] == currentNavTab ? KColors.white : KColors.white54,
                              ),
                              FittedBox(
                                child: AppText(
                                  _tabs[index].name,
                                  fontSize: 10,
                                  color: _tabs[index] == currentNavTab ? KColors.white : KColors.white54,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
