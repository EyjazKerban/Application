import 'package:flutter/material.dart';
import 'package:flutter_app/features/chatroom/screens/messagebubble.dart';
import 'package:flutter_app/features/chatroom/services/chatroom_service.dart';
import 'package:flutter_app/features/chatroom/services/socket_service.dart';
import 'package:flutter_app/features/student/home/screens/studenthome.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/models/chatroom.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ChatRoomService chatRoomService = ChatRoomService();
  SocketService? socketService;
  ChatRoom? chatRoom;
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChatRoomAndSocket();
  }

  void _initializeChatRoomAndSocket() async {
    try {
      final room = await chatRoomService.getOrCreateChatRoom(
          Provider.of<ClassroomProvider>(context, listen: false)
              .currentClassroom!
              .id);
      if (!mounted) return; // Check if the widget is still in the widget tree
      setState(() {
        chatRoom = room;
        socketService = SocketService();
      });
      socketService!.connect(chatRoom!.chatRoomId);
      socketService!.listenForNewMessage((data) {
        if (!mounted) return; // Check again before updating the state
        var message = Message.fromJson(data);
        setState(() {
          chatRoom!.messages.add(message);
          _scrollToBottom(
              animated: true); // Now it scrolls after updating the list
        });
      });
    } catch (e) {
      print("Error initializing chat room or socket: $e");
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animated: false);
      });
    }
  }

  Map<String, List<Message>> _groupMessagesByDate(List<Message> messages) {
    Map<String, List<Message>> grouped = {};

    for (var message in messages) {
      // Change date format to "Monday 25 January"
      String date = DateFormat('EEEE d MMMM').format(message.timestamp);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(message);
    }

    return grouped;
  }

  void _sendMessage() {
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (_messageController.text.isNotEmpty &&
        chatRoom != null &&
        socketService != null) {
      socketService!.sendMessage(
        chatRoom!.chatRoomId,
        userId,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  void _scrollToBottom({animated}) {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    }
  }

  @override
  void dispose() {
    socketService?.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<ClassroomProvider>(context, listen: false)
              .currentClassroom!
              .name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 42, 166, 254),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Check user role and navigate accordingly
            final userRole =
                Provider.of<UserProvider>(context, listen: false).user.role;
            if (userRole == 'Tutor') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TutorHome()),
                (Route<dynamic> route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const StudentHome()),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 166, 254),
              Color.fromARGB(255, 147, 223, 255),
              Color.fromARGB(255, 201, 236, 255),
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: _buildMessageList(chatRoom!.messages),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Send a message...',
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 42, 166, 254),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMessageList(List<Message> messages) {
    var groupedMessages = _groupMessagesByDate(messages);
    List<Widget> messageWidgets = [];

    groupedMessages.forEach((date, messages) {
      // Add date header with styled background and centered, but only as wide as its contents
      messageWidgets.add(
        Align(
          alignment: Alignment.center, // Center the container
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 107, 145, 164),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      messageWidgets.addAll(messages
          .map((message) => _buildMessageBubble(
              message,
              message.userID ==
                  Provider.of<UserProvider>(context, listen: false).user.id))
          .toList());
    });

    return ListView(
      controller: _scrollController,
      children: messageWidgets,
    );
  }

  Widget _buildMessageBubble(Message message, bool isSentByMe) {
    String time = DateFormat('HH:mm').format(message.timestamp);

    return MessageBubble(
      message: message.content,
      isSentByMe: isSentByMe,
      fullName: !isSentByMe ? message.username : '',
      time: time,
    );
  }
}
