
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/services/hod_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final hodServiceProvider = Provider<HODService>((ref) {
  final supabaseClient = sb.Supabase.instance.client;
  return HODService(supabaseClient);
});

final hodProfileProvider = FutureProvider<User>((ref) {
  final hodService = ref.watch(hodServiceProvider);
  final userId = sb.Supabase.instance.client.auth.currentUser!.id;
  return hodService.getHODProfile(userId);
});

final hodApprovalsProvider = FutureProvider<List<Notesheet>>((ref) {
  final hodService = ref.watch(hodServiceProvider);
  return hodService.getFacultyApprovedSubmissions();
});
