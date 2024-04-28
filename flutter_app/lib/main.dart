import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_app/features/auth/screens/signup.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/tutorclassrooms.dart';
import 'package:flutter_app/features/student/classrooms/screens/studentclassrooms.dart';
import 'package:flutter_app/providers/classroom_provider.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_app/providers/payment_provider.dart';
import 'package:flutter_app/providers/resource_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:flutter_app/providers/test_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized
  await FlutterDownloader.initialize(
      debug: true 
      );
  // Register the download callback

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClassroomProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TestProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ResourceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeworkProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedUserProvider(),
        )
      ],
      child: const SmartTutorApp(),
    ),
  );
}

class SmartTutorApp extends StatefulWidget {
  const SmartTutorApp({super.key});

  @override
  State<SmartTutorApp> createState() => _SmartTutorAppState();
}

class _SmartTutorAppState extends State<SmartTutorApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartTutor',
      home: user.token.isNotEmpty
          ? user.role == 'Tutor'
              ? const TutorClassrooms() 
              : const StudentClassrooms()
          : const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 42, 166, 254), // Start color
              Color.fromARGB(255, 147, 223, 255), // Middle color
              Color.fromARGB(255, 201, 236, 255), // End color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 100,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width:
                    double.infinity, // Makes the button stretch to full width
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 75.0,
                      vertical: 20.0), // Adjust padding as needed
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 21, 74, 133), // Set background color here
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0), // Adjust padding as needed
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Color.fromARGB(255, 201, 236, 255),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width:
                    double.infinity, // Makes the button stretch to full width
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 75.0,
                      vertical: 20.0), // Adjust padding as needed
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 21, 74, 133), // Set background color here
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0), // Adjust padding as needed
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 201, 236, 255),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
