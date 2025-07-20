import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/user_model.dart';
import 'package:notesheet_tracker/providers/profile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final User userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _departmentController;
  late TextEditingController _semesterController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userProfile.fullName);
    _departmentController = TextEditingController(text: widget.userProfile.department);
    _semesterController = TextEditingController(text: widget.userProfile.semester);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _departmentController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = widget.userProfile.copyWith(
        fullName: _fullNameController.text.trim(),
        department: _departmentController.text.trim(),
        semester: _semesterController.text.trim(),
      );

      try {
        await ref.read(profileNotifierProvider.notifier).updateProfile(updatedProfile);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        if (!mounted) return;
        Navigator.pop(context); // Go back to profile screen
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => ErrorMessage(message: 'Failed to update profile: ${e.toString()}'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/user.svg',
                        colorFilter: ColorFilter.mode(Theme.of(context).inputDecorationTheme.prefixIconColor ?? Colors.grey, BlendMode.srcIn),
                        height: 24,
                      ),
                      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                      filled: Theme.of(context).inputDecorationTheme.filled,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      border: Theme.of(context).inputDecorationTheme.border,
                      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                      labelText: 'Department',
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/settings.svg', // Using settings as a placeholder
                        colorFilter: ColorFilter.mode(Theme.of(context).inputDecorationTheme.prefixIconColor ?? Colors.grey, BlendMode.srcIn),
                        height: 24,
                      ),
                      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                      filled: Theme.of(context).inputDecorationTheme.filled,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      border: Theme.of(context).inputDecorationTheme.border,
                      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _semesterController,
                decoration: InputDecoration(
                      labelText: 'Semester',
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/settings.svg', // Using settings as a placeholder
                        colorFilter: ColorFilter.mode(Theme.of(context).inputDecorationTheme.prefixIconColor ?? Colors.grey, BlendMode.srcIn),
                        height: 24,
                      ),
                      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                      filled: Theme.of(context).inputDecorationTheme.filled,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      border: Theme.of(context).inputDecorationTheme.border,
                      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                    ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: isLoading
                      ? const LoadingIndicator()
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}