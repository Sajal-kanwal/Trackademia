
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/cat Mark loading.json', // Assuming this is a suitable loading animation
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}
