import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/student/test/screens/studenttests.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class StudentViewGrade extends StatefulWidget {
  const StudentViewGrade({Key? key}) : super(key: key);

  @override
  _StudentViewGradeState createState() => _StudentViewGradeState();
}

class _StudentViewGradeState extends State<StudentViewGrade> {
  late Future<Map<String, dynamic>> _studentGradeFuture;
  final _gradeController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    final testId =
        Provider.of<TestProvider>(context, listen: false).currentTest?.id ?? '';

    _studentGradeFuture = TestService.fetchStudentGrade(context, testId, userId)
        .catchError((error) {
      return {'grade': '', 'feedback': ''};
    });

    // Initialize controllers with fetched or default data
    _studentGradeFuture.then((data) {
      _gradeController.text = data['grade'] ?? '';
      _feedbackController.text = data['feedback'] ?? '';
    });
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<TestProvider>(context, listen: false).currentTest!.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const StudentTests()),
            (Route<dynamic> route) => false,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
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
            height: double.infinity,
            width: double.infinity,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      "Your Grade",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 21, 74, 133),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: _gradeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Grade',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 21, 74, 133)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 21, 74, 133)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _feedbackController,
                      readOnly: true,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Feedback',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 21, 74, 133)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 21, 74, 133)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
