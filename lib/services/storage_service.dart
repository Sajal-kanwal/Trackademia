
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseStorageClient _storage = Supabase.instance.client.storage;

  Future<String> uploadFile(String bucket, File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      await _storage.from(bucket).upload(fileName, file);
      return _storage.from(bucket).getPublicUrl(fileName);
    } on StorageException catch (e) {
      throw Exception('Failed to upload file: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
