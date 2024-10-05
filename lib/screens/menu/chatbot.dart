import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:evergrow_mobile_app/services/chatbot_service.dart';
import 'package:flutter/material.dart';

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
  bool _needsScroll = false;

  final ChatbotService _chatbotService = ChatbotService();  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
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
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
        _needsScroll = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildChatbotScreen(),
    );
  }

  Widget _buildChatbotScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const TopSection(),
        _buildSectionTitle('Chatbot'),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: _messages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    _buildQuickOptions(),
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return _buildChatBubble(
                  message: _messages[index - 1]['message']!,
                  time: _messages[index - 1]['time']!,
                  isUser: (index - 1) % 2 == 0,
                );
              }
            },
          ),
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildQuickOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ask about...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        _buildOptionButton('The weather', 'How’s the weather?'),
        const SizedBox(height: 10),
        _buildOptionButton(
            'Crop health', 'Should I spray pesticide on my crops today?'),
        const SizedBox(height: 10),
        _buildOptionButton(
            'Risk management', 'What should I do in case of drought?'),
      ],
    );
  }

  Widget _buildOptionButton(String title, String message) {
    return ElevatedButton(
      onPressed: () {
        _sendMessage(message);
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

  Widget _buildChatBubble({
    required String message,
    required String time,
    required bool isUser,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : const Color(0xFFEFF2F5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isUser ? Colors.white60 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type here...',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: const Color(0xFFEFF2F5),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _sendMessage(value);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          _isVoiceRecording
              ? IconButton(
                  icon: const Icon(Icons.stop,
                      color: AppTheme.primaryColor, size: 28),
                  onPressed: () {
                    setState(() {
                      _isVoiceRecording = false;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.mic,
                      color: AppTheme.primaryColor, size: 28),
                  onPressed: () {
                    setState(() {
                      _isVoiceRecording = true;
                    });
                  },
                ),
          IconButton(
            icon:
                const Icon(Icons.send, color: AppTheme.primaryColor, size: 28),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _sendMessage(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    if (!mounted) return;

    setState(() {
      _messages.add({'message': message, 'time': '10:10 am'});
      _isLoading = true;
      _needsScroll = true;
    });

    final response = await _chatbotService.sendMessage(message);

    if (mounted) {
      setState(() {
        _messages.add({'message': response, 'time': '10:11 am'});
        _isLoading = false;
        _needsScroll = true;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

   Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }
}