import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'src/core/constants/kcolors.dart';
import 'src/core/router/route_config.dart';
import 'src/core/shared/shared.dart';
import 'src/services/shared_pref_service/shared_pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  if (!kIsWeb) FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(goRouterProvider);

    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        title: appName,
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        builder: (context, child) => UpgradeAlert(
          showIgnore: false,
          child: OKToast(child: child!),
        ),
        theme: ThemeData(
          // useMaterial3: false,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          scaffoldBackgroundColor: KColors.white,
          primarySwatch: Colors.blue,
          primaryColor: KColors.purple,
          dividerTheme: const DividerThemeData(
            color: KColors.divider,
            thickness: 1,
          ),
        ),
      );
    });
  }
}
