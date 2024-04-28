// services/message_service.dart
import 'dart:convert';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/models/inbox.dart';
import 'package:flutter_app/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static final String baseUrl = AppConfig.baseUrl;

  static Future<MessageConversation> getOrCreateMessageConversation(
      String classroomId, String senderId, String receiverId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'classroomId': classroomId,
        'senderId': senderId,
        'receiverId': receiverId,
      }),
    );

    if (response.statusCode == 200) {
      return MessageConversation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message conversation');
    }
  }

  Future<List<RecentMessage>> fetchRecentMessages(
      String userId, String classroomId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/messages/recent/$userId?classroomId=$classroomId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RecentMessage.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
