class RecentMessage {
  final String id;
  final String classroomId;
  final String senderId;
  final String receiverId;
  final IndividualMessage mostRecentMessage;
  final String senderFullName; // Add this line

  RecentMessage({
    required this.id,
    required this.classroomId,
    required this.senderId,
    required this.receiverId,
    required this.mostRecentMessage,
    required this.senderFullName, // Add this line
  });

  factory RecentMessage.fromJson(Map<String, dynamic> json) {
    return RecentMessage(
      id: json['_id'],
      classroomId: json['classroomId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      mostRecentMessage: IndividualMessage.fromJson(json['mostRecentMessage']),
      senderFullName: json['senderFullName'], // Add this line
    );
  }
}

// models/individual_message.dart
class IndividualMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;

  IndividualMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory IndividualMessage.fromJson(Map<String, dynamic> json) {
    return IndividualMessage(
      id: json['_id'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
