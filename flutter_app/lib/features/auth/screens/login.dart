import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/auth/screens/signup.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
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
                            const SizedBox(
                                height: 100), // Space from title to fields
                            const Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 21, 74, 133),
                              ),
                            ),
                            const SizedBox(
                                height: 80), // Space from title to fields
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74,
                                      133), // Placeholder text color
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
                              cursorColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Add this inside your Column where you have your TextFormFields
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74,
                                      133), // Placeholder text color
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
                                    signInUser();
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
                                    color: Colors.black, // Default text color
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: "Don't have an account? "),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 21, 74,
                                              133)), // "Sign Up" text color
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupScreen()),
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
