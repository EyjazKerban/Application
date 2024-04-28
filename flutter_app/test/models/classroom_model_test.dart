import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/classroom.dart';

void main() {
  group('Classroom Model Tests', () {
    test('fromMap', () {
      var json = {
        '_id': '1',
        'name': 'Physics 101',
        'subject': 'Physics',
        'code': 'PH101',
        'tutorID': 'tutor123',
        'students': [{'_id': 'student1'}, {'_id': 'student2'}]
      };

      var classroom = Classroom.fromMap(json);
      expect(classroom.id, '1');
      expect(classroom.name, 'Physics 101');
      expect(classroom.students.length, 2);
      expect(classroom.students.first, 'student1');
    });
  });
}
