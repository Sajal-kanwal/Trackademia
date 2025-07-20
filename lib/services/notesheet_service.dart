import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:notesheet_tracker/models/notesheet_model.dart';

class NotesheetService {
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  // Create a new notesheet
  Future<void> createNotesheet(Notesheet notesheet) async {
    try {
      await _client.from('notesheets').insert(notesheet.toMap());
    } catch (e) {
      throw Exception('Failed to create notesheet: $e');
    }
  }

  // Get all notesheets for the current user
  Future<List<Notesheet>> getNotesheets() async {
    try {
      final String? userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated.');
      }
      final List<Map<String, dynamic>> response = await _client
          .from('notesheets')
          .select()
          .eq('student_id', userId)
          .order('created_at', ascending: false);

      return response.map((item) => Notesheet.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to get notesheets: $e');
    }
  }

  // Update a notesheet
  Future<void> updateNotesheet(Notesheet notesheet) async {
    try {
      if (notesheet.id == null) {
        throw Exception('Notesheet ID cannot be null for update operation');
      }
      await _client
          .from('notesheets')
          .update(notesheet.toMap())
          .eq('id', notesheet.id!);
    } catch (e) {
      throw Exception('Failed to update notesheet: $e');
    }
  }

  // Delete a notesheet
  Future<void> deleteNotesheet(String id) async {
    try {
      await _client.from('notesheets').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete notesheet: $e');
    }
  }

  // Get notesheet counts by status for the current user
  Future<Map<String, int>> getNotesheetCountsByStatus() async {
    try {
      final String? userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated.');
      }
      final List<Map<String, dynamic>> response = await _client
          .from('notesheets')
          .select('status')
          .eq('student_id', userId);

      final counts = <String, int>{};
      for (var item in response) {
        final status = item['status'] as String?;
        if (status != null) {
          counts[status] = (counts[status] ?? 0) + 1;
        }
      }
      return counts;
    } catch (e) {
      throw Exception('Failed to get notesheet counts: $e');
    }
  }

  // Get a single notesheet by ID
  Future<Notesheet?> getNotesheetById(String notesheetId) async {
    try {
      final response = await _client
          .from('notesheets')
          .select('*, profiles!notesheets_student_id_fkey(full_name)') // Select notesheet and join with profiles to get student name
          .eq('id', notesheetId)
          .single();

      return Notesheet.fromMap({
        ...response,
        'student_name': response['profiles']['full_name'],
      });
    } catch (e) {
      print('Error fetching notesheet by ID: $e');
      return null;
    }
  }
}