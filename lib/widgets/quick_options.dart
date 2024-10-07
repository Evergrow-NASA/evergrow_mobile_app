import 'package:flutter/material.dart';

class QuickOptions extends StatelessWidget {
  final Function(String) onOptionSelected;

  const QuickOptions({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ask about...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          _buildOptionButton('The weather', 'How’s the weather in Cajamarca?'),
          const SizedBox(height: 8),
          _buildOptionButton('Crop health', 'Should I spray pesticide on my crops today?'),
          const SizedBox(height: 8),
          _buildOptionButton('Risk management', 'What should I do in case of drought?'),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String title, String message) {
    return ElevatedButton(
      onPressed: () {
        onOptionSelected(message);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
