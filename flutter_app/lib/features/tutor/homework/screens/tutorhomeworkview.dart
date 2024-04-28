import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorcheckhomework.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomework.dart';
import 'package:flutter_app/features/tutor/homework/services/homework_service.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:provider/provider.dart';

class TutorHomeworkView extends StatefulWidget {
  const TutorHomeworkView({Key? key}) : super(key: key);

  @override
  _TutorHomeworkViewState createState() => _TutorHomeworkViewState();
}

class _TutorHomeworkViewState extends State<TutorHomeworkView> {
  late Future<List<User>> _submittedFuture;
  late Future<List<User>> _notSubmittedFuture;

  @override
  void initState() {
    super.initState();
    String homeworkId = Provider.of<HomeworkProvider>(context, listen: false)
        .currentHomework!
        .id;
    _submittedFuture =
        HomeworkService.fetchSubmittedStudents(context, homeworkId);
    _notSubmittedFuture =
        HomeworkService.fetchNotSubmittedStudents(context, homeworkId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Submissions',
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const TutorHomework()),
                    (Route<dynamic> route) => false,
                  )
                }),
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
        child: ListView(
          children: [
            FutureBuilderSection(
              future: _submittedFuture,
              title: 'Submitted',
            ),
            FutureBuilderSection(
              future: _notSubmittedFuture,
              title: 'Not Submitted',
            ),
          ],
        ),
      ),
    );
  }
}

class FutureBuilderSection extends StatelessWidget {
  final Future<List<User>> future;
  final String title;

  const FutureBuilderSection({
    Key? key,
    required this.future,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return Container();
        } else {
          return _buildUserSection(context, title, snapshot.data!);
        }
      },
    );
  }

  Widget _buildUserSection(
      BuildContext context, String title, List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            VoidCallback? onTapCallback;
            if (title != "Not Submitted") {
              // Define conditions based on your requirement
              onTapCallback = () {
                Provider.of<SelectedUserProvider>(context, listen: false)
                    .setSelectedUser(user);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const TutorCheckHomeworkPage()),
                );
              };
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 201, 236, 255)],
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onTapCallback,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text(
                      '${user.firstname} ${user.lastname}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
