
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/common/animated_counter.dart';
import 'package:notesheet_tracker/widgets/common/animated_timer.dart';

class HODStatsSection extends StatelessWidget {
  final int facultyApprovedCount;
  final int finalApprovedCount;
  final int rejectedByHOD;
  final Duration averageDecisionTime;

  const HODStatsSection({
    super.key,
    required this.facultyApprovedCount,
    required this.finalApprovedCount,
    required this.rejectedByHOD,
    required this.averageDecisionTime,
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
            'Faculty Approved',
            AnimatedCounter(value: facultyApprovedCount),
          ),
          _buildStatCard(
            context,
            'Final Approved',
            AnimatedCounter(value: finalApprovedCount),
          ),
          _buildStatCard(
            context,
            'Rejected by HOD',
            AnimatedCounter(value: rejectedByHOD),
          ),
          _buildStatCard(
            context,
            'Avg. Decision Time',
            AnimatedTimer(duration: averageDecisionTime),
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
