
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/common/animated_counter.dart';
import 'package:notesheet_tracker/widgets/common/animated_timer.dart';

class FacultyStatsSection extends StatelessWidget {
  final int totalSubmissions;
  final int pendingReview;
  final int reviewed;
  final Duration averageTime;

  const FacultyStatsSection({
    super.key,
    required this.totalSubmissions,
    required this.pendingReview,
    required this.reviewed,
    required this.averageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildStatCard(
            context,
            'Total Submissions',
            AnimatedCounter(value: totalSubmissions),
          ),
          _buildStatCard(
            context,
            'Pending Review',
            AnimatedCounter(value: pendingReview),
          ),
          _buildStatCard(
            context,
            'Reviewed',
            AnimatedCounter(value: reviewed),
          ),
          _buildStatCard(
            context,
            'Avg. Review Time',
            AnimatedTimer(duration: averageTime),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, Widget valueWidget) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            valueWidget,
          ],
        ),
      ),
    );
  }
}
