import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String _baseUrl = 'https://chatbot-evergrow.onrender.com/chatbot';

  Future<String> sendChatbotRequest({
    required String userId,
    required String question,
    required String name,
    required String locationChoice,
    required String city,
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'question': question,
          'name': name,
          'location_choice': locationChoice,
          'city': city,
          'lat': lat,
          'lon': lon,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['reply'] ?? 'Error: Empty response from server';
      } else {
        return 'Error: Unable to get response (Status code: ${response.statusCode})';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
