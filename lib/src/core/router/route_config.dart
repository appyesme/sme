import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../splash_screen.dart';
import '../../features/add_post_page/models/post_model.dart';
import '../../features/add_post_page/views/add_post_page.dart';
import '../../features/add_service_page/views/add_service_page.dart';
import '../../features/appointments_page/views/appointments_page.dart';
import '../../features/authentication/views/signin_page.dart';
import '../../features/authentication/views/signup_page.dart';
import '../../features/book_appointment_page/views/book_appointment_page.dart';
import '../../features/edit_profile_page/presentation/view/edit_profile_page.dart';
import '../../features/favourites_page/views/favourites_page.dart';
import '../../features/home_page/views/home_page.dart';
import '../../features/landing_page/views/landing_page.dart';
import '../../features/notifications_page/views/notifications_page.dart';
import '../../features/payment_page/models/payment_model.dart';
import '../../features/payment_page/views/payment_page.dart';
import '../../features/profile_page/models/user_model.dart';
import '../../features/profile_page/views/profile_page.dart';
import '../../features/service_details_page/views/service_details_page.dart';
import '../../features/service_timings_page/views/service_timings_page.dart';
import '../../features/services_list_page/models/service_model.dart';
import '../../features/services_list_page/views/services_list_page.dart';
import 'route_not_found_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: SplashScreen.route,
      navigatorKey: navigatorKey,
      observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
      errorBuilder: (context, state) => const RouteNotFoundPage(),
      routes: [
        GoRoute(
          name: SplashScreen.route,
          path: SplashScreen.route,
          pageBuilder: (context, state) {
            return CupertinoPage(key: state.pageKey, child: const SplashScreen());
          },
        ),
        GoRoute(
          name: SignInPage.route,
          path: SignInPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const SignInPage(),
            );
          },
        ),
        GoRoute(
          name: SignUpPage.route,
          path: SignUpPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const SignUpPage(),
            );
          },
        ),
        GoRoute(
          name: LandingPage.route,
          path: LandingPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const LandingPage(),
            );
          },
        ),
        GoRoute(
          name: MyAppointmentsPage.route,
          path: MyAppointmentsPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const MyAppointmentsPage(),
            );
          },
        ),
        GoRoute(
          name: BookAppointmentPage.route,
          path: BookAppointmentPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: BookAppointmentPage(
                serviceId: state.extra as String,
              ),
            );
          },
        ),
        GoRoute(
          name: HomePage.route,
          path: HomePage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          name: NotificationsPage.route,
          path: NotificationsPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const NotificationsPage(),
            );
          },
        ),
        GoRoute(
          name: ProfilePage.route,
          path: ProfilePage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: ProfilePage(
                profileId: state.extra as String?,
              ),
            );
          },
        ),
        GoRoute(
          name: EditProfilePage.route,
          path: EditProfilePage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: EditProfilePage(
                user: state.extra as UserModel,
              ),
            );
          },
        ),
        GoRoute(
          name: FavouritesPage.route,
          path: FavouritesPage.route,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const FavouritesPage(),
            );
          },
        ),
        GoRoute(
          name: AddPostPage.route,
          path: AddPostPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: AddPostPage(
                post: state.extra as PostModel?,
              ),
            );
          },
        ),
        GoRoute(
          name: AddServicePage.route,
          path: AddServicePage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: AddServicePage(
                service: state.extra as ServiceModel?,
              ),
            );
          },
        ),
        GoRoute(
          name: ServiceTimingsPage.route,
          path: ServiceTimingsPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: ServiceTimingsPage(
                service: state.extra as ServiceModel,
              ),
            );
          },
        ),
        GoRoute(
          name: PaymentPage.route,
          path: PaymentPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: PaymentPage(
                payment: state.extra as PaymentModel,
              ),
            );
          },
        ),
        GoRoute(
          name: ServicesPage.route,
          path: ServicesPage.route,
          pageBuilder: (context, state) {
            return CupertinoPage(
              key: state.pageKey,
              child: const ServicesPage(),
            );
          },
        ),
        GoRoute(
          name: ServiceDetailsPage.route,
          path: ServiceDetailsPage.route,
          pageBuilder: (context, state) {
            final params = state.extra as ServiceDetailsParam;

            return CupertinoPage(
              key: state.pageKey,
              child: ServiceDetailsPage(params: params),
            );
          },
        ),
      ],
    );
  },
);
