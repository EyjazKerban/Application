import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/features/student/resource/screens/studentresources.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/resource_provider.dart';

class StudentResourceView extends StatefulWidget {
  const StudentResourceView({Key? key}) : super(key: key);

  @override
  _StudentResourceViewState createState() => _StudentResourceViewState();
}

class _StudentResourceViewState extends State<StudentResourceView> {
  static const platform = MethodChannel('com.example.flutter_app/downloads');

  Future<void> downloadFile(String url, String fileName) async {
    final shouldDownload = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Download Resource'),
            content: Text('Do you want to download $fileName?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDownload) return;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Downloading'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Download in progress...'),
              SizedBox(height: 20),
              LinearProgressIndicator(),
            ],
          ),
        );
      },
    );

    try {
      await platform.invokeMethod('downloadFile', {
        'url': url,
        'fileName': fileName,
      });
      Navigator.pop(context); // Close the download dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Complete'),
          content: Text('Downloaded $fileName successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on PlatformException catch (e) {
      Navigator.pop(context); // Close the download dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Failed'),
          content: Text("Failed to download $fileName: '${e.message}'."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourceFolder =
        Provider.of<ResourceProvider>(context).currentResourceFolder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          resourceFolder?.name ?? 'Resource Details',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 42, 166, 254),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const StudentResources()),
            (Route<dynamic> route) => false,
          ),
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
        child: resourceFolder!.resources.isEmpty
            ? const Center(child: Text("No resources found!"))
            : ListView.builder(
                itemCount: resourceFolder.resources.length,
                itemBuilder: (context, index) {
                  final resource = resourceFolder.resources[index];
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
                    child: InkWell(
                      onTap: () => downloadFile(
                          resource.resourceLink, resource.resourceName),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.resourceName,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
