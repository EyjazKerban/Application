import 'dart:convert';

class ResourceFolder {
  final String id;
  final String name;
  final String classroomID;
  final List<ResourceItem> resources;
  final DateTime date; // Added date field

  ResourceFolder({
    required this.id,
    required this.name,
    required this.classroomID,
    required this.resources,
    required this.date, // Initialize date
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroomID': classroomID,
      'resources': resources.map((x) => x.toMap()).toList(),
      'date': date.toIso8601String(), // Convert date to string
    };
  }

  factory ResourceFolder.fromMap(Map<String, dynamic> map) {
    return ResourceFolder(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      classroomID: map['classroomID'] ?? '',
      resources: List<ResourceItem>.from(map['resources']?.map((x) => ResourceItem.fromMap(x)) ?? []),
      date: DateTime.parse(map['date']), // Parse date string to DateTime
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceFolder.fromJson(String source) => ResourceFolder.fromMap(json.decode(source));
}

class ResourceItem {
  final String id;
  final String resourceName;
  final String resourceLink;

  ResourceItem({
    required this.id,
    required this.resourceName,
    required this.resourceLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resourceName': resourceName,
      'resourceLink': resourceLink,
    };
  }

  factory ResourceItem.fromMap(Map<String, dynamic> map) {
    return ResourceItem(
      id: map['_id'] ?? '',
      resourceName: map['resourceName'] ?? '',
      resourceLink: map['resourceLink'] ?? '',
    );
  }
}
