
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notesheet_tracker/models/user_model.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
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
