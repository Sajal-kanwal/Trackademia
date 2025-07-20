
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/providers/review_provider.dart';
import 'package:notesheet_tracker/widgets/hod/executive_summary_card.dart';
import 'package:notesheet_tracker/widgets/hod/quick_document_preview.dart';
import 'package:notesheet_tracker/widgets/hod/executive_status_timeline.dart';
import 'package:notesheet_tracker/widgets/hod/faculty_review_summary.dart';
import 'package:notesheet_tracker/widgets/hod/hod_decision_panel.dart';
import 'package:notesheet_tracker/widgets/hod/hod_comments_section.dart';
import 'package:notesheet_tracker/widgets/hod/executive_action.dart';
import 'package:notesheet_tracker/core/constants/app_colors.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/widgets/common/comment_dialog.dart';
import 'package:notesheet_tracker/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:notesheet_tracker/core/animations/approval_animations.dart';
import 'package:notesheet_tracker/providers/hod_provider.dart';

class ApprovalDetailScreen extends ConsumerWidget {
  final Notesheet submission;

  const ApprovalDetailScreen({super.key, required this.submission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncValue = ref.watch(reviewProvider(submission.id!));
    final hodService = ref.watch(hodServiceProvider);
    final reviewService = ref.watch(reviewServiceProvider);

    // Placeholder User models for demonstration
    final User student = User(id: submission.studentId, fullName: submission.studentName ?? 'N/A', email: '', createdAt: DateTime.now(), updatedAt: DateTime.now());
    final User faculty = User(id: submission.facultyReviewerId ?? '', fullName: submission.facultyReviewerName ?? 'N/A', email: '', createdAt: DateTime.now(), updatedAt: DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(submission.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExecutiveSummaryCard(
              student: student,
              faculty: faculty,
              facultyDecision: submission.status, // Assuming submission status reflects faculty decision
              facultyDate: submission.facultyReviewedAt ?? DateTime.now(),
            ),
            QuickDocumentPreview(
              fileUrl: submission.fileUrl,
              fileName: submission.fileName,
              onFullView: () {},
            ),
            ExecutiveStatusTimeline(
              stages: [
                TimelineStage('Submitted', submission.createdAt ?? DateTime.now(), 'completed'),
                TimelineStage('Faculty Review', submission.facultyReviewedAt ?? DateTime.now(), 'completed'),
                TimelineStage('HOD Final Review', DateTime.now(), 'current'),
              ],
              animateOnLoad: true,
            ),
            FacultyReviewSummary(
              reviewer: faculty,
              decision: submission.status,
              comments: commentsAsyncValue.when(
                data: (comments) => comments.map((e) => e.comments ?? '').join('\n'),
                loading: () => 'Loading comments...',
                error: (error, stack) => 'Error loading comments',
              ),
              reviewDate: submission.facultyReviewedAt ?? DateTime.now(),
            ),
            HODDecisionPanel(
              actions: [
                ExecutiveAction(
                  icon: Icons.verified,
                  label: 'Final Approve',
                  color: statusHODApproved,
                  description: 'Grant final approval',
                  onTap: () async {
                    final comments = await showDialog<String>(
                      context: context,
                      builder: (context) => const CommentDialog(
                        title: 'Final Approve Submission',
                        hintText: 'Add comments (optional)',
                      ),
                    );
                    if (comments != null) {
                      await hodService.makeFinalDecision(submission.id!, 'final_approved', comments: comments);
                      final newReview = Review(
                        id: UniqueKey().toString(),
                        notesheetId: submission.id!,
                        reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                        reviewerType: 'hod',
                        decision: 'approved',
                        comments: comments,
                        reviewedAt: DateTime.now(),
                        createdAt: DateTime.now(),
                      );
                      await reviewService.addReview(newReview);
                      ref.invalidate(reviewProvider(submission.id!));
                      ref.invalidate(hodApprovalsProvider);
                      ApprovalAnimations.playFinalApprovalAnimation(context);
                    }
                  },
                ),
                ExecutiveAction(
                  icon: Icons.gavel,
                  label: 'Executive Reject',
                  color: statusHODRejected,
                  description: 'Final rejection decision',
                  onTap: () async {
                    final comments = await showDialog<String>(
                      context: context,
                      builder: (context) => const CommentDialog(
                        title: 'Executive Reject Submission',
                        hintText: 'Add comments (required)',
                      ),
                    );
                    if (comments != null) {
                      await hodService.makeFinalDecision(submission.id!, 'final_rejected', comments: comments);
                      final newReview = Review(
                        id: UniqueKey().toString(),
                        notesheetId: submission.id!,
                        reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                        reviewerType: 'hod',
                        decision: 'rejected',
                        comments: comments,
                        reviewedAt: DateTime.now(),
                        createdAt: DateTime.now(),
                      );
                      await reviewService.addReview(newReview);
                      ref.invalidate(reviewProvider(submission.id!));
                      ref.invalidate(hodApprovalsProvider);
                    }
                  },
                ),
              ],
            ),
            HODCommentsSection(
              placeholder: 'Add executive remarks...',
              onSubmit: (comment) async {
                final newReview = Review(
                  id: UniqueKey().toString(),
                  notesheetId: submission.id!,
                  reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                  reviewerType: 'hod',
                  decision: 'comment',
                  comments: comment,
                  reviewedAt: DateTime.now(),
                  createdAt: DateTime.now(),
                );
                await reviewService.addReview(newReview);
                ref.invalidate(reviewProvider(submission.id!));
              },
            ),
          ],
        ),
      ),
    );
  }
}
