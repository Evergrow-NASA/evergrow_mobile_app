import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String _baseUrl = 'https://Evergrow.com/chatbot';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'] ?? 'Error: Empty response from server';
      } else {
        return 'Error: Unable to get response (Status code: ${response.statusCode})';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
