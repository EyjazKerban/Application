import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/features/message/screens/newmessage.dart';
import 'package:flutter_app/features/message/screens/privatemessage.dart';
import 'package:flutter_app/features/message/services/message_service.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:flutter_app/features/student/home/screens/studenthome.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/models/inbox.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  int currentIndex = 1;
  late Future<List<RecentMessage>> futureMessages;

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    String classroomId = Provider.of<ClassroomProvider>(context, listen: false)
        .currentClassroom!
        .id;
    futureMessages = MessageService()
        .fetchRecentMessages(userId, classroomId)
        .then((messages) => messages
          ..sort((a, b) => b.mostRecentMessage.timestamp
              .compareTo(a.mostRecentMessage.timestamp)));
  }

  Future<User> _fetchOtherUser(String otherUserId) async {
    return AuthService.fetchUserById(otherUserId);
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // If the message is from today, show the time
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == yesterday) {
      // If the message is from yesterday, show "Yesterday"
      return 'Yesterday';
    } else {
      // Otherwise, show the date in dd/MM/yy format
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inbox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (userProvider.user.role == 'Tutor') {
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
          child: FutureBuilder<List<RecentMessage>>(
            future: futureMessages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(child: Text('No recent messages'));
                } else {
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      bool isCurrentUserSender =
                          message.mostRecentMessage.senderId ==
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .id;
                      String otherUserId =
                          Provider.of<UserProvider>(context, listen: false)
                                      .user
                                      .id ==
                                  message.senderId
                              ? message.receiverId
                              : message.senderId;

                      return FutureBuilder<User>(
                        future: _fetchOtherUser(otherUserId),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              title: LinearProgressIndicator(),
                            );
                          } else if (userSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${userSnapshot.error}'),
                            );
                          } else if (userSnapshot.hasData) {
                            final otherUser = userSnapshot.data!;
                            String formattedDate = _formatDate(
                                message.mostRecentMessage.timestamp);
                            String messagePreview =
                                isCurrentUserSender ? "You: " : "";

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 201, 236, 255),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${otherUser.firstname} ${otherUser.lastname}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  "$messagePreview${message.mostRecentMessage.content}",
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Provider.of<SelectedUserProvider>(context,
                                          listen: false)
                                      .setSelectedUser(otherUser);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivateMessagePage()),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const ListTile(
                              title: Text('User not found'),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              } else {
                return const Center(child: Text('Loading...'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewMessagePage()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 42, 166, 254),
          child: const Icon(Icons.message, color: Colors.white),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
                if (userProvider.user.role == 'Tutor') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TutorHome()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentHome()),
                    (Route<dynamic> route) => false,
                  );
                }
                break;
              case 1:
                break;
              case 2:
                // Navigate to Profile
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                  (Route<dynamic> route) => false,
                );
                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline, size: 30),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 30),
              label: 'Profile',
            ),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          selectedItemColor: const Color.fromARGB(255, 42, 166, 254),
        ),
      ),
    );
  }
}
