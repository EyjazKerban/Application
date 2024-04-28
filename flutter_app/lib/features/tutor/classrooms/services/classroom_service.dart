// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/constants/error_handling.dart';
import 'package:flutter_app/constants/utils.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_app/features/student/classrooms/screens/studentclassrooms.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/tutorclassrooms.dart';
import 'package:flutter_app/models/classroom.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = AppConfig.baseUrl;

class ClassroomService {
  //sign up user
  void createClassroom(
      {required BuildContext context,
      required String name,
      required String subject,
      required String code}) async {
    try {
      Classroom classroom = Classroom(
          id: '',
          name: name,
          subject: subject,
          code: code,
          tutorID: Provider.of<UserProvider>(context, listen: false).user.id,
          students: []);
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/createClassroom'),
        body: classroom.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Classroom successfully created!');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorClassrooms()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void joinClassroom({
    required BuildContext context,
    required String code,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/joinClassroom'),
        body: jsonEncode({
          'code': code,
          'studentID': Provider.of<UserProvider>(context, listen: false).user.id
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'Successfully joined classroom!');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentClassrooms()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<List<dynamic>> getTutorClassrooms(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final tutorId = userProvider.user.id;
    final url = Uri.parse('$baseUrl/api/tutorClassrooms/$tutorId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> classrooms = json.decode(response.body);
      return classrooms; // Assuming the response body is a list of classrooms
    } else {
      throw Exception('Failed to load classrooms');
    }
  }

  static Future<List<dynamic>> getStudentClassrooms(
      BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final studentId = userProvider.user.id;
    final url = Uri.parse('$baseUrl/api/studentClassrooms/$studentId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> classrooms = json.decode(response.body);
      return classrooms; // Assuming the response body is a list of classrooms
    } else {
      throw Exception('Failed to load classrooms');
    }
  }

  static Future<List<User>> fetchUsersExceptCurrentUser(
      BuildContext context, String classroomId, String userID) async {
    final url = Uri.parse('$baseUrl/api/classroomStudents/$classroomId');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'userID': userID}), // Only userID is needed now
    );

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<bool> removeStudentFromClassroom(
      String classroomId, String studentId) async {
    try {
      print(classroomId);
      final url = Uri.parse('$baseUrl/removeStudentFromClassroom');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // Add any necessary headers here, such as Authorization header
        },
        body: jsonEncode({
          "classroomId": classroomId,
          "studentId": studentId,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Successfully removed student from classroom
      } else {
        print("Failed to remove student from classroom: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error removing student from classroom: $e");
      return false;
    }
  }
}
