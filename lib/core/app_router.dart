
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/screens/auth/forgot_password_screen.dart';
import 'package:notesheet_tracker/screens/auth/login_screen.dart';
import 'package:notesheet_tracker/screens/auth/register_screen.dart';
import 'package:notesheet_tracker/screens/dashboard/dashboard_screen.dart';
import 'package:notesheet_tracker/screens/dashboard/notifications_screen.dart';
import 'package:notesheet_tracker/screens/profile/profile_screen.dart';

// Using a GlobalKey to access the navigator state
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authState.value?.session != null;
      final isAuthenticating = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isAuthenticating) {
        return '/login';
      }

      if (isAuthenticated && isAuthenticating) {
        return '/';
      }

      return null; // No redirect needed
    },
  );
});
