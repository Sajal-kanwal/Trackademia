
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class FacultyService {
  final sb.SupabaseClient _supabaseClient;

  FacultyService(this._supabaseClient);

  Future<User> getFacultyProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return User.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch faculty profile: $e');
    }
  }

  Future<List<Notesheet>> getSubmissions() async {
    try {
      final response = await _supabaseClient
          .from('notesheets')
          .select('*, student_profiles:profiles!notesheets_student_id_fkey(full_name)') // Select notesheet and join with profiles to get student name
          .or('status.eq.submitted,status.eq.resubmitted'); // Or notesheets that are submitted or resubmitted

      return (response as List).map((e) => Notesheet.fromMap({
            ...e,
            'student_name': e['student_profiles']?['full_name'],
          })).toList();
    } catch (e) {
      throw Exception('Failed to fetch submissions: $e');
    }
  }

  Future<void> updateSubmissionStatus(String submissionId, String status, {String? comments}) async {
    try {
      await _supabaseClient
          .from('notesheets')
          .update({'status': status, 'faculty_reviewed_at': DateTime.now().toIso8601String()})
          .eq('id', submissionId);

      // Add entry to status_history
      await _supabaseClient.from('status_history').insert({
        'notesheet_id': submissionId,
        'new_status': status,
        'changed_by': _supabaseClient.auth.currentUser!.id,
        'change_reason': comments,
      });
    } catch (e) {
      throw Exception('Failed to update submission status: $e');
    }
  }
}
