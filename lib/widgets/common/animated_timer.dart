
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedTimer extends StatelessWidget {
  final Duration duration;
  final TextStyle? textStyle;

  const AnimatedTimer({super.key, required this.duration, this.textStyle});

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          _formatDuration(duration),
          textStyle: textStyle ?? Theme.of(context).textTheme.headlineMedium,
          speed: const Duration(milliseconds: 50),
        ),
      ],
      isRepeatingAnimation: false,
    );
  }
}
