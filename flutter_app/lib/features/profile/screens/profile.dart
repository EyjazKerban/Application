import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/features/message/screens/inbox.dart';
import 'package:flutter_app/features/profile/screens/changepassword.dart';
import 'package:flutter_app/features/profile/screens/edituserinfo.dart';
import 'package:flutter_app/features/student/classrooms/screens/studentclassrooms.dart';
import 'package:flutter_app/features/student/home/screens/studenthome.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/tutorclassrooms.dart';
import 'package:flutter_app/features/tutor/classrooms/services/classroom_service.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 2;

  Future<void> _leaveClassroomAndLogout() async {
    final classroomId = Provider.of<ClassroomProvider>(context, listen: false)
        .currentClassroom!
        .id;
    final studentId = Provider.of<UserProvider>(context, listen: false).user.id;

    final classroomService = ClassroomService();
    final wasRemoved = await classroomService.removeStudentFromClassroom(
        classroomId, studentId);

    if (wasRemoved) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Successfully left ${Provider.of<ClassroomProvider>(context, listen: false).currentClassroom!.name}")));
      AuthService().logOutUser(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Could not leave ${Provider.of<ClassroomProvider>(context, listen: false).currentClassroom!.name}")));
    }
  }

  Future<void> _confirmAction(
      String actionTitle, String actionContent, VoidCallback onConfirm) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionTitle),
          content: Text(actionContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String fullName =
        '${userProvider.user.firstname} ${userProvider.user.lastname}';
    final isTutor = userProvider.user.role.toLowerCase() == 'tutor';

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              final userRole = userProvider.user.role;
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
          child: ListView(
            padding: const EdgeInsets.only(top: 125),
            children: [
              Center(
                child: Text(
                  '$fullName\'s Profile',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 21, 74, 133),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildOptionContainer(
                'Edit User Info',
                Icons.edit,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditUserInfoPage()),
                ),
              ),
              _buildOptionContainer(
                'Change Password',
                Icons.lock_outline,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                ),
              ),
              _buildOptionContainer(
                'Exit Classroom',
                Icons.directions_walk,
                () => _confirmAction(
                  'Exit Classroom',
                  'Are you sure you want to exit ${Provider.of<ClassroomProvider>(context, listen: false).currentClassroom!.name}?',
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => isTutor
                          ? const TutorClassrooms()
                          : const StudentClassrooms())),
                ),
              ),
              if (!isTutor)
                _buildOptionContainer(
                  'Leave Classroom',
                  Icons.exit_to_app,
                  () => _confirmAction(
                    'Leave Classroom',
                    'Are you sure you want to permanently leave ${Provider.of<ClassroomProvider>(context, listen: false).currentClassroom!.name}?',
                    _leaveClassroomAndLogout,
                  ),
                ),
              _buildOptionContainer(
                'Log Out',
                Icons.logout,
                () => _confirmAction(
                  'Log Out',
                  'Are you sure you want to log out?',
                  () => AuthService().logOutUser(context),
                ),
              ),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const InboxPage()),
                  (Route<dynamic> route) => false,
                );
                break;
              case 2:
                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.mail_outline, size: 30), label: 'Inbox'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30), label: 'Profile'),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          selectedItemColor: const Color.fromARGB(255, 42, 166, 254),
        ),
      ),
    );
  }

  Widget _buildOptionContainer(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            trailing: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
