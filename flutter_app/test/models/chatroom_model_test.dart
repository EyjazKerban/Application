import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/chatroom.dart';

void main() {
  group('ChatRoom and Message Models', () {
    test('Message fromJson', () {
      var json = {
        'userID': 'user1',
        'username': 'John Doe',
        'content': 'Hello, World!',
        'timestamp': '2020-01-01T12:00:00Z'
      };

      var message = Message.fromJson(json);
      expect(message.userID, 'user1');
      expect(message.username, 'John Doe');
      expect(message.content, 'Hello, World!');
      expect(message.timestamp, DateTime.parse('2020-01-01T12:00:00Z'));
    });

    test('ChatRoom fromJson', () {
      var json = {
        '_id': 'room1',
        'classroomID': 'class1',
        'messages': [
          {
            'userID': 'user1',
            'username': 'John Doe',
            'content': 'Hello, World!',
            'timestamp': '2020-01-01T12:00:00Z'
          }
        ]
      };

      var chatRoom = ChatRoom.fromJson(json);
      expect(chatRoom.chatRoomId, 'room1');
      expect(chatRoom.classroomId, 'class1');
      expect(chatRoom.messages.first.content, 'Hello, World!');
    });
  });
}
