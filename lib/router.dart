import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/pages/ad_page.dart';
import 'package:i_doctor/UI/pages/auth/login_page.dart';
import 'package:i_doctor/UI/pages/auth/signup_page.dart';
import 'package:i_doctor/UI/pages/chat.dart';
import 'package:i_doctor/UI/pages/confirm_basket_page.dart';
import 'package:i_doctor/UI/pages/confirm_purchase_details.dart';
import 'package:i_doctor/UI/pages/favorites_page.dart';
import 'package:i_doctor/UI/pages/main_pages/appointments_page.dart';
import 'package:i_doctor/UI/pages/main_pages/basket_page.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/pages/main_pages/bottom_nav_page.dart';
import 'package:i_doctor/UI/pages/category_list_page.dart';
import 'package:i_doctor/UI/pages/clinic_list_view.dart';
import 'package:i_doctor/UI/pages/clinic_page.dart';
import 'package:i_doctor/UI/pages/main_pages/settings_page.dart';
import 'package:i_doctor/UI/pages/notifications_page.dart';
import 'package:i_doctor/UI/pages/review_view.dart';
import 'package:i_doctor/UI/pages/settings/faq_page.dart';
import 'package:i_doctor/UI/pages/settings/privacy_policy_page.dart';
import 'package:i_doctor/UI/pages/settings/user_info_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey basketPageKey = GlobalKey();

get rootNavigatorKey => _rootNavigatorKey;
final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/feed',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/feed'),
      StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/feed',
                  builder: (ctx, state) => const FeedPage(),
                  routes: [
                    GoRoute(
                        path: 'user_info',
                        builder: (ctx, state) => const UserInformationPage(),
                        routes: [
                          GoRoute(
                              path: 'favorites',
                              builder: (ctx, state) => const FavoritesPage())
                        ]),
                    GoRoute(
                        path: '/login',
                        builder: (ctx, state) => const LoginPage(),
                        routes: [
                          GoRoute(
                              path: 'signup',
                              builder: (ctx, state) => const SignupPage())
                        ]),
                    GoRoute(
                        path: '/notifications',
                        builder: (ctx, state) => const NotificationsPage()),
                    GoRoute(
                      path: '/advert/:id',
                      builder: (context, state) =>
                          AdPage(id: state.pathParameters['id'] ?? ''),
                    ),
                    GoRoute(
                        path: '/advert_list/:collid',
                        builder: (ctx, state) =>
                            AdListPage(id: state.pathParameters['collid']!)),
                    GoRoute(
                        path: '/reviews_product/:productid',
                        builder: (ctx, state) => ReviewScreen(
                            type: 'product',
                            id: state.pathParameters['productid']!)),
                    GoRoute(
                        path: '/reviews_clinic/:clinicid',
                        builder: (ctx, state) => ReviewScreen(
                            type: 'clinic',
                            id: state.pathParameters['clinicid']!)),
                    GoRoute(
                        path: '/clinic/:clinicid',
                        builder: (ctx, state) =>
                            ClinicPage(id: state.pathParameters['clinicid']!)),
                    GoRoute(
                        path: '/clinics',
                        builder: (ctx, state) => const ClinicListPage()),
                    GoRoute(
                        path: '/category/:id',
                        builder: (ctx, state) =>
                            CategoryListPage(id: state.pathParameters['id']!)),
                  ]),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/appointments',
                  builder: (ctx, state) => const AppointmentsPage()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/cart',
                  builder: (ctx, state) => BasketPage(key: basketPageKey),
                  routes: [
                    GoRoute(
                        path: 'confirm',
                        builder: (ctx, state) => const ConfirmBasketPage(),
                        routes: [
                          GoRoute(
                              path: 'purchase_details',
                              builder: (ctx, state) =>
                                  const ConfirmPurchaseDetailsPage())
                        ])
                  ]),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/advertisements',
                  builder: (ctx, state) => const AdListPage(
                        id: '000',
                        hasBackButton: false,
                      ),
                  routes: [
                    GoRoute(
                      path: '/advert/:id',
                      builder: (context, state) =>
                          AdPage(id: state.pathParameters['id'] ?? ''),
                    ),
                    GoRoute(
                        path: '/advert_list/:collid',
                        builder: (ctx, state) =>
                            AdListPage(id: state.pathParameters['collid']!)),
                    GoRoute(
                        path: '/reviews_product/:productid',
                        builder: (ctx, state) => ReviewScreen(
                            type: 'product',
                            id: state.pathParameters['productid']!)),
                    GoRoute(
                        path: '/reviews_clinic/:clinicid',
                        builder: (ctx, state) => ReviewScreen(
                            type: 'clinic',
                            id: state.pathParameters['clinicid']!)),
                    GoRoute(
                        path: '/clinic/:clinicid',
                        builder: (ctx, state) =>
                            ClinicPage(id: state.pathParameters['clinicid']!)),
                    GoRoute(
                        path: '/clinics',
                        builder: (ctx, state) => const ClinicListPage()),
                    GoRoute(
                        path: '/category/:id',
                        builder: (ctx, state) =>
                            CategoryListPage(id: state.pathParameters['id']!)),
                  ]),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/settings',
                  builder: (ctx, state) => const SettingsPage(),
                  routes: [
                    GoRoute(
                        path: 'faq', builder: (ctx, state) => const FaqPage()),
                    GoRoute(
                        path: 'privacy_policy',
                        builder: (ctx, state) => const PrivacyPolicyPage()),
                    // GoRoute(
                    //     path: 'user_info',
                    //     builder: (ctx, state) => const UserInformationPage()),
                    // GoRoute(
                    //     path: '/login',
                    //     builder: (ctx, state) => const LoginPage(),
                    //     routes: [
                    //       GoRoute(
                    //           path: 'signup',
                    //           builder: (ctx, state) => const SignupPage())
                    //     ]),
                    GoRoute(
                        path: '/chat',
                        builder: (ctx, state) => const ChatPage()),
                  ])
            ])
          ],
          builder: (ctx, state, shell) {
            return BottomNavPage(
                key: bottomNavKey, ctx: ctx, state: state, shell: shell);
          }),
    ]);

extension GoRouterExtension on GoRouter {
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}
