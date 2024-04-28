import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:provider/provider.dart';

class CreateTest extends StatefulWidget {
  const CreateTest({Key? key}) : super(key: key);

  @override
  State<CreateTest> createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat =
      DateFormat('dd-MM-yyyy'); // For displaying the date in UI
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    totalController.dispose();
    dateController.dispose();
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

  void createTest() {
    if (_formKey.currentState!.validate()) {
      TestService.createTest(
        context: context,
        name: nameController.text,
        total: int.parse(totalController.text),
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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TutorTests()),
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
                              'Create Test',
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
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 21, 74, 133))),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the test name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: totalController,
                              decoration: const InputDecoration(
                                labelText: 'Total',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 21, 74, 133))),
                              ),
                              keyboardType:
                                  TextInputType.number, // Ensure numeric input
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter total marks';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                                    createTest();
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Create Test',
  //         style: TextStyle(color: Color.fromARGB(255, 21, 74, 133)),
  //       ),
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 21, 74, 133)),
  //         onPressed: () => Navigator.of(context).pop(),
  //       ),
  //     ),
  //     body: Container(
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           colors: [
  //             Color.fromARGB(255, 42, 166, 254),
  //             Color.fromARGB(255, 147, 223, 255),
  //             Color.fromARGB(255, 201, 236, 255),
  //           ],
  //         ),
  //       ),
  //       child: SafeArea(
  //         child: Form(
  //           key: _formKey,
  //           child: SingleChildScrollView(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               children: <Widget>[
  //                 TextFormField(
  //                   controller: nameController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Test Name',
  //                     labelStyle: TextStyle(color: Color.fromARGB(255, 21, 74, 133)),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 21, 74, 133))),
  //                   ),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter the test name';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 20),
  //                 TextFormField(
  //                   controller: dateController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Test Date',
  //                     labelStyle: TextStyle(color: Color.fromARGB(255, 21, 74, 133)),
  //                     border: OutlineInputBorder(),
  //                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 21, 74, 133))),
  //                   ),
  //                   readOnly: true,
  //                   onTap: () => _selectDate(context),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please select the test date';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 40),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: const Color.fromARGB(255, 21, 74, 133),
  //                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //                   ),
  //                   onPressed: createTest,
  //                   child: const Text(
  //                     'Create Test',
  //                     style: TextStyle(color: Colors.white, fontSize: 16),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
