
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';

class StaggeredSubmissionsList extends StatelessWidget {
  final List<Notesheet> submissions;
  final Duration staggerDelay;
  final Widget Function(Notesheet submission, int index) itemBuilder;

  const StaggeredSubmissionsList({
    super.key,
    required this.submissions,
    required this.staggerDelay,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            delay: staggerDelay,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: itemBuilder(submissions[index], index),
              ),
            ),
          );
        },
      ),
    );
  }
}
