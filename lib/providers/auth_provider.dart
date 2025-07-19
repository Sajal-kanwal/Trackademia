
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/services/auth_service.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';
import 'package:notesheet_tracker/providers/profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for the AuthService instance
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// StreamProvider to listen to authentication state changes
// This will let the app know when a user logs in or out in real-time.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// StateNotifierProvider to handle authentication actions like login, logout, etc.
// The boolean state represents the loading status (true if an action is in progress).
final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.read(authServiceProvider), ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(false);

  // Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  }) async {
    state = true; // Set loading state
    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        studentId: studentId,
      );
    } finally {
      state = false; // Reset loading state
    }
  }

  // Sign in an existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await _authService.signIn(email: email, password: password);
    } finally {
      state = false;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    state = true;
    try {
      await _authService.signOut();
      _ref.invalidate(userProfileProvider); // Invalidate userProfileProvider on sign out
      _ref.invalidate(notesheetsProvider);
      _ref.invalidate(notesheetCountsProvider);
      _ref.invalidate(notificationsProvider);
    } finally {
      state = false;
    }
  }

  // Send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = true;
    try {
      await _authService.sendPasswordResetEmail(email);
    } finally {
      state = false;
    }
  }
}
