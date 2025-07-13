
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/services/notesheet_service.dart';
import 'package:notesheet_tracker/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

// Provider for the NotesheetService instance
final notesheetServiceProvider = Provider<NotesheetService>((ref) => NotesheetService());

// Provider for the StorageService instance
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// FutureProvider to get the list of notesheets
final notesheetsProvider = FutureProvider<List<Notesheet>>((ref) async {
  final notesheetService = ref.watch(notesheetServiceProvider);
  return await notesheetService.getNotesheets();
});

// FutureProvider to get notesheet counts by status
final notesheetCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final notesheetService = ref.watch(notesheetServiceProvider);
  return await notesheetService.getNotesheetCountsByStatus();
});

// StateNotifierProvider to handle notesheet actions like creating, updating, etc.
final notesheetNotifierProvider = StateNotifierProvider<NotesheetNotifier, bool>((ref) {
  return NotesheetNotifier(
    ref.read(notesheetServiceProvider),
    ref.read(storageServiceProvider),
    ref, // Pass ref to the Notifier
  );
});

class NotesheetNotifier extends StateNotifier<bool> {
  final NotesheetService _notesheetService;
  final StorageService _storageService;
  final Ref _ref; // Store the ref

  NotesheetNotifier(this._notesheetService, this._storageService, this._ref) : super(false);

  // Create a new notesheet
  Future<void> createNotesheet({
    required String title,
    String? description,
    required String category,
    String? semester,
    String? courseCode,
    required File file,
  }) async {
    state = true;
    try {
      final fileUrl = await _storageService.uploadFile('notesheets', file);
      final notesheet = Notesheet(
        studentId: Supabase.instance.client.auth.currentUser!.id,
        title: title,
        description: description,
        category: category,
        semester: semester,
        courseCode: courseCode,
        fileUrl: fileUrl,
        fileName: file.path.split('/').last,
        fileSize: await file.length(),
      );
      await _notesheetService.createNotesheet(notesheet);
      _ref.invalidate(notesheetsProvider);
      _ref.invalidate(notesheetCountsProvider);
    } finally {
      state = false;
    }
  }
}
