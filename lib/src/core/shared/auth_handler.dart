import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing_page/views/landing_page.dart';
import '../../services/shared_pref_service/shared_pref_service.dart';
import '../../utils/string_extension.dart';
import '../enums/enums.dart';
import 'shared.dart';

final unreadNotificationProvider = StateProvider.autoDispose<int>((ref) => 0);

Future<void> checkAuthenticated(BuildContext context, [String? value]) async {
  final token = value ?? PrefService.getToken();
  PrefService.setToken(token);
  authToken = token;
  final decodedJWT = token?.decodeJWTAndGetUserId();
  userId = decodedJWT?.id;
  userType = decodedJWT?.type.getType;

  if (!UserType.values.contains(userType)) return logOut(context, () => context.goNamed(LandingPage.route));
  context.goNamed(LandingPage.route);
}

void logOut(BuildContext context, VoidCallback function) {
  authToken = null;
  userId = null;
  userType = null;
  sharedPref.clear();
  function();
}
