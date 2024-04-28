import 'dart:convert';

class Payment {
  final String id;
  final String classroomID;
  final String month;
  final List<PaymentSubmission> payments;

  Payment({
    required this.id,
    required this.classroomID,
    required this.month,
    required this.payments,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['_id'] ?? '',
      classroomID: map['classroomID'] ?? '',
      month: map['month'] ?? '',
      payments: List<PaymentSubmission>.from(
        map['payments']?.map((x) => PaymentSubmission.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classroomID': classroomID,
      'month': month,
      'payments': payments.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));
}

class PaymentSubmission {
  final String userID;
  final String image; // URL of the payment proof image
  final DateTime date;
  final bool verified;

  PaymentSubmission({
    required this.userID,
    required this.image,
    required this.date,
    required this.verified,
  });

  factory PaymentSubmission.fromMap(Map<String, dynamic> map) {
    return PaymentSubmission(
      userID: map['userID'] ?? '',
      image: map['image'] ?? '',
      date: DateTime.parse(map['date']),
      verified: map['verified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'image': image,
      'date': date.toIso8601String(),
      'verified': verified,
    };
  }
}
