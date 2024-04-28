// models/message.dart
class IndividualMessage {
  final String senderId;
  final String content;
  final DateTime timestamp;

  IndividualMessage({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory IndividualMessage.fromJson(Map<String, dynamic> json) {
    return IndividualMessage(
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class MessageConversation {
  final String id;
  final String classroomId;
  final String senderId;
  final String receiverId;
  final List<IndividualMessage> messages;

  MessageConversation({
    required this.id,
    required this.classroomId,
    required this.senderId,
    required this.receiverId,
    required this.messages,
  });

  factory MessageConversation.fromJson(Map<String, dynamic> json) {
    List<IndividualMessage> messages = (json['messages'] as List)
        .map((i) => IndividualMessage.fromJson(i))
        .toList();

    return MessageConversation(
      id: json['_id'],
      classroomId: json['classroomId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messages: messages,
    );
  }
}