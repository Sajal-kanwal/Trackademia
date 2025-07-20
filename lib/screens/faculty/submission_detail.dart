import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/providers/review_provider.dart';
import 'package:notesheet_tracker/widgets/faculty/review_actions_panel.dart';
import 'package:notesheet_tracker/widgets/faculty/student_info_card.dart';
import 'package:notesheet_tracker/widgets/faculty/document_preview_section.dart';
import 'package:notesheet_tracker/widgets/faculty/animated_status_timeline.dart';
import 'package:notesheet_tracker/widgets/faculty/comments_section.dart';
import 'package:notesheet_tracker/widgets/faculty/review_action.dart';
import 'package:notesheet_tracker/core/constants/app_colors.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/widgets/common/comment_dialog.dart';
import 'package:notesheet_tracker/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';
import 'package:notesheet_tracker/core/animations/review_animations.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:notesheet_tracker/providers/faculty_provider.dart'; // Explicitly import faculty providers

class SubmissionDetailScreen extends ConsumerStatefulWidget {
  final Notesheet submission;

  const SubmissionDetailScreen({super.key, required this.submission});

  @override
  ConsumerState<SubmissionDetailScreen> createState() => _SubmissionDetailScreenState();
}

class _SubmissionDetailScreenState extends ConsumerState<SubmissionDetailScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(reviewProvider(widget.submission.id!));
    final facultyService = ref.watch(facultyServiceProvider);
    final reviewService = ref.watch(reviewServiceProvider);

    // Placeholder User model for demonstration
    final User student = User(id: widget.submission.studentId, fullName: widget.submission.studentName ?? 'N/A', email: '', createdAt: DateTime.now(), updatedAt: DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.submission.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                StudentInfoCard(
                  student: student,
                  submissionDate: widget.submission.createdAt ?? DateTime.now(),
                  category: widget.submission.category,
                ),
                DocumentPreviewSection(
                  fileUrl: widget.submission.fileUrl,
                  fileName: widget.submission.fileName,
                  fileSize: '${(widget.submission.fileSize ?? 0) / 1024} KB', // Convert bytes to KB
                  onDownload: () {},
                  onFullscreen: () {},
                ),
                AnimatedStatusTimeline(
                  history: const [
                    {'status': 'submitted', 'date': '2023-01-01'},
                    {'status': 'faculty_review', 'date': '2023-01-02'},
                    {'status': 'faculty_approved', 'date': '2023-01-03'},
                  ], // Placeholder history
                  currentStatus: widget.submission.status,
                  animationDelay: const Duration(milliseconds: 200),
                ),
                commentsAsyncValue.when(
                  data: (comments) => CommentsSection(
                    comments: comments.map((e) => e.comments ?? '').toList(),
                    onAddComment: (comment) async {
                      final newReview = Review(
                        id: const Uuid().v4(),
                        notesheetId: widget.submission.id!,
                        reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                        reviewerType: 'faculty',
                        decision: 'comment',
                        comments: comment,
                        reviewedAt: DateTime.now(),
                        createdAt: DateTime.now(),
                      );
                      await reviewService.addReview(newReview);
                      ref.invalidate(reviewProvider(widget.submission.id!));
                    },
                    expandAnimation: const Duration(milliseconds: 250),
                  ),
                  loading: () => const LoadingIndicator(),
                  error: (error, stack) => ErrorMessage(message: error.toString()),
                ),
                ReviewActionsPanel(
                  actions: [
                    ReviewAction(
                      icon: Icons.check_circle,
                      label: 'Approve',
                      color: statusFacultyApproved,
                      onTap: () async {
                        final comments = await showDialog<String>(
                          context: context,
                          builder: (context) => const CommentDialog(
                            title: 'Approve Submission',
                            hintText: 'Add comments (optional)',
                          ),
                        );
                        if (comments != null) {
                          await facultyService.updateSubmissionStatus(widget.submission.id!, 'faculty_approved', comments: comments);
                          final newReview = Review(
                            id: const Uuid().v4(),
                            notesheetId: widget.submission.id!,
                            reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                            reviewerType: 'faculty',
                            decision: 'approved',
                            comments: comments,
                            reviewedAt: DateTime.now(),
                            createdAt: DateTime.now(),
                          );
                          await reviewService.addReview(newReview);
                          ref.invalidate(reviewProvider(widget.submission.id!));
                          ref.invalidate(facultySubmissionsProvider);
                          ReviewActionAnimations.playApprovalAnimation(context, _confettiController);
                        }
                      },
                    ),
                    ReviewAction(
                      icon: Icons.cancel,
                      label: 'Reject',
                      color: statusRejected,
                      onTap: () async {
                        final comments = await showDialog<String>(
                          context: context,
                          builder: (context) => const CommentDialog(
                            title: 'Reject Submission',
                            hintText: 'Add comments (required)',
                          ),
                        );
                        if (comments != null) {
                          await facultyService.updateSubmissionStatus(widget.submission.id!, 'faculty_rejected', comments: comments);
                          final newReview = Review(
                            id: const Uuid().v4(),
                            notesheetId: widget.submission.id!,
                            reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                            reviewerType: 'faculty',
                            decision: 'rejected',
                            comments: comments,
                            reviewedAt: DateTime.now(),
                            createdAt: DateTime.now(),
                          );
                          await reviewService.addReview(newReview);
                          ref.invalidate(reviewProvider(widget.submission.id!));
                          ref.invalidate(facultySubmissionsProvider);
                          ReviewActionAnimations.playRejectionAnimation(context);
                        }
                      },
                    ),
                    ReviewAction(
                      icon: Icons.edit,
                      label: 'Request Changes',
                      color: statusRevisionRequested,
                      onTap: () async {
                        final comments = await showDialog<String>(
                          context: context,
                          builder: (context) => const CommentDialog(
                            title: 'Request Changes',
                            hintText: 'Add comments (required)',
                          ),
                        );
                        if (comments != null) {
                          await facultyService.updateSubmissionStatus(widget.submission.id!, 'revision_requested', comments: comments);
                          final newReview = Review(
                            id: const Uuid().v4(),
                            notesheetId: widget.submission.id!,
                            reviewerId: sb.Supabase.instance.client.auth.currentUser!.id,
                            reviewerType: 'faculty',
                            decision: 'revision_requested',
                            comments: comments,
                            reviewedAt: DateTime.now(),
                            createdAt: DateTime.now(),
                          );
                          await reviewService.addReview(newReview);
                          ref.invalidate(reviewProvider(widget.submission.id!));
                          ref.invalidate(facultySubmissionsProvider);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
              shouldLoop: false, // don't loop the animation
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path to draw
            ),
          ),
        ],
      ),
    );
  }

  /// A custom Path to paint stars. 
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final Path path = Path();
    final double fullAngle = 2 * pi / numberOfPoints;
    final double startAngle = degToRad(-18);

    for (int i = 0; i < numberOfPoints; i++) {
      final double angle = startAngle + fullAngle * i;
      path.lineTo(externalRadius * cos(angle), externalRadius * sin(angle));
      path.lineTo(internalRadius * cos(angle + fullAngle / 2), internalRadius * sin(angle + fullAngle / 2));
    }
    path.close();
    return path;
  }
}