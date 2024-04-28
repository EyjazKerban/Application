import 'dart:convert';

class Classroom {
  final String id;
  final String name;
  final String subject;
  final String code;
  final String tutorID;
  final List<String> students;

  Classroom(
      {required this.id,
      required this.name,
      required this.subject,
      required this.code,
      required this.tutorID,
      required this.students});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'code': code,
      'tutorID': tutorID,
      'students': students,
    };
  }

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      code: map['code'] ?? '',
      tutorID: map['tutorID'] ?? '',
      // Handle students as a list of maps, extracting the '_id' field from each
      students: map['students'] != null
          ? List<String>.from(map['students'].map((student) => student['_id']))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Classroom.fromJson(String source) =>
      Classroom.fromMap(json.decode(source));
}
