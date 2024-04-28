import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserProvider Test', () {
    final provider = UserProvider();
    expect(provider.user, isNotNull); // Initial state

    var user = User(
      id: '1',
      firstname: 'John',
      lastname: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      role: 'student',
      token: 'token123456'
    );

    provider.setUser(user.toJson());
    expect(provider.user, isNotNull);
    expect(provider.user.firstname, 'John');
    expect(provider.user.email, 'john.doe@example.com');
  });
}
