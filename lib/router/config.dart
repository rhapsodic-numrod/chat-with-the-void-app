import 'package:go_router/go_router.dart';
import 'package:test_firebase_chat_app2/pages/auth_page.dart';
import 'package:test_firebase_chat_app2/pages/auth_switcher.dart';
import 'package:test_firebase_chat_app2/pages/home_page.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const AuthSwitcher(),
    ),
    GoRoute(
      path: "/auth",
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
    ),

  ],
);
