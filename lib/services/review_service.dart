
import 'package:notesheet_tracker/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class ReviewService {
  final sb.SupabaseClient _supabaseClient;

  ReviewService(this._supabaseClient);

  Future<void> addReview(Review review) async {
    try {
      await _supabaseClient.from('reviews').insert(review.toMap());
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  Future<List<Review>> getReviews(String notesheetId) async {
    try {
      final response = await _supabaseClient
          .from('reviews')
          .select()
          .eq('notesheet_id', notesheetId)
          .order('created_at', ascending: true);
      return (response as List).map((e) => Review.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }
}
