import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/chatroom/screens/chatroom.dart';
import 'package:flutter_app/features/message/screens/inbox.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:flutter_app/features/student/homework/screens/studenthomework.dart';
import 'package:flutter_app/features/student/payment/screens/studentmonthlypayments.dart';
import 'package:flutter_app/features/student/resource/screens/studentresources.dart';
import 'package:flutter_app/features/student/test/screens/studenttests.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/classroom_provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int currentIndex = 0; // Add this line to track the current index
  @override
  Widget build(BuildContext context) {
    final classroomName = Provider.of<ClassroomProvider>(context)
        .currentClassroom
        ?.name; // Get current classroom name

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            classroomName!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ), // Use the classroom name here
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            // Apply gradient background
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
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: <Widget>[
              _buildCard('Resources', Icons.cases_outlined, 'Upload resources',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentResources()) // Make sure TutorTests is imported correctly
                    );
              }),
              _buildCard(
                  'Homework', Icons.home_work_outlined, 'Manage homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentHomework()) // Make sure TutorTests is imported correctly
                    );
              }),
              _buildCard('Tests', Icons.assignment_outlined, 'Mark tests', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentTests()) // Make sure TutorTests is imported correctly
                    );
              }),
              _buildCard('Payments', Icons.payment_outlined, 'Manage payments',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StudentMonthlyPaymentsPage()) // Make sure TutorTests is imported correctly
                    );
              }),
              _buildCard('Chat', Icons.chat_outlined, 'Chat room', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ChatRoomPage()) // Make sure TutorTests is imported correctly
                    );
              }),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex, // Use currentIndex here
          onTap: (int index) {
            setState(() {
              currentIndex = index; // Update currentIndex on tab tap
            });
            switch (index) {
              case 0:
                break;
              case 1:
                // Navigate to Inbox
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InboxPage()));
                break;
              case 2:
                // Navigate to Profile
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), // Increase icon size
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline, size: 30), // Increase icon size
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 30), // Increase icon size
              label: 'Profile',
            ),
          ],
          selectedLabelStyle:
              const TextStyle(fontSize: 14), // Increase label font size
          unselectedLabelStyle:
              const TextStyle(fontSize: 14), // Increase label font size
          selectedItemColor: const Color.fromARGB(255, 42, 166, 254),
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, String subtitle, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color.fromARGB(255, 201, 236, 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: InkWell(
          onTap: onTap, // Use the onTap parameter here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop(); // This will exit your app
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false; // if showDialog returns null (which means the barrier has been dismissed), return false
  }
}
