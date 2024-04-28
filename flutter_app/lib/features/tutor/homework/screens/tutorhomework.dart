import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/homework/screens/createhomework.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomeworkview.dart';
import 'package:flutter_app/features/tutor/homework/services/homework_service.dart';
import 'package:flutter_app/models/homework.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';

class TutorHomework extends StatefulWidget {
  const TutorHomework({Key? key}) : super(key: key);

  @override
  _TutorHomeworkState createState() => _TutorHomeworkState();
}

class _TutorHomeworkState extends State<TutorHomework> {
  late Future<List<Homework>> _homeworkFuture;

  @override
  void initState() {
    super.initState();
    _homeworkFuture = HomeworkService.fetchHomeworks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homework',
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
          onPressed: () => {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TutorHome()),
              (Route<dynamic> route) => false,
            )
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateHomeworkPage()),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
        child: FutureBuilder<List<Homework>>(
          future: _homeworkFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final homeworkList = snapshot.data!;
              if (homeworkList.isEmpty) {
                return const Center(
                  child: Text(
                    'No homework found!\nClick on the add button to create new homework',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: homeworkList.length,
                itemBuilder: (context, index) {
                  final homework = homeworkList[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, 201, 236, 255),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        homework.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Due: ${DateFormat('dd-MM-yyyy').format(homework.date)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .grey[600], // Make the date text slightly lighter
                        ),
                      ),
                      onTap: () {
                        Provider.of<HomeworkProvider>(context, listen: false)
                            .setCurrentHomework(homework);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const TutorHomeworkView()),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
      ),
    );
  }
}
