import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/faculty_provider.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';

import 'package:notesheet_tracker/widgets/faculty/submission_card.dart';
import 'package:notesheet_tracker/widgets/faculty/faculty_app_bar.dart';
import 'package:notesheet_tracker/widgets/common/notification_icon.dart';
import 'package:notesheet_tracker/widgets/common/filter_icon.dart';
import 'package:notesheet_tracker/widgets/faculty/faculty_stats_section.dart';
import 'package:notesheet_tracker/widgets/common/filter_chips_row.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/widgets/faculty/staggered_submissions_list.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FacultyDashboard extends ConsumerStatefulWidget {
  const FacultyDashboard({super.key});

  @override
  ConsumerState<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends ConsumerState<FacultyDashboard> 
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Filter Submissions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ..._buildFilterOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFilterOptions() {
    final options = [
      {'label': 'All', 'icon': Icons.dashboard_rounded, 'color': Colors.blue},
      {'label': 'Pending', 'icon': Icons.pending_actions_rounded, 'color': Colors.orange},
      {'label': 'Approved', 'icon': Icons.check_circle_rounded, 'color': Colors.green},
      {'label': 'Rejected', 'icon': Icons.cancel_rounded, 'color': Colors.red},
      {'label': 'Resubmitted', 'icon': Icons.refresh_rounded, 'color': Colors.purple},
    ];

    return options.map((option) {
      final isSelected = _selectedFilter == option['label'];
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _selectedFilter = option['label'] as String;
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected 
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (option['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      color: option['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option['label'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final submissionsAsyncValue = ref.watch(facultySubmissionsProvider);
    final facultyProfile = ref.watch(facultyProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with Animation
            SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.05),
                        Theme.of(context).primaryColor.withOpacity(0.02),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: FacultyAppBar(
                    title: 'Review Center',
                    subtitle: 'Welcome back, Dr. ${facultyProfile.when(
                      data: (data) => data.fullName.split(' ').last,
                      loading: () => '',
                      error: (error, stack) => '',
                    )}',
                    actions: [
                      // Enhanced Notification Icon
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Handle notification tap
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: NotificationIcon(
                                badgeCount: ref.watch(notificationsProvider).when(
                                  data: (notifications) => notifications.where((n) => !n.isRead).length,
                                  loading: () => 0,
                                  error: (error, stack) => 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Enhanced Filter Icon
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _showFilterDialog,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.tune_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content Area
            Expanded(
              child: FadeTransition(
                opacity: _contentFadeAnimation,
                child: submissionsAsyncValue.when(
                  data: (submissions) {
                    final filteredSubmissions = submissions.where((s) {
                      if (_selectedFilter == 'All') return true;
                      if (_selectedFilter == 'Pending') return s.status == 'submitted' || s.status == 'resubmitted';
                      if (_selectedFilter == 'Approved') return s.status == 'faculty_approved';
                      if (_selectedFilter == 'Rejected') return s.status == 'faculty_rejected';
                      if (s.status == 'revision_requested') return true;
                      return false;
                    }).toList();

                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Stats Section
                        SliverToBoxAdapter(
                          child: AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: FacultyStatsSection(
                                    totalSubmissions: submissions.length,
                                    pendingReview: submissions.where((s) => s.status == 'submitted' || s.status == 'resubmitted').length,
                                    reviewed: submissions.where((s) => s.status == 'faculty_approved' || s.status == 'faculty_rejected' || s.status == 'revision_requested').length,
                                    averageTime: const Duration(hours: 1, minutes: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Filter Chips Section
                        SliverToBoxAdapter(
                          child: AnimationConfiguration.staggeredList(
                            position: 1,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  child: FilterChipsRow(
                                    chips: [
                                      {'label': 'All', 'count': submissions.length},
                                      {'label': 'Pending', 'count': submissions.where((s) => s.status == 'submitted' || s.status == 'resubmitted').length},
                                      {'label': 'Approved', 'count': submissions.where((s) => s.status == 'faculty_approved').length},
                                      {'label': 'Rejected', 'count': submissions.where((s) => s.status == 'faculty_rejected').length},
                                      {'label': 'Resubmitted', 'count': submissions.where((s) => s.status == 'revision_requested').length},
                                    ],
                                    onChipTap: (filter) {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Submissions List
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          sliver: filteredSubmissions.isEmpty
                              ? SliverFillRemaining(
                                  child: _buildEmptyState(),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final submission = filteredSubmissions[index];
                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          verticalOffset: 20.0,
                                          child: FadeInAnimation(
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 12),
                                              child: SubmissionCard(
                                                submission: submission,
                                                onTap: () {
                                                  context.go('/faculty/submission/${submission.id}', extra: submission);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: filteredSubmissions.length,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingState(),
                  error: (error, stackTrace) => _buildErrorState(error.toString()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200, // Minimum height to ensure it looks good
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24), // Reduced from 32
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 48, // Reduced from 64
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16), // Reduced from 24
            Text(
              'No submissions found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'There are no submissions matching your current filter.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24), // Reduced from 32
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Show All'),
            ),
            const SizedBox(height: 16), // Add bottom padding
          ],
        ),
      ),
    ),
  );
}

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const LoadingIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading submissions...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ErrorMessage(message: error),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                ref.refresh(facultySubmissionsProvider);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}