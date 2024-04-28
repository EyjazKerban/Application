import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortestview.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:provider/provider.dart';

class TutorViewGrade extends StatefulWidget {
  const TutorViewGrade({Key? key}) : super(key: key);

  @override
  _TutorViewGradeState createState() => _TutorViewGradeState();
}

class _TutorViewGradeState extends State<TutorViewGrade> {
  late Future<Map<String, dynamic>> _studentGradeFuture;
  bool _isEditable = false;
  final _gradeController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final selectedUserId =
        Provider.of<SelectedUserProvider>(context, listen: false)
            .selectedUser
            .id;
    final testId =
        Provider.of<TestProvider>(context, listen: false).currentTest?.id ?? '';
    _studentGradeFuture =
        TestService.fetchStudentGrade(context, testId, selectedUserId);

    // Initialize controllers with fetched data
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

  void _toggleEditMode() {
    setState(() {
      _isEditable = !_isEditable;
    });
  }

  void _confirmChanges() {
    if (_isEditable) {
      final testId =
          Provider.of<TestProvider>(context, listen: false).currentTest?.id ??
              '';
      final studentId =
          Provider.of<SelectedUserProvider>(context, listen: false)
              .selectedUser
              .id;

      TestService.gradeStudent(
        context: context,
        testID: testId,
        studentID: studentId,
        grade: _gradeController.text,
        feedback: _feedbackController.text,
      );

      // Optionally reset the edit mode
      _toggleEditMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Grade',
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorTestView()),
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
                    // Grade title
                    Text(
                      "${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.firstname} ${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.lastname}'s Grade",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 21, 74, 133),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    // Grade field
                    TextFormField(
                      controller: _gradeController,
                      readOnly: !_isEditable,
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
                    // Feedback field
                    TextFormField(
                      controller: _feedbackController,
                      readOnly: !_isEditable,
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
                    const SizedBox(height: 40),
                    // Toggle edit/confirm changes button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 201, 236, 255),
                        backgroundColor: const Color.fromARGB(255, 21, 74, 133),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      onPressed:
                          _isEditable ? _confirmChanges : _toggleEditMode,
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // To keep the row width to a minimum
                        children: [
                          Text(
                            _isEditable ? 'Confirm Changes' : 'Edit Grade',
                            style: const TextStyle(fontSize: 20),
                          ),
                          // Adding a small space between the text and the icon
                          const SizedBox(width: 8),
                          // Changing icon based on the _isEditable state
                          Icon(_isEditable ? Icons.check : Icons.edit,
                              size: 20),
                        ],
                      ),
                    )
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
