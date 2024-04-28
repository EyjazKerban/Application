// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/constants/error_handling.dart';
import 'package:flutter_app/constants/utils.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_app/features/student/classrooms/screens/studentclassrooms.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/tutorclassrooms.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = AppConfig.baseUrl;

class AuthService {
  void signUpUser(
      {required BuildContext context,
      required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String role}) async {
    try {
      User user = User(
          id: '',
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
          role: role,
          token: '');

      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account successfully created! Login');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          // Determine the screen to navigate to based on the user's role
          Widget nextScreen = jsonDecode(res.body)['role'] == 'Tutor'
              ? const TutorClassrooms() 
              : const StudentClassrooms(); 

          // Navigate to the determined screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$baseUrl/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$baseUrl/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<User> fetchUserById(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> updateUserInfo({
    required BuildContext context,
    required String userId,
    required String firstname,
    required String lastname,
    required String email,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/editinfo/$userId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Include any authorization headers if needed
        },
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Parsing the JSON response
        final responseBody = jsonDecode(response.body);

        final updatedUserData = responseBody['user'];
        Map<String, dynamic> userMap = Map.from(updatedUserData);

        // Updating the UserProvider with the new user data
        Provider.of<UserProvider>(context, listen: false)
            .setUser(jsonEncode(userMap));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        return true; // Successful update
      } else {
        // Displaying error message from the server response
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseBody['msg'] ?? 'Failed to update profile')),
        );
        return false; // Indicating that update was not successful
      }
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required BuildContext context,
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/changePassword/$userId');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Include any necessary headers, such as authorization headers
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Password change successful
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseBody['msg'] ?? 'Failed to change password')),
        );
        return false; // Failed to change password
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      return false;
    }
  }

// Function to log out the user
  void logOutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all the data stored in SharedPreferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
