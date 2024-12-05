import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool hasText;
  final Function(String) onSend;
  final VoidCallback onToggleRecording;

  const MessageInput({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onSend,
    required this.onToggleRecording,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
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
                setState(() {}); // Rebuild the widget to update the icon
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.onSend(value);
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
                widget.controller.text.isNotEmpty
                    ? Icons.send
                    : _isListening
                        ? Icons.stop
                        : Icons.mic,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  // If there's text, send it
                  widget.onSend(widget.controller.text);
                  widget.controller.clear();
                  setState(() {}); // Ensure UI updates
                } else {
                  // Toggle recording (start/stop)
                  _toggleRecording();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRecording() async {
    if (_isListening) {
      // Stop listening
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    } else {
      // Start listening
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            widget.controller.text = val.recognizedWords;
          });
        });
      }
    }
  }
}
