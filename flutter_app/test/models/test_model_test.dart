import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/test.dart';

void main() {
  group('Test Model', () {
    test('fromMap', () {
      var json = {
        '_id': '1',
        'name': 'Test 1',
        'classroomID': 'classroom1',
        'date': '2021-05-20T14:20:00Z',
        'total': 100,
        'testResults': [
          {
            'userID': 'user1',
            'grade': 'A',
            'feedback': 'Excellent work'
          },
        ],
      };

      var test = Test.fromMap(json);
      expect(test.id, '1');
      expect(test.name, 'Test 1');
      expect(test.total, 100);
      expect(test.testResults.first.grade, 'A');
    });
  });
}
