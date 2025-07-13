import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/widgets/common/animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(
              _emailController.text.trim(),
            );
        if (!mounted) return;
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent!')),
        );
        if (!mounted) return;
        context.go('/login'); // Navigate back to login
      } catch (e) {
        if (!mounted) return;
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter your email to receive a password reset link.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/email.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).inputDecorationTheme.prefixIconColor ?? Colors.white70, BlendMode.srcIn),
                          height: 24,
                        ),
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                        filled: Theme.of(context).inputDecorationTheme.filled,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        border: Theme.of(context).inputDecorationTheme.border,
                        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                      ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: AnimatedButton(
                    onPressed: authState ? null : _sendResetEmail,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: authState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Send Reset Link',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
