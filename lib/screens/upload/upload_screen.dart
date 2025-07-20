import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _semesterController = TextEditingController();
  final _courseCodeController = TextEditingController();
  File? _file;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _semesterController.dispose();
    _courseCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'pptx'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  void _uploadNotesheet() async {
    if (_formKey.currentState!.validate() && _file != null) {
      try {
        await ref.read(notesheetNotifierProvider.notifier).createNotesheet(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              category: _categoryController.text.trim(),
              semester: _semesterController.text.trim(),
              courseCode: _courseCodeController.text.trim(),
              file: _file!,
            );
        _showSuccessDialog();
        _resetForm();
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => ErrorMessage(message: 'Upload failed: ${e.toString()}'),
        );
      }
    } else if (_file == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload.')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Successful!', style: Theme.of(context).textTheme.headlineMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/congratulation.json',
                height: 150,
                repeat: false,
              ),
              Text('Your notesheet has been uploaded successfully.', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop the upload screen
              },
              child: Text('OK', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _semesterController.clear();
    _courseCodeController.clear();
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesheetState = ref.watch(notesheetNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Notesheet', style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _semesterController,
                decoration: InputDecoration(
                  labelText: 'Semester',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _courseCodeController,
                decoration: InputDecoration(
                  labelText: 'Course Code',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: SvgPicture.asset(
                      'assets/icons/cloud-upload.svg',
                      colorFilter: ColorFilter.mode(Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve(WidgetState.values.toSet()) ?? Colors.white, BlendMode.srcIn),
                      height: 24,
                    ),
                    label: const Text('Choose File'),
                    style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (_file != null)
                    Expanded(
                      child: Text(
                        _file!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: notesheetState ? null : _uploadNotesheet,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: notesheetState
                      ? const LoadingIndicator()
                      : Text('Upload', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
