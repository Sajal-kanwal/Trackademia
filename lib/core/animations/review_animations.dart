
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:notesheet_tracker/core/constants/app_colors.dart';
import 'package:notesheet_tracker/widgets/common/lottie_animation_widget.dart';

class ReviewActionAnimations {
  // Placeholder for button scale animation (would be handled by the button widget itself)
  static Future<void> scaleButton({required double scale, required Duration duration}) async {
    // print('Simulating button scale to $scale for ${duration.inMilliseconds}ms');
    await Future.delayed(duration);
  }

  // Placeholder for color transition animation (would be handled by the status badge widget itself)
  static Future<void> animateColorTransition({
    required Color from,
    required Color to,
    required Duration duration,
  }) async {
    // print('Simulating color transition from $from to $to for ${duration.inMilliseconds}ms');
    await Future.delayed(duration);
  }

  // Approval Animation Sequence
  static Future<void> playApprovalAnimation(BuildContext context, ConfettiController confettiController) async {
    // 1. Button press feedback (simulated)
    await scaleButton(scale: 0.95, duration: const Duration(milliseconds: 100));
    await scaleButton(scale: 1.05, duration: const Duration(milliseconds: 150));

    // 2. Status badge color transition (simulated)
    await animateColorTransition(
      from: statusPendingReview,
      to: statusFacultyApproved,
      duration: const Duration(milliseconds: 400),
    );

    // 3. Confetti celebration
    confettiController.play();
    await Future.delayed(const Duration(seconds: 2));
    confettiController.stop();

    // 4. Success checkmark
    await showDialog(context: context, builder: (context) => AlertDialog(
      content: LottieAnimationWidget(animationPath: 'assets/animations/Check Mark.json', repeat: false, animate: true,),
    ));
  }

  // Rejection Animation Sequence
  static Future<void> playRejectionAnimation(BuildContext context) async {
    // 1. Shake animation for emphasis (simulated)
    // print('Simulating shake animation');
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Color transition to red (simulated)
    await animateColorTransition(
      from: statusPendingReview,
      to: statusRejected,
      duration: const Duration(milliseconds: 400),
    );

    // 3. X mark animation
    await showDialog(context: context, builder: (context) => AlertDialog(
      content: LottieAnimationWidget(animationPath: 'assets/animations/x.json', repeat: false, animate: true,),
    ));
  }
}
