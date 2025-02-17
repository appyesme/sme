import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider.autoDispose<NavigationNotifier, NavTab>((ref) {
  return NavigationNotifier();
});

// ignore: constant_identifier_names
enum NavTab { Home, Search, Services, Appointments }

class NavigationNotifier extends StateNotifier<NavTab> {
  NavigationNotifier() : super(NavTab.Home);
  void setBottomNavTab(NavTab value) => state = value;
}
