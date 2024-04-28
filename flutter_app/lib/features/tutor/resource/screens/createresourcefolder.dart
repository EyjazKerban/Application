import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/resource/services/resource_service.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresources.dart';
import 'package:intl/intl.dart';

class CreateResourceFolder extends StatefulWidget {
  const CreateResourceFolder({Key? key}) : super(key: key);

  @override
  State<CreateResourceFolder> createState() => _CreateResourceFolderState();
}

class _CreateResourceFolderState extends State<CreateResourceFolder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat =
      DateFormat('dd-MM-yyyy'); // For displaying the date in UI
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate =
            DateTime(picked.year, picked.month, picked.day, 12); // Set to noon
        dateController.text = dateFormat.format(selectedDate);
      });
    }
  }

  void createResourceFolder() {
    if (_formKey.currentState!.validate()) {
      ResourceService.createResourceFolder(
        context: context,
        name: nameController.text,
        date: selectedDate,
      );
    }
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
              onPressed: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const TutorResources()),
                      (Route<dynamic> route) => false,
                    ),
                  }),
        ),
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
                            const SizedBox(height: 120),
                            const Text(
                              'Create Resource Folder',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 21, 74, 133),
                              ),
                            ),
                            const SizedBox(height: 60),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Folder Name',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the folder name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 60),
                            TextFormField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 21, 74, 133))),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select the test date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 60),
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
                                onPressed: createResourceFolder,
                                child: const Text(
                                  'Create Folder',
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
