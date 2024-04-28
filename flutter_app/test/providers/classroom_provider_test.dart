import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/classroom.dart';
import 'package:flutter_app/providers/classroom_provider.dart';

void main() {
  test('ClassroomProvider Test', () {
    ClassroomProvider provider = ClassroomProvider();
    expect(provider.currentClassroom, isNull);

    var classroom = Classroom(
      id: '1', name: 'Physics 101', subject: 'Physics', code: 'PH101', tutorID: 'tutor123', students: []
    );

    provider.setCurrentClassroom(classroom);
    expect(provider.currentClassroom, isNotNull);
    expect(provider.currentClassroom!.id, '1');

    provider.clearCurrentClassroom();
    expect(provider.currentClassroom, isNull);
  });
}
