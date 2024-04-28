import 'package:flutter_app/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('User fromMap', () {
    var json = {
      '_id': '1',
      'firstname': 'John',
      'lastname': 'Doe',
      'email': 'john.doe@example.com',
      'password': 'password123',
      'role': 'student',
      'token': 'token123456'
    };

    var user = User.fromMap(json);
    expect(user.id, '1');
    expect(user.firstname, 'John');
    expect(user.lastname, 'Doe');
    expect(user.email, 'john.doe@example.com');
    expect(user.role, 'student');
    expect(user.token, 'token123456');
  });
}
