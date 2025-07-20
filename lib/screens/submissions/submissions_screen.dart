import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

// StateProvider for the selected filter status
final notesheetFilterProvider = StateProvider<String>((ref) => 'All');

class SubmissionsScreen extends ConsumerStatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  ConsumerState<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends ConsumerState<SubmissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedFilter = ref.watch(notesheetFilterProvider);
    final notesheetsAsyncValue = ref.watch(notesheetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Submissions', style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', selectedFilter, context, ref),
                  _buildFilterChip('submitted', selectedFilter, context, ref),
                  _buildFilterChip('under_review', selectedFilter, context, ref),
                  _buildFilterChip('approved', selectedFilter, context, ref),
                  _buildFilterChip('rejected', selectedFilter, context, ref),
                  _buildFilterChip('revision_requested', selectedFilter, context, ref),
                ],
              ),
            ),
          ),
          Expanded(
            child: notesheetsAsyncValue.when(
              data: (notesheets) {
                final filteredNotesheets = notesheets.where((notesheet) {
                  if (selectedFilter == 'All') {
                    return true;
                  }
                  return notesheet.status == selectedFilter;
                }).toList();

                if (filteredNotesheets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/Empty State.json',
                          height: 200,
                        ),
                        Text('No notesheets found for this filter.', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(notesheetsProvider.future),
                  child: ListView.builder(
                    itemCount: filteredNotesheets.length,
                    itemBuilder: (context, index) {
                      final notesheet = filteredNotesheets[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/submit-document.svg',
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                            height: 24,
                            width: 24,
                          ),
                          title: Text(notesheet.title, style: Theme.of(context).textTheme.bodyLarge),
                          subtitle: Text('Category: ${notesheet.category} - Status: ${notesheet.status}', style: Theme.of(context).textTheme.bodyMedium),
                          trailing: Text(notesheet.fileName, style: Theme.of(context).textTheme.bodySmall),
                          onTap: () {
                            GoRouter.of(context).go('/notesheet/${notesheet.id}', extra: notesheet);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: ${error.toString()}')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedFilter, BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label.replaceAll('_', ' ').toUpperCase()),
        selected: selectedFilter == label,
        onSelected: (selected) {
          if (selected) {
            ref.read(notesheetFilterProvider.notifier).state = label;
          }
        },
        selectedColor: Theme.of(context).chipTheme.selectedColor,
        labelStyle: selectedFilter == label
            ? Theme.of(context).chipTheme.labelStyle
            : Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        backgroundColor: Theme.of(context).chipTheme.backgroundColor,
      ),
    );
  }
}
