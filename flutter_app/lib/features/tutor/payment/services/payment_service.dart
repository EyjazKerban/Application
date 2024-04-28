import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const String baseUrl = AppConfig.baseUrl;

class PaymentService {
  static Future<List<Payment>> fetchPayments(BuildContext context) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    final response =
        await http.get(Uri.parse('$baseUrl/api/payments/$classroomID'));

    if (response.statusCode == 200) {
      List<dynamic> paymentsJson = json.decode(response.body);
      List<Payment> payments =
          paymentsJson.map((json) => Payment.fromMap(json)).toList();
      return payments;
    } else {
      throw Exception('Failed to load payments');
    }
  }

  static Future<bool> submitPaymentProof({
    required BuildContext context,
    required String paymentId,
    required String userId,
    required File proofFile,
  }) async {
    var uri = Uri.parse('$baseUrl/submitPaymentProof');
    var request = http.MultipartRequest('POST', uri)
      ..fields['paymentId'] = paymentId
      ..fields['userId'] = userId
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        proofFile.path,
      ));

    try {
      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Payment>> fetchUnverifiedPayments(
      BuildContext context) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    final response = await http
        .get(Uri.parse('$baseUrl/api/paymentsUnverified/$classroomID'));

    if (response.statusCode == 200) {
      List<dynamic> paymentsJson = json.decode(response.body);
      return paymentsJson.map((json) => Payment.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load unverified payments');
    }
  }

  static Future<List<User>> fetchUnverifiedPaymentUsers(
      BuildContext context, String paymentId) async {
    final url = Uri.parse('$baseUrl/api/unverifiedPayments/$paymentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load unverified payment users');
    }
  }

  static Future<List<User>> fetchPaidStudents(BuildContext context, String paymentId) async {
    final url = Uri.parse('$baseUrl/api/paidStudents/$paymentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load paid students');
    }
  }

  static Future<List<User>> fetchNotPaidStudents(BuildContext context, String paymentId) async {
    final url = Uri.parse('$baseUrl/api/notPaidStudents/$paymentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      List<User> users = usersJson.map((data) => User.fromMap(data)).toList();
      return users;
    } else {
      throw Exception('Failed to load unpaid students');
    }
  }

  static Future<PaymentSubmission?> fetchPaymentSubmission(
      BuildContext context, String paymentId, String userId) async {
    final url = Uri.parse('$baseUrl/api/payment/$paymentId/submission/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return PaymentSubmission.fromMap(
          data); // Ensure you have a fromMap constructor
    } else {
      // Handle error or return null
      return null;
    }
  }

  static Future<bool> verifyPaymentSubmission(
      BuildContext context, String paymentId, String userId) async {
    final url =
        Uri.parse('$baseUrl/api/payment/$paymentId/submission/$userId/verify');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      // Handle error
      return false;
    }
  }

  // Add more service methods as needed, e.g., to submit payment proof
}
