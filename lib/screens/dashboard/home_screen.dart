import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesheetCountsAsyncValue = ref.watch(notesheetCountsProvider);

    return notesheetCountsAsyncValue.when(
      data: (counts) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Notesheets: ${counts['total'] ?? 0}'),
              Text('Pending: ${counts['submitted'] ?? 0}'),
              Text('Approved: ${counts['final_approved'] ?? 0}'),
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorMessage(message: error.toString()),
    );
  }
}