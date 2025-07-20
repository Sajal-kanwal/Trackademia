
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/review_model.dart';
import 'package:notesheet_tracker/services/review_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final supabaseClient = sb.Supabase.instance.client;
  return ReviewService(supabaseClient);
});

final reviewProvider = FutureProvider.family<List<Review>, String>((ref, notesheetId) {
  final reviewService = ref.watch(reviewServiceProvider);
  return reviewService.getReviews(notesheetId);
});
