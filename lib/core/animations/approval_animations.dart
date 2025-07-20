
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/common/lottie_animation_widget.dart';
import 'package:notesheet_tracker/core/constants/app_colors.dart';

class ApprovalAnimations {
  // Executive Approval Animation
  static Future<void> playFinalApprovalAnimation(BuildContext context) async {
    // 1. Executive seal animation
    await showDialog(context: context, builder: (context) => AlertDialog(
      content: LottieAnimationWidget(animationPath: 'assets/animations/approval.json', repeat: false, animate: true,),
    ));

    // 2. Golden glow effect
    OverlayEntry? glowOverlayEntry;
    glowOverlayEntry = OverlayEntry(builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            return Container(
              width: 200 * value,
              height: 200 * value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5 * value),
                    blurRadius: 50.0 * value,
                    spreadRadius: 20.0 * value,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ));
    Overlay.of(context).insert(glowOverlayEntry);
    await Future.delayed(const Duration(milliseconds: 800));
    glowOverlayEntry.remove();

    // 3. Status upgrade animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status Upgraded: Faculty Approved -> Finally Approved', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: statusHODApproved,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 20, right: 20), // Position at top
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1000));

    // 4. Success ripple effect
    OverlayEntry? rippleOverlayEntry;
    rippleOverlayEntry = OverlayEntry(builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: 1.0 - value, // Fade out as it expands
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.withOpacity(1.0 - value), width: 5.0 * (1.0 - value)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
    Overlay.of(context).insert(rippleOverlayEntry);
    await Future.delayed(const Duration(milliseconds: 1200));
    rippleOverlayEntry.remove();
  }
}
