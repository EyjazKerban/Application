import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/createclassroom.dart';
import 'package:flutter_app/features/tutor/classrooms/services/classroom_service.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/models/classroom.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TutorClassrooms extends StatefulWidget {
  const TutorClassrooms({Key? key}) : super(key: key);

  @override
  State<TutorClassrooms> createState() => _TutorClassroomsState();
}

class _TutorClassroomsState extends State<TutorClassrooms> {
  ClassroomService classroomService = ClassroomService();
  late Future<List<dynamic>> _classroomsFuture;

  @override
  void initState() {
    super.initState();
    _classroomsFuture = ClassroomService.getTutorClassrooms(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String fullName = '${user.firstname} ${user.lastname}';

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Welcome $fullName',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Classrooms',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateClassroom())
                      );
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: _classroomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final classrooms = snapshot.data!;
                  if (classrooms.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          '                    No classrooms found!\nClick on the add button to create a classroom',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: classrooms.length,
                        itemBuilder: (context, index) {
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  var classroom =
                                      Classroom.fromMap(classrooms[index]);
                                  Provider.of<ClassroomProvider>(context,
                                          listen: false)
                                      .setCurrentClassroom(classroom);
                                  // Navigate to the determined screen
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TutorHome(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    classrooms[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return const Center(child: Text('No classrooms found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
