import 'package:flutter_app/models/homework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Homework fromMap', () {
    var json = {
      '_id': '1',
      'name': 'Math Homework',
      'classroomID': 'class123',
      'submissions': [
        {
          'userID': 'user123',
          'images': ['image1.jpg', 'image2.jpg'],
          'checked': true,
          'feedback': 'Well done!'
        }
      ],
      'date': '2020-01-01T12:00:00Z'
    };

    var homework = Homework.fromMap(json);
    expect(homework.id, '1');
    expect(homework.name, 'Math Homework');
    expect(homework.submissions.length, 1);
    expect(homework.submissions.first.feedback, 'Well done!');
    expect(homework.date, DateTime.parse('2020-01-01T12:00:00Z'));
  });
}
