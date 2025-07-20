
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/hod_provider.dart';
import 'package:notesheet_tracker/widgets/hod/history_filters_section.dart';

import 'package:notesheet_tracker/providers/notesheet_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'All Decisions';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final hodDecisionHistoryAsyncValue = ref.watch(hodApprovalsProvider);
    final notesheetService = ref.watch(notesheetServiceProvider);
    

    return Column(
      children: [
        HistoryFiltersSection(
          filters: const [
            'All Decisions',
            'Approved by Me',
            'Rejected by Me',
            'This Month',
            'Last 3 Months',
          ],
          searchHint: 'Search by student name, document title...',
          onFilterTap: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
      ],
    );
  }
}
