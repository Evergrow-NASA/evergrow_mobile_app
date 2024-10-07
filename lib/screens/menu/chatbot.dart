import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/components/bottom_navigation.dart';
import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/widgets/chat_bubble.dart';
import 'package:evergrow_mobile_app/widgets/quick_options.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:evergrow_mobile_app/services/chatbot_service.dart';
import 'package:evergrow_mobile_app/widgets/message_input.dart';

class ChatbotScreen extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const ChatbotScreen(
      {super.key,
      required this.location,
      required this.lat,
      required this.lng});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isVoiceRecording = false;
  bool _hasText = false;

  final ChatbotService _chatbotService = ChatbotService();

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatbotScreen(
                location: widget.location, lat: widget.lat, lng: widget.lng)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(widget.location, widget.lat, widget.lng),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Notifications(
                location: widget.location, lat: widget.lat, lng: widget.lng),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
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
          TopSection(
              location: widget.location,
              latitude: widget.lat,
              longitude: widget.lng),
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
          BottomNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
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

    final response = await _chatbotService.sendMessage(message);

    if (mounted) {
      _addMessageToList(response);
    }

    // Limpiar el campo de texto después de enviar
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
