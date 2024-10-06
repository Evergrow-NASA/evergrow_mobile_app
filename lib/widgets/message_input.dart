import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final bool isVoiceRecording;
  final Function(String) onSend;
  final VoidCallback onToggleRecording;

  const MessageInput({
    super.key,
    required this.controller,
    required this.hasText,
    required this.isVoiceRecording,
    required this.onSend,
    required this.onToggleRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: AppTheme.primaryColor),
                filled: true,
                fillColor: const Color.fromARGB(255, 225, 226, 227),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Esto puede manejarse externamente, si lo necesitas.
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSend(value);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                hasText ? Icons.send : isVoiceRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (hasText) {
                  if (controller.text.isNotEmpty) {
                    onSend(controller.text);
                    controller.clear();
                  }
                } else {
                  onToggleRecording();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
