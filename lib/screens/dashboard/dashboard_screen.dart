import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:notesheet_tracker/screens/dashboard/home_screen.dart';
import 'package:notesheet_tracker/screens/profile/profile_screen.dart';
import 'package:notesheet_tracker/screens/submissions/submissions_screen.dart';
import 'package:notesheet_tracker/screens/upload/upload_screen.dart';
import 'package:notesheet_tracker/screens/dashboard/notifications_screen.dart';
import 'package:notesheet_tracker/core/themes/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  
  late AnimationController _fabAnimationController;
  late AnimationController _pageAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  
  bool _isUploading = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SubmissionsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _pageAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index < _screens.length && index != _selectedIndex) {
      _pageAnimationController.forward().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        _pageAnimationController.reverse();
      });
    }
  }

  void _onFabPressed() async {
    if (_isUploading) return;
    
    setState(() {
      _isUploading = true;
    });
    
    _fabAnimationController.forward();
    
    await Future.delayed(const Duration(milliseconds: 150));
    
    _fabAnimationController.reverse();
    
    if (mounted) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const UploadScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
      
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildEnhancedFAB() {
    return AnimatedBuilder(
      animation: _fabAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: Transform.rotate(
            angle: _fabRotationAnimation.value * 2 * 3.14159,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.centerFAB,
                    AppTheme.centerFAB.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.centerFAB.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: AppTheme.centerFAB.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _onFabPressed,
                  child: Center(
                    child: _isUploading 
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/cloud-upload.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white, 
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ConvexAppBar(
        style: TabStyle.react,
        height: 65,
        backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        activeColor: AppTheme.centerFAB,
        curveSize: 90,
        top: -25,
        items: [
          _buildNavItem(0, 'assets/icons/home-simple.svg', 'Home'),
          _buildNavItem(1, 'assets/icons/submit-document.svg', 'Submissions'),
          _buildNavItem(2, 'assets/icons/app-notification.svg', 'Notifications'),
          _buildNavItem(3, 'assets/icons/user.svg', 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  TabItem _buildNavItem(int index, String iconPath, String title) {
    final isSelected = _selectedIndex == index;
    
    return TabItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isSelected ? 8 : 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.centerFAB.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: isSelected ? 22 : 20,
          height: isSelected ? 22 : 20,
          colorFilter: ColorFilter.mode(
            isSelected 
                ? AppTheme.centerFAB 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            BlendMode.srcIn,
          ),
        ),
      ),
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_pageAnimationController.value * 0.02),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _screens,
            ),
          );
        },
      ),
      bottomNavigationBar: _buildEnhancedBottomNav(),
      floatingActionButton: _buildEnhancedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}