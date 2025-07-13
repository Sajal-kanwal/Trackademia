
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for the ProfileService instance
final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());

// FutureProvider to get the current user's profile
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;
  final profileService = ref.watch(profileServiceProvider);
  return await profileService.getProfile(userId);
});

// StateNotifierProvider to handle profile updates
final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, bool>((ref) {
  return ProfileNotifier(ref.read(profileServiceProvider));
});

class ProfileNotifier extends StateNotifier<bool> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService) : super(false);

  Future<void> updateProfile(UserProfile profile) async {
    state = true;
    try {
      await _profileService.updateProfile(profile);
    } finally {
      state = false;
    }
  }
}
