
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthService {
  final sb.GoTrueClient _auth = sb.Supabase.instance.client.auth;

  // Get the current user
  sb.User? get currentUser => _auth.currentUser;

  // Get the auth state stream
  Stream<sb.AuthState> get authStateChanges => _auth.onAuthStateChange;

  // Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
    required String role,
  }) async {
    try {
      final sb.AuthResponse response = await _auth.signUp(
        email: email,
        password: password,
        data: {'role': role},
      );

      if (response.user != null) {
        await sb.Supabase.instance.client.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'student_id': studentId,
          'role': role,
        });
        // Explicitly sign in the user after successful registration
        await _auth.signInWithPassword(email: email, password: password);
      }
    } on sb.AuthException catch (e) {
      // Handle different auth exceptions
      throw Exception('Failed to sign up: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      // After successful sign-in, fetch the user's role
      await getUserRole();
    } on sb.AuthException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on sb.AuthException catch (e) {
      throw Exception('Failed to send reset email: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Get user role
  Future<String?> getUserRole() async {
    try {
      if (currentUser != null) {
        final response = await sb.Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', currentUser!.id)
            .single();
        return response['role'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}
