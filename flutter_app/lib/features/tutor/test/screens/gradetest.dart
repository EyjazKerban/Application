import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortestview.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:provider/provider.dart';

class GradeTest extends StatefulWidget {
  const GradeTest({Key? key}) : super(key: key);

  @override
  State<GradeTest> createState() => _GradeTestState();
}

class _GradeTestState extends State<GradeTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    gradeController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  void gradeStudent() {
    if (_formKey.currentState!.validate()) {
      final selectedUserId =
          Provider.of<SelectedUserProvider>(context, listen: false)
              .selectedUser
              .id;
      final testId =
          Provider.of<TestProvider>(context, listen: false).currentTest?.id;
      if (testId != null) {
        TestService.gradeStudent(
          context: context,
          testID: testId,
          studentID: selectedUserId,
          grade: gradeController.text,
          feedback: feedbackController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
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
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Stretch the column
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          // Spacing at the top
                          Text(
                            'Grade ${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.firstname} ${Provider.of<SelectedUserProvider>(context, listen: false).selectedUser.lastname}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 21, 74, 133),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                              height: 60), // Spacing between title and form
                          TextFormField(
                            controller: gradeController,
                            decoration: const InputDecoration(
                              labelText: 'Grade',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133))),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a grade';
                              } else {
                                final grade = int.tryParse(value);
                                if (grade == null) {
                                  return 'Please enter a valid number';
                                }
                                // Get the total marks from the test provider
                                final total = Provider.of<TestProvider>(context,
                                        listen: false)
                                    .currentTest
                                    ?.total;
                                if (grade > total!) {
                                  return 'Grade cannot exceed total marks of $total';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: feedbackController,
                            decoration: const InputDecoration(
                              labelText: 'Feedback',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133))),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter feedback';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                              height: 75), // Spacing between fields and button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 201, 236, 255),
                              backgroundColor: const Color.fromARGB(
                                  255, 21, 74, 133), // button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 15),
                            ),
                            onPressed: gradeStudent,
                            child: const Text(
                              'Submit Grade',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
