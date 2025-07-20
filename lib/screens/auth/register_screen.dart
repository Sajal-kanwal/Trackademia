import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/widgets/common/animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  String _selectedRole = 'student'; // Default role
  
  bool _obscurePassword = true;
  bool _isFullNameFocused = false;
  bool _isStudentIdFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isRoleFocused = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _studentIdController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _fullNameController.text.trim(),
            studentId: _studentIdController.text.trim(),
            role: _selectedRole,
          );
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String iconPath,
    required bool isFocused,
    required VoidCallback onFocusChange,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary.withOpacity( 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity( 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onFocusChange,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isFocused
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white70,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
          ),
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
            color: isFocused
                ? Theme.of(context).colorScheme.secondary
                : Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity( 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity( 0.2),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown() {
    final roleLabels = {
      'student': 'Student',
      'faculty': 'Faculty',
      'hod': 'Head of Department',
    };

    final roleIcons = {
      'student': Icons.school,
      'faculty': Icons.person,
      'hod': Icons.admin_panel_settings,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isRoleFocused
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  _isRoleFocused = !_isRoleFocused;
                  _isFullNameFocused = false;
                  _isStudentIdFocused = false;
                  _isEmailFocused = false;
                  _isPasswordFocused = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color: _isRoleFocused
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.white.withOpacity(0.2),
                    width: _isRoleFocused ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: _isRoleFocused
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register as',
                            style: TextStyle(
                              color: _isRoleFocused
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                roleIcons[_selectedRole]!,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                roleLabels[_selectedRole]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isRoleFocused ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: _isRoleFocused
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isRoleFocused)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: roleLabels.entries.map((entry) {
                  final isSelected = _selectedRole == entry.key;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRole = entry.key;
                          _isRoleFocused = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              roleIcons[entry.key]!,
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              entry.value,
                              style: TextStyle(
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const Spacer(),
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dark abstract.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity( 0.3),
                Colors.black.withOpacity( 0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo and Animation
                          Hero(
                            tag: 'app_logo',
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity( 0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity( 0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Lottie.asset(
                                'assets/animations/cat Mark loading.json',
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // App Title
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.secondary.withOpacity( 0.7),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Subtitle
                          Text(
                            'Join us and start tracking your notesheets.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          
                          // Full Name Field
                          _buildCustomTextField(
                            controller: _fullNameController,
                            label: 'Full Name',
                            iconPath: 'assets/icons/user.svg',
                            isFocused: _isFullNameFocused,
                            onFocusChange: () {
                              setState(() {
                                _isFullNameFocused = true;
                                _isStudentIdFocused = false;
                                _isEmailFocused = false;
                                _isPasswordFocused = false;
                                _isRoleFocused = false;
                              });
                            },
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (value.trim().split(' ').length < 2) {
                                return 'Please enter your first and last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Student ID Field
                          _buildCustomTextField(
                            controller: _studentIdController,
                            label: 'Student ID',
                            iconPath: 'assets/icons/badge.svg',
                            isFocused: _isStudentIdFocused,
                            onFocusChange: () {
                              setState(() {
                                _isStudentIdFocused = true;
                                _isFullNameFocused = false;
                                _isEmailFocused = false;
                                _isPasswordFocused = false;
                                _isRoleFocused = false;
                              });
                            },
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your student ID';
                              }
                              if (value.length < 3) {
                                return 'Student ID must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Role Selection Dropdown
                          _buildCustomDropdown(),
                          const SizedBox(height: 20),

                          // Email Field
                          _buildCustomTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            iconPath: 'assets/icons/email.svg',
                            isFocused: _isEmailFocused,
                            onFocusChange: () {
                              setState(() {
                                _isEmailFocused = true;
                                _isFullNameFocused = false;
                                _isStudentIdFocused = false;
                                _isPasswordFocused = false;
                                _isRoleFocused = false;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Password Field
                          _buildCustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            iconPath: 'assets/icons/lock.svg',
                            isFocused: _isPasswordFocused,
                            onFocusChange: () {
                              setState(() {
                                _isPasswordFocused = true;
                                _isFullNameFocused = false;
                                _isStudentIdFocused = false;
                                _isEmailFocused = false;
                                _isRoleFocused = false;
                              });
                            },
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: _isPasswordFocused
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                                return 'Password must contain uppercase, lowercase, and number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: AnimatedButton(
                              onPressed: authState ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: Theme.of(context).colorScheme.secondary.withOpacity( 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: authState
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Create Account',
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Sign In Link
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity( 0.05),
                              border: Border.all(
                                color: Colors.white.withOpacity( 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                AnimatedButton(
                                  onPressed: () => context.go('/login'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.secondary,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  child: Text(
                                    'Sign In',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}