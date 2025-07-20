
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/Error animation.json', // Assuming this is a suitable error animation
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
