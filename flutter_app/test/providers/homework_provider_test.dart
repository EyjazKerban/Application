import 'package:flutter_app/models/homework.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeworkProvider Test', () {
    final provider = HomeworkProvider();
    expect(provider.currentHomework, isNull); // Initial state

    var homework = Homework(
      id: '1',
      name: 'Math Homework',
      classroomID: 'class123',
      submissions: [],
      date: DateTime.now()
    );

    provider.setCurrentHomework(homework);
    expect(provider.currentHomework, isNotNull);
    expect(provider.currentHomework!.id, '1');
    expect(provider.currentHomework!.name, 'Math Homework');

    provider.clearCurrentHomework();
    expect(provider.currentHomework, isNull); // Verify clear functionality
  });
}
