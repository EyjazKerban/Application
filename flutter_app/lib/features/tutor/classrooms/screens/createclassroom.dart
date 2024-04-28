import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/tutorclassrooms.dart';
import 'package:flutter_app/features/tutor/classrooms/services/classroom_service.dart';

class CreateClassroom extends StatefulWidget {
  const CreateClassroom({super.key});

  @override
  State<CreateClassroom> createState() => _CreateClassroomState();
}

class _CreateClassroomState extends State<CreateClassroom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClassroomService classroomService = ClassroomService();
  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    subjectController.dispose();
    codeController.dispose();
  }

  void createClassroom() {
    classroomService.createClassroom(
      context: context,
      name: nameController.text,
      subject: subjectController.text,
      code: codeController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TutorClassrooms()),
              (Route<dynamic> route) => false,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 42, 166, 254), // Start color
                Color.fromARGB(255, 147, 223, 255), // Middle color
                Color.fromARGB(255, 201, 236, 255), // End color
              ],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey, // Attach the form key
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Stretch the column
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 80),
                            const Text(
                              'Create Classroom',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 21, 74, 133),
                              ),
                            ),
                            const SizedBox(
                                height: 60), // Space from title to fields
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Class Name',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74,
                                      133), // Placeholder text color
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter the class name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: subjectController,
                              decoration: InputDecoration(
                                labelText: 'Subject',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74,
                                      133), // Placeholder text color
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter the subject name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: codeController,
                              decoration: InputDecoration(
                                labelText: 'Class Code',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74,
                                      133), // Placeholder text color
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter the unique class code';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                                height: 60), // Space from fields to button
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 75.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 201, 236, 255),
                                  backgroundColor: const Color.fromARGB(
                                      255, 21, 74, 133), // text color
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    createClassroom();
                                  }
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
