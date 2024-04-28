// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomeworkview.dart';
import 'package:flutter_app/features/tutor/homework/services/homework_service.dart';
import 'package:flutter_app/models/homework.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_app/providers/selected_user_provider.dart';
import 'package:provider/provider.dart';

class TutorCheckHomeworkPage extends StatefulWidget {
  const TutorCheckHomeworkPage({Key? key}) : super(key: key);

  @override
  _TutorCheckHomeworkPageState createState() => _TutorCheckHomeworkPageState();
}

class _TutorCheckHomeworkPageState extends State<TutorCheckHomeworkPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _currentImageIndex = 0;
  List<ImageProvider> _preloadedImages = [];
  static const double imageWidth = 330.0;
  static const double imageHeight = 550.0;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback(String homeworkId, String userId) async {
    bool isFeedbackSubmitted = await HomeworkService.submitHomeworkFeedback(
      context,
      homeworkId,
      userId,
      _feedbackController.text,
    );

    if (isFeedbackSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit feedback'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeworkId = Provider.of<HomeworkProvider>(context, listen: false)
        .currentHomework!
        .id;
    final selectedUser =
        Provider.of<SelectedUserProvider>(context, listen: false).selectedUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${selectedUser.firstname} ${selectedUser.lastname}",
          style: const TextStyle(
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const TutorHomeworkView()),
              (Route<dynamic> route) => false,
            );
          },
        ),
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
        child: FutureBuilder<HomeworkSubmission?>(
          future: HomeworkService.fetchHomeworkSubmission(
              context, homeworkId, selectedUser.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error or no data');
            }
            final submission = snapshot.data!;
            _preloadedImages = submission.images
                .map((imageUrl) => NetworkImage(imageUrl))
                .toList();
            if (submission.feedback.isNotEmpty) {
              _feedbackController.text = submission.feedback;
            }
            return Column(
              children: [
                const SizedBox(height: 70.0),
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: _preloadedImages.isNotEmpty
                            ? SizedBox(
                                width: imageWidth,
                                height: imageHeight,
                                child: Image(
                                  image: _preloadedImages[_currentImageIndex],
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the box
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Failed to load image'),
                                ),
                              )
                            : const Text('No image available'),
                      ),
                      if (_preloadedImages.length > 1) ...[
                        Positioned(
                          left: 6,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            onPressed: _currentImageIndex > 0
                                ? () => setState(() => _currentImageIndex--)
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            color: Colors.white,
                            onPressed:
                                _currentImageIndex < _preloadedImages.length - 1
                                    ? () => setState(() => _currentImageIndex++)
                                    : null,
                          ),
                        ),
                      ],
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Text(
                            '${_currentImageIndex + 1}/${_preloadedImages.length}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _feedbackController,
                        decoration: const InputDecoration(
                          labelText: 'Feedback',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 21, 74, 133)),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 21, 74, 133)),
                          ),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 201, 236, 255),
                          backgroundColor:
                              const Color.fromARGB(255, 21, 74, 133),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        onPressed: () =>
                            _submitFeedback(homeworkId, selectedUser.id),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
