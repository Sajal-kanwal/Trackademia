import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/screens/auth/login_screen.dart';
import 'package:notesheet_tracker/screens/auth/register_screen.dart';
import 'package:notesheet_tracker/screens/auth/forgot_password_screen.dart';
import 'package:notesheet_tracker/screens/unified_dashboard_layout.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/screens/faculty/submission_detail.dart';
import 'package:notesheet_tracker/screens/hod/approval_detail.dart';
import 'package:notesheet_tracker/screens/student/notesheet_detail_screen.dart';

// Using a GlobalKey to access the navigator state
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
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
        path: '/',
        builder: (context, state) {
          return const UnifiedDashboardLayout();
        },
      ),
      // Detail routes that are not part of the main navigation
      GoRoute(
        path: '/faculty/submission/:id',
        builder: (context, state) {
          final submission = state.extra as Notesheet;
          return SubmissionDetailScreen(
            submission: submission,
          );
        },
      ),
      GoRoute(
        path: '/hod/approval/:id',
        builder: (context, state) {
          final submission = state.extra as Notesheet;
          return ApprovalDetailScreen(
            submission: submission,
          );
        },
      ),
      GoRoute(
        path: '/notesheet/:id',
        builder: (context, state) {
          final notesheet = state.extra as Notesheet;
          return NotesheetDetailScreen(
            notesheet: notesheet,
          );
        },
      ),
    ],
    redirect: (context, state) async {
      final isAuthenticated = authState.value?.session != null;
      final isAuthenticating = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isAuthenticating) {
        return '/login';
      }

      if (isAuthenticated && isAuthenticating) {
        final userRole = await ref.read(authServiceProvider).getUserRole();
        // Redirect to the unified dashboard after login
        return '/';
      }

      return null; // No redirect needed
    },
  );
});