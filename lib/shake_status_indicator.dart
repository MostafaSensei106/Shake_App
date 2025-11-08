import 'package:flutter/material.dart';

class ShakeStatusIndicator extends StatelessWidget {
  final bool isListening;

  const ShakeStatusIndicator({
    Key? key,
    required this.isListening,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isListening ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isListening ? Icons.vibration : Icons.sensors_off,
            color: isListening ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isListening ? 'Shake Detection Active' : 'Detection Stopped',
            style: TextStyle(
              color: isListening ? Colors.green.shade900 : Colors.red.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
