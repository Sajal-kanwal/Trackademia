
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class HODService {
  final sb.SupabaseClient _supabaseClient;

  HODService(this._supabaseClient);

  Future<User> getHODProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return User.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch HOD profile: $e');
    }
  }

  Future<List<Notesheet>> getFacultyApprovedSubmissions() async {
    try {
      final response = await _supabaseClient
          .from('notesheets')
          .select('*, profiles(full_name)')
          .eq('status', 'faculty_approved');
      return (response as List).map((e) => Notesheet.fromMap({
            ...e,
            'student_name': e['profiles']['full_name'],
          })).toList();
    } catch (e) {
      throw Exception('Failed to fetch faculty approved submissions: $e');
    }
  }

  Future<void> makeFinalDecision(String submissionId, String decision, {String? comments}) async {
    try {
      await _supabaseClient
          .from('notesheets')
          .update({'status': decision, 'hod_reviewed_at': DateTime.now().toIso8601String()})
          .eq('id', submissionId);

      // Add entry to status_history
      await _supabaseClient.from('status_history').insert({
        'notesheet_id': submissionId,
        'new_status': decision,
        'changed_by': _supabaseClient.auth.currentUser!.id,
        'change_reason': comments,
      });
    } catch (e) {
      throw Exception('Failed to make final decision: $e');
    }
  }
}
