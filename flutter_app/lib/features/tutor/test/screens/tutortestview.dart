import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/test/screens/edittest.dart';
import 'package:flutter_app/features/tutor/test/screens/gradetest.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:flutter_app/features/tutor/test/screens/tutorviewgrade.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:provider/provider.dart';

class TutorTestView extends StatefulWidget {
  const TutorTestView({Key? key}) : super(key: key);

  @override
  _TutorTestViewState createState() => _TutorTestViewState();
}

class _TutorTestViewState extends State<TutorTestView> {
  late Future<List<User>> _gradedFuture;
  late Future<List<User>> _ungradedFuture;

  @override
  void initState() {
    super.initState();
    final currentTest =
        Provider.of<TestProvider>(context, listen: false).currentTest;
    if (currentTest != null) {
      _gradedFuture = TestService.fetchGradedStudents(context, currentTest.id);
      _ungradedFuture =
          TestService.fetchUngradedStudents(context, currentTest.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            Provider.of<TestProvider>(context, listen: false)
                    .currentTest
                    ?.name ??
                "Test",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorTests()),
            (Route<dynamic> route) => false,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        const EditTest()), // Assuming EditTestPage is your EditTest page's class
              );
            },
          ),
        ],
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
          children: [
            FutureBuilder<List<User>>(
              future: _gradedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return _buildUserSection('Graded', snapshot.data!, true);
                } else {
                  return SizedBox.shrink(); // No graded students, omit section
                }
              },
            ),
            FutureBuilder<List<User>>(
              future: _ungradedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return _buildUserSection('Ungraded', snapshot.data!, false);
                } else {
                  return SizedBox
                      .shrink(); // No ungraded students, omit section
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(String title, List<User> users, bool isGraded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Provider.of<SelectedUserProvider>(context, listen: false)
                        .setSelectedUser(user);
                    if (isGraded) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TutorViewGrade()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GradeTest()),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text(
                      '${user.firstname} ${user.lastname}',
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
      ],
    );
  }
}
