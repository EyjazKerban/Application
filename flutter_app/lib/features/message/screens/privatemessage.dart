import 'package:flutter/material.dart';
import 'package:flutter_app/features/chatroom/screens/messagebubble.dart';
import 'package:flutter_app/features/chatroom/services/socket_service.dart';
import 'package:flutter_app/features/message/screens/inbox.dart';
import 'package:flutter_app/features/message/services/message_service.dart';
import 'package:flutter_app/models/message.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';

class PrivateMessagePage extends StatefulWidget {
  const PrivateMessagePage({Key? key}) : super(key: key);

  @override
  State<PrivateMessagePage> createState() => _PrivateMessagePageState();
}

class _PrivateMessagePageState extends State<PrivateMessagePage> {
  late final SocketService _socketService = SocketService();
  List<IndividualMessage> _messages = [];
  String? _messageSessionId;
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeMessageSession();
  }

  void _initializeMessageSession() async {
    final classroomId = Provider.of<ClassroomProvider>(context, listen: false)
        .currentClassroom!
        .id;
    final senderId = Provider.of<UserProvider>(context, listen: false).user.id;
    final receiverId = Provider.of<SelectedUserProvider>(context, listen: false)
        .selectedUser
        .id;

    final messageSession = await MessageService.getOrCreateMessageConversation(
        classroomId, senderId, receiverId);
    if (mounted) {
      setState(() {
        _messageSessionId = messageSession.id;
        _messages = messageSession.messages;
      });
    }

    _socketService.connectToMessageSession(messageSession.id);
    _socketService.listenForPrivateMessage((data) {
      if (mounted) {
        setState(() {
          _messages.add(IndividualMessage.fromJson(data));
          _scrollToBottom(
              animated: true); // Now it scrolls after updating the list
        });
      }
    });
    setState(() {
      isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false); // Pass false to jump without animation
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _messageSessionId != null) {
      _socketService.sendPrivateMessage(
          _messageSessionId!,
          Provider.of<UserProvider>(context, listen: false).user.id,
          _messageController.text);
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

  Map<String, List<IndividualMessage>> _groupMessagesByDate() {
    Map<String, List<IndividualMessage>> groupedMessages = {};
    for (var message in _messages) {
      String date = DateFormat('EEEE, MMMM d, yyyy').format(message.timestamp);
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }
    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMessages = _groupMessagesByDate();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.firstname} ${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.lastname}',
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InboxPage()),
                (Route<dynamic> route) => false,
              );
            }),
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
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: groupedMessages.keys.length,
                      itemBuilder: (context, index) {
                        String date = groupedMessages.keys.elementAt(index);
                        List<IndividualMessage> dateMessages =
                            groupedMessages[date]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment:
                                  Alignment.center, // Center the container
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 107, 145, 164),
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
                            Column(
                              children: dateMessages.map((message) {
                                final isSentByMe = message.senderId ==
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .id;
                                String fullName = isSentByMe
                                    ? ''
                                    : '${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.firstname} ${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.lastname}';
                                return MessageBubble(
                                  message: message.content,
                                  isSentByMe: isSentByMe,
                                  fullName: fullName,
                                  time: DateFormat('HH:mm')
                                      .format(message.timestamp),
                                );
                              }).toList(),
                            )
                          ],
                        );
                      },
                    ),
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

  @override
  void dispose() {
    _socketService.disconnect();
    _messageController.dispose();
    super.dispose();
  }
}
