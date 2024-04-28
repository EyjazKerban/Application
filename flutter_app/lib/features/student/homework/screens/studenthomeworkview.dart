import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/features/student/homework/screens/studenthomework.dart';
import 'package:flutter_app/features/tutor/homework/services/homework_service.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';

class StudentHomeworkView extends StatefulWidget {
  const StudentHomeworkView({Key? key}) : super(key: key);

  @override
  _StudentHomeworkViewState createState() => _StudentHomeworkViewState();
}

class _StudentHomeworkViewState extends State<StudentHomeworkView> {
  List<File> files = [];
  bool _isLoading = true;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingSubmission();
  }

  Future<void> _checkExistingSubmission() async {
    final homeworkId = Provider.of<HomeworkProvider>(context, listen: false)
            .currentHomework
            ?.id ??
        '';
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    final submission = await HomeworkService.fetchHomeworkSubmission(
        context, homeworkId, userId);

    if (!mounted) return; // Check if the widget is still mounted

    if (submission != null) {
      await _downloadImages(submission.images);
      _feedbackController.text = submission.feedback.isNotEmpty
          ? submission.feedback
          : "Waiting for feedback";
    }

    if (!mounted) return; // Check again before calling setState

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _downloadImages(List<String> imageUrls) async {
    var dio = Dio();
    var tempDir = await getTemporaryDirectory();

    for (var imageUrl in imageUrls) {
      var uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}.jpg';
      var tempFile = File('${tempDir.path}/$uniqueFileName');

      try {
        await dio.download(imageUrl, tempFile.path);
        setState(() {
          files.add(tempFile);
        });
      } catch (e) {
        print("Error downloading image: $e");
      }
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      setState(() {
        files.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  void _openImage(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Image.file(file),
          ),
        );
      },
    );
  }

  Future<void> _submitHomework() async {
    if (files.isEmpty) {
      _showNoFileSelectedDialog();
      return;
    }

    final homeworkId = Provider.of<HomeworkProvider>(context, listen: false)
            .currentHomework
            ?.id ??
        '';
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    _showSubmissionDialog();

    try {
      bool success = await HomeworkService.submitHomework(
        context: context,
        homeworkId: homeworkId,
        userId: userId,
        files: files,
      );
      Navigator.of(context).pop(); // Dismiss the submission dialog
      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      Navigator.of(context)
          .pop(); // Make sure to pop the dialog even if an error occurs
      _showErrorDialog();
      print('Upload error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Submitting homework..."),
                SizedBox(height: 20),
                LinearProgressIndicator(),
                SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Homework Uploaded"),
          content: const Text("Homework uploaded successfully."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const StudentHomework()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Error"),
          content: const Text("Failed to submit homework. Please try again."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoFileSelectedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No File Selected"),
          content: const Text("Please select at least one file to submit."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeworkName =
        Provider.of<HomeworkProvider>(context).currentHomework?.name ??
            'Homework Submission';
    int charactersPerLine = MediaQuery.of(context).size.width ~/ 10;

    int numberOfLines = _feedbackController.text.isEmpty
        ? 0
        : max((_feedbackController.text.length / charactersPerLine).ceil(), 1);

    double bottomPadding = _feedbackController.text.isEmpty
        ? 10
        : max(80, 20 + (numberOfLines * 20));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          homeworkName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentHomework()),
            (Route<dynamic> route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitHomework,
          ),
        ],
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(8),
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
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : files.isEmpty
                      ? const Center(child: Text("Select files to upload!"))
                      : GridView.builder(
                          itemCount: files.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => _openImage(files[index]),
                              child: GridTile(
                                footer: GridTileBar(
                                  backgroundColor: Colors.black45,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        files.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                                child:
                                    Image.file(files[index], fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
            ),
            if (_feedbackController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _feedbackController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Feedback',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _pickFiles,
              backgroundColor: const Color.fromARGB(255, 42, 166, 254),
              heroTag: 'folder',
              child: const Icon(Icons.folder_open),
            ),
          ],
        ),
      ),
    );
  }
}
