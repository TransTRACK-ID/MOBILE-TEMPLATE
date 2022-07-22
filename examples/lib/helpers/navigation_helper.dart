import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:result_test/helpers/user_helper.dart';
import 'package:result_test/modules/login/view/login_page.dart';
import 'package:result_test/modules/splash/view/splash_page.dart';
import 'package:result_test/utils/constants.dart';

class NavigationHelper {
  final GoRouter goRouter = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    observers: [],
    routes: [
      GoRoute(
        path: '/',
        name: 'splashpage',
        builder: (context, routerState) => const SplashPage(),
        redirect: redirectWhenAuthenticate,
        routes: [
          GoRoute(
            path: 'login',
            name: 'loginpage',
            // builder: (context, routerState) => const LoginPage(),
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
            redirect: (routerState) {
              final loggedIn = GetIt.I<UserHelper>().isLoggedIn;

              if (!loggedIn) return null;

              return '/';
            },
          ),
        ],
      ),
    ],
  );

  static String? redirectWhenAuthenticate(GoRouterState routerState) {
    final loggedIn = GetIt.I<UserHelper>().isLoggedIn;

    if (!loggedIn) return '/login';

    return '/dashboard';
  }

  void pop() {
    goRouter.pop();
  }

  void go(String location, {Object? extra}) {
    goRouter.go(location, extra: extra);
  }

  void goNamed(String name, {Object? extra}) {
    goRouter.goNamed(name, extra: extra);
  }

  void pushNamed(String name) {
    goRouter.pushNamed(name);
  }

  void goToSplash() {
    goNamed('splashpage');
  }

  void goToLogin() {
    goNamed('loginpage');
  }
}
