import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/config.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresources.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresourceview.dart';
import 'package:flutter_app/models/resource.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/classroom_provider.dart'; // Your ClassroomProvider
import 'package:flutter_app/constants/utils.dart'; // For showSnackBar or similar utilities

const String baseUrl = AppConfig.baseUrl;

class ResourceService {
  static Future<void> createResourceFolder({
    required BuildContext context,
    required String name,
    required DateTime date,
  }) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/createResourceFolder'), // Adjust according to your actual endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'classroomID': classroomID,
          'date':
              date.toIso8601String(), // Format DateTime as an ISO 8601 string
        }),
      );

      if (response.statusCode == 201) {
        // Assuming 201 is the success status code for creation
        showSnackBar(context, 'Resource folder successfully created!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TutorResources()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception('Failed to create resource folder');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<ResourceFolder>> fetchResourceFolders(
      BuildContext context) async {
    final classroomID = Provider.of<ClassroomProvider>(context, listen: false)
            .currentClassroom
            ?.id ??
        '';
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/resourceFolders/$classroomID'), // Adjust according to your actual endpoint
      );

      if (response.statusCode == 200) {
        final List<dynamic> foldersJson = json.decode(response.body);
        final List<ResourceFolder> folders =
            foldersJson.map((json) => ResourceFolder.fromMap(json)).toList();
        return folders;
      } else {
        throw Exception('Failed to load resource folders');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  // Add this method in ResourceService class
  static Future<ResourceFolder> fetchResourceFolderById(
      BuildContext context, String folderId) async {
    final url = Uri.parse('$baseUrl/api/resourceFolder/$folderId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ResourceFolder.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load resource folder');
    }
  }

  static Future<void> addResource(BuildContext context, String folderId,
      String resourceName, File file) async {
    // Extract the file extension from the original file path
    String fileExtension = file.path.split('.').last;

    // Check if resourceName already has an extension, if not, append the extracted extension
    if (!resourceName.endsWith('.$fileExtension')) {
      resourceName += '.$fileExtension';
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/api/addResource/$folderId');
    var request = http.MultipartRequest('POST', uri);
    request.fields['resourceName'] = resourceName;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        showSnackBar(context, 'Resource added successfully!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TutorResourceView()),
          (Route<dynamic> route) => false,
        );
      } else {
        showSnackBar(context, 'Failed to add resource');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Add more methods as needed, for example, fetching a single resource folder, updating or deleting a resource, etc.
}
