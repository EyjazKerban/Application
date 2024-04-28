import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/resource/screens/createresourcefolder.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresourceview.dart';
import 'package:flutter_app/features/tutor/resource/services/resource_service.dart';
import 'package:flutter_app/models/resource.dart';
import 'package:flutter_app/features/tutor/home/screens/tutorhome.dart';
import 'package:flutter_app/providers/resource_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TutorResources extends StatefulWidget {
  const TutorResources({Key? key}) : super(key: key);

  @override
  _TutorResourcesState createState() => _TutorResourcesState();
}

class _TutorResourcesState extends State<TutorResources> {
  late Future<List<ResourceFolder>> _resourceFoldersFuture;
  final resourceService=ResourceService();

  @override
  void initState() {
    super.initState();
    _resourceFoldersFuture = resourceService.fetchResourceFolders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resources',
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
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorHome()),
            (Route<dynamic> route) => false,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateResourceFolder()));
            },
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
        child: FutureBuilder<List<ResourceFolder>>(
          future: _resourceFoldersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final folders = snapshot.data!;
              if (folders.isEmpty) {
                return const Center(
                  child: Text(
                    '                No resource folders found!\nClick on the add button to create a new folder',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    final String formattedDate = DateFormat('dd-MM-yyyy')
                        .format(
                            folder.date); // Adjust the date format as needed
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Provider.of<ResourceProvider>(context,
                                    listen: false)
                                .setCurrentResourceFolder(folder);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const TutorResourceView()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to the start
                              children: [
                                Text(
                                  folder.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Date: $formattedDate",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[
                                        600], // Make the date text slightly lighter
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
      ),
    );
  }
}
