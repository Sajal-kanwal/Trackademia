import 'package:flutter/material.dart';

class AnimatedSlideIn extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(0, 50), end: Offset.zero),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, offset, childToAnimate) {
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: 1.0 - (offset.dy / 50).clamp(0.0, 1.0),
            child: childToAnimate,
          ),
        );
      },
      child: child,
    );
  }
}