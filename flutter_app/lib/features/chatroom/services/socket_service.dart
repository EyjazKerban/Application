import 'package:flutter_app/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  final String serverUrl = AppConfig.baseUrl;

  void connect(String chatRoomId) {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      socket.emit('joinRoom', {'chatRoomId': chatRoomId});
    });
  }

  void connectToMessageSession(String messageId) {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      socket.emit('joinMessageSession', {'messageId': messageId});
    });
  }

  void sendMessage(String chatRoomId, String userId, String content) {
    socket.emit('sendMessage', {
      'chatRoomId': chatRoomId,
      'userId': userId,
      'content': content,
    });
  }

  void listenForNewMessage(void Function(dynamic) handler) {
    socket.on('newMessage', handler);
  }

  void sendPrivateMessage(String messageId, String senderId, String content) {
    socket.emit('sendPrivateMessage', {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
    });
  }

  void listenForPrivateMessage(Function(dynamic) callback) {
    socket.on('privateMessage', callback);
  }

  void disconnect() {
    socket.disconnect();
  }
}
