class Message {
  final String userID;
  final String username;
  final String content;
  final DateTime timestamp;

  Message({required this.userID, required this.username, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    // Ensure 'userId' and 'timestamp' are handled according to your backend structure
    return Message(
      userID: json['userID'] ?? '',
      username: json['username'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatRoom {
  final String chatRoomId;
  final String classroomId;
  final List<Message> messages;

  ChatRoom({required this.chatRoomId, required this.classroomId, required this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    List<Message> messageList = (json['messages'] as List).map((i) => Message.fromJson(i)).toList();

    return ChatRoom(
      chatRoomId: json['_id'], // Adjusted according to your JSON structure
      classroomId: json['classroomID'], // Key matches the JSON response
      messages: messageList,
    );
  }
}
