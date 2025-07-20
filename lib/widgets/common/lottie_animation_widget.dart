
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String animationPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool repeat;
  final bool animate;
  final AnimationController? controller;

  const LottieAnimationWidget({
    super.key,
    required this.animationPath,
    this.width,
    this.height,
    this.fit,
    this.repeat = false,
    this.animate = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animationPath,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      animate: animate,
      controller: controller,
    );
  }
}
