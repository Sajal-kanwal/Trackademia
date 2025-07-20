
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/services/faculty_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final facultyServiceProvider = Provider<FacultyService>((ref) {
  final supabaseClient = sb.Supabase.instance.client;
  return FacultyService(supabaseClient);
});

final facultyProfileProvider = FutureProvider<User>((ref) {
  final facultyService = ref.watch(facultyServiceProvider);
  final userId = sb.Supabase.instance.client.auth.currentUser!.id;
  return facultyService.getFacultyProfile(userId);
});

final facultySubmissionsProvider = FutureProvider<List<Notesheet>>((ref) {
  final facultyService = ref.watch(facultyServiceProvider);
  return facultyService.getSubmissions();
});
