import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/widgets/chat_bubble.dart';
import 'package:evergrow_mobile_app/widgets/quick_options.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:evergrow_mobile_app/services/chatbot_service.dart';
import 'package:evergrow_mobile_app/widgets/message_input.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isVoiceRecording = false;
  bool _hasText = false; // Initially set to 'false'

  final ChatbotService _chatbotService = ChatbotService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Listen to text controller changes to update _hasText
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });

    // Simulating a conversation with hardcoded data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addMessageToList("Hello, how can I assist you today?");
    });

    Future.delayed(const Duration(seconds: 2), () {
      _addMessageToList("What is the current condition of my field?");
    });

    Future.delayed(const Duration(seconds: 4), () {
      _addMessageToList("Currently, the soil moisture level is 25%. I recommend monitoring it to decide when to irrigate.");
    });

    Future.delayed(const Duration(seconds: 6), () {
      _addMessageToList("Thank you, what's the weather forecast for the next few days?");
    });

    Future.delayed(const Duration(seconds: 8), () {
      _addMessageToList("Light rains are expected over the next three days with an average of 5mm of daily precipitation.");
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const TopSection(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Center(
              child: Text(
                'Chatbot',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildMessageList(),
                if (_isLoading)
                  Center(
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
          MessageInput(
            controller: _controller,
            hasText: _hasText,
            onSend: _sendMessage,
            onToggleRecording: _toggleVoiceRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return QuickOptions(onOptionSelected: _sendMessage);
        } else {
          final messageData = _messages[index - 1];
          return ChatBubble(
            message: messageData['message']!,
            time: messageData['time']!,
            isUser: (index - 1) % 2 == 0,
          );
        }
      },
    );
  }

  Future<void> _sendMessage(String message) async {
    if (!mounted) return;

    _addMessageToList(message);

    const String userId = '12345';
    const String name = 'John Doe';
    const String locationChoice = 'current';
    const String city = 'New York';
    const double lat = 40.7128;
    const double lon = -74.0060;

    final response = await _chatbotService.sendChatbotRequest(
      userId: userId,
      question: message,
      name: name,
      locationChoice: locationChoice,
      city: city,
      lat: lat,
      lon: lon,
    );

    if (mounted) {
      _addMessageToList(response);
    }

    _controller.clear();
  }

  void _addMessageToList(String message) {
    setState(() {
      _messages.add({
        'message': message,
        'time': _formatCurrentTime(),
      });
      _scrollToBottom();
      _isLoading = false;
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isVoiceRecording = !_isVoiceRecording;
    });
  }
}
