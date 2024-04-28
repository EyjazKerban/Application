// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomework.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/models/homework.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/constants/utils.dart';
import 'package:provider/provider.dart';

const String baseUrl = AppConfig.baseUrl;

class HomeworkService {
  static Future<void> createHomework({
    required BuildContext context,
    required String name,
    required DateTime date,
  }) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/createHomework'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'classroomID': classroomID,
        'date': date.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      showSnackBar(context, 'Homework successfully created!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TutorHomework()),
        (Route<dynamic> route) => false,
      );
    } else {
      throw Exception('Failed to create homework');
    }
  }

  static Future<List<Homework>> fetchHomeworks(BuildContext context) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    final response =
        await http.get(Uri.parse('$baseUrl/api/homeworks/$classroomID'));

    if (response.statusCode == 200) {
      List<dynamic> homeworkJson = json.decode(response.body);
      List<Homework> homeworks =
          homeworkJson.map((json) => Homework.fromMap(json)).toList();
      return homeworks;
    } else {
      throw Exception('Failed to load homework');
    }
  }

  static Future<bool> submitHomework({
    required BuildContext context,
    required String homeworkId,
    required String userId,
    required List<File> files,
  }) async {
    var uri = Uri.parse('$baseUrl/submitHomework');
    var request = http.MultipartRequest('POST', uri);

    request.fields['homeworkId'] = homeworkId;
    request.fields['userId'] = userId;

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        return true; // Return true if the submission is successful
      } else {
        return false; // Return false to indicate failure
      }
    } catch (e) {
      throw Exception('Failed to submit homework: $e');
    }
  }

  static Future<List<User>> fetchSubmittedStudents(
      BuildContext context, String homeworkId) async {
    final url = Uri.parse('$baseUrl/api/submittedStudents/$homeworkId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load submitted students');
    }
  }

  static Future<List<User>> fetchNotSubmittedStudents(
      BuildContext context, String homeworkId) async {
    final url = Uri.parse('$baseUrl/api/notSubmittedStudents/$homeworkId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load not submitted students');
    }
  }

  static Future<HomeworkSubmission?> fetchHomeworkSubmission(
      BuildContext context, String homeworkId, String userId) async {
    final url =
        Uri.parse('$baseUrl/api/homework/$homeworkId/submission/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return HomeworkSubmission.fromMap(data);
    } else {
      // Handle error or return null
      return null;
    }
  }

  static Future<bool> submitHomeworkFeedback(BuildContext context,
      String homeworkId, String userId, String feedback) async {
    final url = Uri.parse(
        '$baseUrl/api/homework/$homeworkId/submission/$userId/feedback');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'feedback': feedback}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
