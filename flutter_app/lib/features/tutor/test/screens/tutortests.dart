import 'package:flutter/material.dart';
import 'package:flutter_app/features/message/screens/newmessage.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/features/tutor/test/screens/createtest.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortestview.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/models/test.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TutorTests extends StatefulWidget {
  const TutorTests({Key? key}) : super(key: key);

  @override
  State<TutorTests> createState() => _TutorTestsState();
}

class _TutorTestsState extends State<TutorTests> {
  int currentIndex = 0;
  late Future<List<Test>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = TestService.fetchTests(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tests',
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
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorHome()),
            (Route<dynamic> route) => false,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // Navigate to the CreateTest page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateTest()),
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
        child: Column(
          children: [
            FutureBuilder<List<Test>>(
              future: _testsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final tests = snapshot.data!;
                  if (tests.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          '                        No test found!\nClick on the add button to create a new test',
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
                        itemCount: tests.length,
                        itemBuilder: (context, index) {
                          final Test test = tests[index];
                          // Format the date
                          final String formattedDate = DateFormat('dd-MM-yyyy')
                              .format(test
                                  .date); // Adjust the date format as needed

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
                                  Provider.of<TestProvider>(context,
                                          listen: false)
                                      .setCurrentTest(test);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TutorTestView()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      16.0), // Add padding for better UI
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align text to the start
                                    children: [
                                      Text(
                                        test.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ), // Spacing between name and date
                                      Text(
                                        "Date: $formattedDate",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[
                                              600], // Make the date text slightly lighter
                                        ),
                                      ),
                                    ],
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
                  MaterialPageRoute(builder: (context) => const TutorHome()));
              break;
            case 1:
              // Navigate to Inbox
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewMessagePage()));
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
