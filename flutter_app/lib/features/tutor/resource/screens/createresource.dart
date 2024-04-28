import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresources.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresourceview.dart';
import 'package:flutter_app/features/tutor/resource/services/resource_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/resource_provider.dart';
import 'package:flutter/services.dart';

class CreateResourcePage extends StatefulWidget {
  const CreateResourcePage({Key? key}) : super(key: key);

  @override
  _CreateResourcePageState createState() => _CreateResourcePageState();
}

class _CreateResourcePageState extends State<CreateResourcePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _pickedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  void _clearSelectedFile() {
    setState(() {
      _pickedFile = null;
    });
  }

  Future<void> _addResource() async {
    if (_formKey.currentState!.validate() && _pickedFile != null) {
      setState(() {
        _isUploading = true; // Start uploading
      });

      final folderId = Provider.of<ResourceProvider>(context, listen: false)
          .currentResourceFolder!
          .id;

      try {
        await ResourceService.addResource(
            context, folderId, _nameController.text, _pickedFile!);

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TutorResources()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload resource. Error: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false; // Stop uploading
          });
        }
      }
    }
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
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const TutorResourceView()),
                (Route<dynamic> route) => false,
              ),
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save, color: Colors.black),
              onPressed: _addResource,
            ),
          ],
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 120),
                          const Text(
                            'Add New Resource',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 21, 74, 133),
                            ),
                          ),
                          const SizedBox(height: 60),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Resource Name',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the resource name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: TextEditingController(
                                text: _pickedFile != null
                                    ? _pickedFile!.path.split('/').last
                                    : 'Choose file to upload'),
                            readOnly: true,
                            decoration: InputDecoration(
                              // Set the label text and style
                              labelText: 'File',
                              labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 21, 74, 133)),
                              // Set the text style for the input
                              suffixIcon: _pickedFile != null
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color:
                                              Color.fromARGB(255, 21, 74, 133)),
                                      onPressed:
                                          _clearSelectedFile, // Clear the file selection
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.attach_file,
                                          color:
                                              Color.fromARGB(255, 21, 74, 133)),
                                      onPressed: _pickFile, // Pick a file
                                    ),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 21, 74, 133)),
                              ),
                            ),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 21, 74,
                                    133)), // Text color for the input text
                          ),
                          const SizedBox(height: 20),
                          if (_isUploading) ...[
                            const Text('Uploading resource...',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 21, 74, 133))),
                            const LinearProgressIndicator(
                                color: Color.fromARGB(255, 21, 74, 133)),
                            const SizedBox(height: 20),
                          ],
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 201, 236, 255),
                              backgroundColor:
                                  const Color.fromARGB(255, 21, 74, 133),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                            ),
                            onPressed: _addResource,
                            child: const Text('Add Resource',
                                style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(height: 60),
                        ],
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
