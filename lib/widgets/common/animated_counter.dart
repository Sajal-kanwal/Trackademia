import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final num value; // Accepts both int and double
  final TextStyle? textStyle;
  final Duration duration;
  final Curve curve;
  final String? suffix;
  final int decimalPlaces;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.textStyle,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.suffix,
    this.decimalPlaces = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, child) {
        final formattedValue = animatedValue.toStringAsFixed(decimalPlaces);
        return Text(
          "$formattedValue${suffix ?? ''}",
          style: textStyle ?? Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}
