import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/features/profile/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/user_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String newPasswordFeedback = '';
  Color newPasswordFeedbackColor = Colors.red;

  void checkNewPasswordStrength(String password) {
    if (password.isEmpty) {
      newPasswordFeedback = '';
    } else if (password.length < 8) {
      newPasswordFeedback = 'Too short';
      newPasswordFeedbackColor = Colors.red;
    } else {
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
      bool hasSpecialCharacters = password.contains(RegExp(r'[^a-zA-Z0-9]'));

      if (hasLetters && hasDigits && hasSpecialCharacters) {
        newPasswordFeedback = 'Strong';
        newPasswordFeedbackColor = Colors.green;
      } else if (hasLetters && hasDigits) {
        newPasswordFeedback = 'Fair';
        newPasswordFeedbackColor = Colors.orange;
      } else {
        newPasswordFeedback = 'Weak';
        newPasswordFeedbackColor = Colors.red;
      }
    }
    setState(() {});
  }

  void _changePassword() async {
    setState(() {
      newPasswordFeedback = ''; // Reset feedback on submission
    });
    if (_formKey.currentState!.validate()) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.id;
      bool success = await AuthService().changePassword(
        context: context,
        userId: userId,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (success) {
        // Update the provider here if necessary, but typically password hashes are not stored in frontend state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'Change Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 21, 74, 133),
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildPasswordFormField(
                      "Current Password",
                      _currentPasswordController,
                      _isCurrentPasswordVisible,
                      () => setState(() => _isCurrentPasswordVisible =
                          !_isCurrentPasswordVisible)),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _newPasswordController,
                    onChanged: (value) => checkNewPasswordStrength(value),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 21, 74, 133),
                        fontSize: 16,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 21, 74, 133)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 21, 74, 133),
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isNewPasswordVisible,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your new password';
                      }
                      if (value.length < 8) {
                        return 'Password should be at least 8 characters';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value) ||
                          !RegExp(r'[a-zA-Z]').hasMatch(value)) {
                        return 'Password should contain letters and numbers';
                      }
                      return null;
                    },
                  ),
                  if (newPasswordFeedback.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        newPasswordFeedback,
                        style: TextStyle(color: newPasswordFeedbackColor),
                      ),
                    ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 21, 74, 133),
                        fontSize: 16,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 21, 74, 133)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 21, 74, 133),
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 201, 236, 255),
                        backgroundColor: const Color.fromARGB(255, 21, 74, 133),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50),
                      ),
                      onPressed: _changePassword,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 20),
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

  Widget buildPasswordFormField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility,
      {FormFieldValidator<String>? validate}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 21, 74, 133), fontSize: 16),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromARGB(255, 21, 74, 133)),
          onPressed: toggleVisibility,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 21, 74, 133))),
      ),
      obscureText: !isVisible,
      validator: validate,
      style: const TextStyle(fontSize: 18, color: Colors.black),
    );
  }
}
