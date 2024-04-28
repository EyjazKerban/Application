import 'package:flutter/material.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:flutter_app/features/student/home/screens/studenthome.dart';

class StudentMessage extends StatefulWidget {
  const StudentMessage({Key? key}) : super(key: key);

  @override
  State<StudentMessage> createState() => _StudentMessageState();
}

class _StudentMessageState extends State<StudentMessage> {
  @override
  Widget build(BuildContext context) {
  int currentIndex = 1; // Add this line to track the current index

    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
      ),
      body: Center(
        child: Text("This is the message page"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // Use currentIndex here
        onTap: (int index) {
          setState(() {
            currentIndex = index; // Update currentIndex on tab tap
          });
          switch (index) {
            case 0:
              // Navigate to Home
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const StudentHome()));
              break;
            case 1:
              // Navigate to Inbox
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentMessage()));
              break;
            case 2:
              // Navigate to Profile
              Navigator.pushReplacement(
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
        selectedLabelStyle: TextStyle(fontSize: 14), // Increase label font size
        unselectedLabelStyle:
            TextStyle(fontSize: 14), // Increase label font size
        selectedItemColor: Color.fromARGB(255, 42, 166, 254),
      ),
    );
  }
}
