import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortestview.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTest extends StatefulWidget {
  const EditTest({Key? key}) : super(key: key);

  @override
  State<EditTest> createState() => _EditTestState();
}

class _EditTestState extends State<EditTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _totalController;
  late TextEditingController _dateController;
  final DateFormat _displayDateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    final currentTest =
        Provider.of<TestProvider>(context, listen: false).currentTest;
    _nameController = TextEditingController(text: currentTest?.name);
    _totalController =
        TextEditingController(text: currentTest?.total.toString());
    _dateController = TextEditingController(
        text: _displayDateFormat.format(currentTest?.date ?? DateTime.now()));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          Provider.of<TestProvider>(context, listen: false).currentTest?.date ??
              DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      // Set the time to noon
      final DateTime noonTime =
          DateTime(picked.year, picked.month, picked.day, 12);
      setState(() {
        // Only display the date part in the UI
        _dateController.text = _displayDateFormat.format(noonTime);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Construct the date with noon time directly
      DateTime selectedDate = _displayDateFormat.parse(_dateController.text);
      DateTime dateWithNoon =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12);

      TestService.updateTest(
        context: context,
        testId:
            Provider.of<TestProvider>(context, listen: false).currentTest!.id,
        name: _nameController.text,
        total: int.parse(_totalController.text),
        date: dateWithNoon,
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
              MaterialPageRoute(builder: (context) => const TutorTestView()),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 80),
                            const Text(
                              'Edit Test',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 21, 74, 133),
                              ),
                            ),
                            const SizedBox(height: 60),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
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
                                  return 'Please enter the test name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _totalController,
                              decoration: const InputDecoration(
                                labelText: 'Total',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter total marks';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: 60),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 75.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 201, 236, 255),
                                  backgroundColor:
                                      const Color.fromARGB(255, 21, 74, 133),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                                onPressed: _saveChanges,
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
