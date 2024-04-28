import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortestview.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/constants/error_handling.dart';
import 'package:flutter_app/constants/utils.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/test.dart';

const String baseUrl = AppConfig.baseUrl;

class TestService {
  static Future<void> createTest({
    required BuildContext context,
    required String name,
    required int total,
    required DateTime date,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
            '$baseUrl/api/createTest'), // Adjust the endpoint as necessary
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'total': total,
          'date':
              date.toIso8601String(), // Format DateTime as an ISO 8601 string
          'classroomID': Provider.of<ClassroomProvider>(context, listen: false)
              .currentClassroom
              ?.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Test successfully created!');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorTests()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<void> updateTest({
    required BuildContext context,
    required String testId,
    required String name,
    required int total,
    required DateTime date,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/updateTest/$testId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'total': total,
          'date': date.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TutorTests()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Handle failure
        throw Exception('Failed to update test');
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  static Future<List<Test>> fetchTests(BuildContext context) async {
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
    final classroomId = classroomProvider.currentClassroom?.id;
    final url = Uri.parse('$baseUrl/api/tests/$classroomId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> testsJson = json.decode(response.body);
      List<Test> tests = testsJson.map((data) => Test.fromJson(data)).toList();
      return tests;
    } else {
      throw Exception('Failed to load tests');
    }
  }

  static Future<List<User>> fetchGradedStudents(
      BuildContext context, String testId) async {
    final url = Uri.parse('$baseUrl/api/gradedStudents/$testId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load graded students');
    }
  }

  static Future<List<User>> fetchUngradedStudents(
      BuildContext context, String testId) async {
    final url = Uri.parse('$baseUrl/api/ungradedStudents/$testId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load ungraded students');
    }
  }

  // Function to grade a student
  static Future<void> gradeStudent({
    required BuildContext context,
    required String testID,
    required String studentID,
    required String grade,
    required String feedback,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/gradeStudent'),
        body: jsonEncode({
          'testID': testID,
          'studentID': studentID,
          'grade': grade,
          'feedback': feedback,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Student graded successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorTestView()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<Map<String, dynamic>> fetchStudentGrade(
      BuildContext context, String testId, String studentId) async {
    final url = Uri.parse('$baseUrl/api/testResult');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // Include any other necessary headers, like authorization tokens
      },
      body: jsonEncode({
        'testID': testId,
        'studentID': studentId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load student grade');
    }
  }

  // Add more functions as needed for fetching graded/ungraded students, etc.
}
