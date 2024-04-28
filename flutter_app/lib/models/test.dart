import 'dart:convert';

class Test {
  final String id;
  final String name;
  final String classroomID;
  final DateTime date;
  final int total;
  final List<TestResult> testResults;

  Test({
    required this.id,
    required this.name,
    required this.classroomID,
    required this.date,
    required this.total,
    required this.testResults,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroomID': classroomID,
      'date': date.toIso8601String(),
      'total': total, // Add total to map
      'testResults': testResults.map((result) => result.toMap()).toList(),
    };
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      classroomID: map['classroomID'] ?? '',
      date: DateTime.parse(map['date']),
      total: map['total'] ?? 0, // Default to 0 if total is not available
      testResults: List<TestResult>.from(map['testResults']?.map((result) => TestResult.fromMap(result)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Test.fromJson(Map<String, dynamic> json) => Test.fromMap(json);
}

class TestResult {
  final String userID;
  final String grade;
  final String feedback;

  TestResult({
    required this.userID,
    required this.grade,
    required this.feedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'grade': grade,
      'feedback': feedback,
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      userID: map['userID'] ?? '',
      grade: map['grade'] ?? '',
      feedback: map['feedback'] ?? '',
    );
  }
}
