
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:notesheet_tracker/models/user_model.dart';

class ProfileService {
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  Future<User?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return User.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> updateProfile(User profile) async {
    try {
      await _client
          .from('profiles')
          .update(profile.toMap())
          .eq('id', profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
