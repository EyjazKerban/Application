import 'package:flutter_app/models/resource.dart';
import 'package:flutter_app/providers/resource_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ResourceProvider change notification', () {
    final provider = ResourceProvider();
    var resourceFolder = ResourceFolder(
      id: '1', name: 'Folder', classroomID: 'class1', resources: [], date: DateTime.now()
    );

    // Check initial state
    expect(provider.currentResourceFolder, isNull);

    // Setting value
    provider.setCurrentResourceFolder(resourceFolder);
    expect(provider.currentResourceFolder, isNotNull);
    expect(provider.currentResourceFolder!.id, '1');
  });
}
