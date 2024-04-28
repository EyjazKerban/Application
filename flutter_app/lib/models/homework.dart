import 'dart:convert';

class Homework {
  final String id;
  final String name;
  final String classroomID;
  final List<HomeworkSubmission> submissions;
  final DateTime date;

  Homework({
    required this.id,
    required this.name,
    required this.classroomID,
    required this.submissions,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroomID': classroomID,
      'submissions': submissions.map((x) => x.toMap()).toList(),
      'date': date.toIso8601String(),
    };
  }

  factory Homework.fromMap(Map<String, dynamic> map) {
    return Homework(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      classroomID: map['classroomID'] ?? '',
      submissions: List<HomeworkSubmission>.from(
          map['submissions']?.map((x) => HomeworkSubmission.fromMap(x)) ?? []),
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Homework.fromJson(String source) =>
      Homework.fromMap(json.decode(source));
}

class HomeworkSubmission {
  final String userID;
  final List<String> images; // Now expecting Base64 encoded strings
  final bool checked;
  final String feedback;

  HomeworkSubmission({
    required this.userID,
    required this.images,
    required this.checked,
    required this.feedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'images': images, // Already in the correct format for JSON encoding
      'checked': checked,
      'feedback': feedback,
    };
  }

  factory HomeworkSubmission.fromMap(Map<String, dynamic> map) {
    return HomeworkSubmission(
      userID: map['userID'] ?? '',
      // Directly assign the list of Base64 strings to `images`
      images: List<String>.from(map['images'] ?? []),
      checked: map['checked'] ?? false,
      feedback: map['feedback'] ?? '',
    );
  }
}
