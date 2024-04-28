import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/test.dart';
import 'package:flutter_app/providers/test_provider.dart';

void main() {
  group('TestProvider Tests', () {
    test('Current Test Update', () {
      var test = Test(id: '2', name: 'Test 2', classroomID: 'classroom2', date: DateTime.now(), total: 50, testResults: []);
      var provider = TestProvider();

      expect(provider.currentTest, isNull);
      provider.setCurrentTest(test);
      expect(provider.currentTest, isNotNull);
      expect(provider.currentTest!.id, equals('2'));

      provider.clearCurrentTest();
      expect(provider.currentTest, isNull);
    });
  });
}
