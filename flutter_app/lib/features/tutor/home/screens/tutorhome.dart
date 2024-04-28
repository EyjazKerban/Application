import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/chatroom/screens/chatroom.dart';
import 'package:flutter_app/features/message/screens/inbox.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:flutter_app/features/tutor/dashboard/screens/dashboardpage.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomework.dart';
import 'package:flutter_app/features/tutor/payment/screens/paymentoptions.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresources.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/classroom_provider.dart';

class TutorHome extends StatefulWidget {
  const TutorHome({super.key});

  @override
  State<TutorHome> createState() => _TutorHomeState();
}

class _TutorHomeState extends State<TutorHome> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final classroomName =
        Provider.of<ClassroomProvider>(context).currentClassroom?.name;

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
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(16),
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
                        builder: (context) => const TutorResources()));
              }),
              _buildCard(
                  'Homework', Icons.home_work_outlined, 'Manage homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorHomework()));
              }),
              _buildCard('Tests', Icons.assignment_outlined, 'Mark tests', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorTests()));
              }),
              _buildCard('Dashboard', Icons.insert_chart_outlined_outlined,
                  'Student marks dashboard', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              }),
              _buildCard('Payments', Icons.payment_outlined, 'Manage payments',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentOptionsPage()));
              }),
              _buildCard('Chat', Icons.chat_outlined, 'Chat room', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatRoomPage()));
              }),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InboxPage()));
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
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
          onTap: onTap,
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
