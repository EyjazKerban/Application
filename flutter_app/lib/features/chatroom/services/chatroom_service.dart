import 'dart:convert';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/models/chatroom.dart';
import 'package:http/http.dart'
    as http;

class ChatRoomService {
  final String baseUrl = AppConfig.baseUrl;

  Future<ChatRoom> getOrCreateChatRoom(String classroomId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chatroom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'classroomID': classroomId}),
    );

    if (response.statusCode == 200) {
      return ChatRoom.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chat room');
    }
  }
}
