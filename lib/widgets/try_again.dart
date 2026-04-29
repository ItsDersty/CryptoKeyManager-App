import 'package:flutter/material.dart';

class TryAgain extends StatelessWidget {
  final String label;
  final VoidCallback onRetry;
  const TryAgain({super.key, required this.label, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_rounded, size: 64),
          const SizedBox(height: 16),
          Text(
            "Couldn't load",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(label),
          TextButton.icon(
            onPressed: onRetry,
            label: Text("Try again"),
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
    );
  }
}
