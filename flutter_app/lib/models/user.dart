import 'dart:convert';

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String role;
  final String token;

  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.role,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'role': role,
      'token': token
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'] ?? '',
        firstname: map['firstname'] ?? '',
        lastname: map['lastname'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        role: map['role'] ?? '',
        token: map['token'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

