import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/hod_provider.dart';
import 'package:notesheet_tracker/widgets/hod/approval_card.dart';

import 'package:notesheet_tracker/widgets/hod/hod_app_bar.dart';
import 'package:notesheet_tracker/widgets/common/quick_stats_icon.dart';
import 'package:notesheet_tracker/widgets/common/filter_icon.dart';
import 'package:notesheet_tracker/widgets/hod/hod_stats_section.dart';
import 'package:notesheet_tracker/widgets/hod/hod_filter_chips.dart';
import 'package:notesheet_tracker/widgets/hod/faculty_approved_list.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

class HODDashboard extends ConsumerStatefulWidget {
  const HODDashboard({super.key});

  @override
  ConsumerState<HODDashboard> createState() => _HODDashboardState();
}

class _HODDashboardState extends ConsumerState<HODDashboard> {
  String _selectedFilter = 'All Faculty Approved';

  @override
  Widget build(BuildContext context) {
    final approvalsAsyncValue = ref.watch(hodApprovalsProvider);

    return Column(
      children: [
        HODAppBar(
          title: 'Final Approvals',
          subtitle: 'HOD Review Center',
          actions: [
            QuickStatsIcon(approvalsPending: approvalsAsyncValue.when(
              data: (data) => data.length,
              loading: () => 0,
              error: (error, stack) => 0,
            )),
            FilterIcon(onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Filter Approvals'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('All Faculty Approved'),
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'All Faculty Approved';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Urgent'),
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Urgent';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Regular'),
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Regular';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Low Priority'),
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Low Priority';
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        Expanded(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  approvalsAsyncValue.when(
                    data: (approvals) {
                      final filteredApprovals = approvals.where((s) {
                        if (_selectedFilter == 'All Faculty Approved') return true;
                        if (_selectedFilter == 'Urgent') return s.priorityLevel == 'urgent';
                        if (_selectedFilter == 'Regular') return s.priorityLevel == 'normal';
                        if (_selectedFilter == 'Low Priority') return s.priorityLevel == 'low';
                        return false;
                      }).toList();

                      return Column(
                        children: [
                          HODStatsSection(
                            facultyApprovedCount: approvals.length,
                            finalApprovedCount: approvals.where((s) => s.status == 'final_approved').length,
                            rejectedByHOD: approvals.where((s) => s.status == 'final_rejected').length,
                            averageDecisionTime: const Duration(hours: 2, minutes: 15), // Placeholder for now
                          ),
                          HODFilterChips(
                            chips: [
                              {'label': 'All Faculty Approved', 'isDefault': true},
                              {'label': 'Urgent', 'priority': 'high'},
                              {'label': 'Regular', 'priority': 'normal'},
                              {'label': 'Low Priority', 'priority': 'low'},
                            ],
                            onChipTap: (filter) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
                            child: FacultyApprovedList(
                              submissions: filteredApprovals,
                              itemBuilder: (submission, index) =>
                                  ApprovalCard(
                                    submission: submission,
                                    onTap: () {
                                      context.go('/hod/approval/${submission.id}', extra: submission);
                                    },
                                  ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const LoadingIndicator(),
                    error: (error, stackTrace) => ErrorMessage(message: error.toString()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
