import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? selectedRole = 'Student';
  String passwordFeedback = '';
  Color passwordFeedbackColor = Colors.red;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordFeedback = '';
    } else if (password.length < 8) {
      passwordFeedback = 'Too short';
      passwordFeedbackColor = Colors.red;
    } else {
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
      bool hasSpecialCharacters = password.contains(RegExp(r'[^a-zA-Z0-9]'));

      if (hasLetters && hasDigits && hasSpecialCharacters) {
        passwordFeedback = 'Strong';
        passwordFeedbackColor = Colors.green;
      } else if (hasLetters && hasDigits) {
        passwordFeedback = 'Fair';
        passwordFeedbackColor = Colors.orange;
      } else {
        passwordFeedback = 'Weak';
        passwordFeedbackColor = Colors.red;
      }
    }
    setState(() {});
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      firstname: firstNameController.text,
      lastname: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole!,
    );
    passwordFeedback = "";
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 21, 74, 133),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133),
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 21, 74, 133)),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              cursorColor: Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your First Name';
                                }
                                if (value.contains(' ')) {
                                  return 'First Name should not contain spaces';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133),
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
                              cursorColor: Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your Last Name';
                                }
                                if (value.contains(' ')) {
                                  return 'Last Name should not contain spaces';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133),
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
                              cursorColor: Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Email';
                                }
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regExp = RegExp(pattern);
                                if (!regExp.hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              onChanged: (value) =>
                                  checkPasswordStrength(value),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133),
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Password';
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
                            if (passwordFeedback.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  passwordFeedback,
                                  style:
                                      TextStyle(color: passwordFeedbackColor),
                                ),
                              ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133),
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
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
                              style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74, 133),
                                fontSize: 18,
                              ),
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm your password';
                                }
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Are you a tutor or student?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 21, 74, 133),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: const Color.fromARGB(
                                            255, 201, 236, 255),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                        ),
                                        value: selectedRole,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedRole = newValue;
                                          });
                                        },
                                        items: <String>['Student', 'Tutor']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 21, 74, 133),
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 40),
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
                                onPressed: () {
                                  setState(() {
                                    passwordFeedback =
                                        ''; // Reset feedback on submission
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    signUpUser();
                                  }
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Log In',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 21, 74, 133)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
