import 'package:flutter_app/models/resource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ResourceFolder fromMap', () {
    var json = {
      '_id': '1', // Use '_id' instead of 'id'
      'name': 'Folder 1',
      'classroomID': 'classroom1',
      'resources': [
        {
          '_id': '101', // Also ensure this matches if it's checked in ResourceItem.fromMap
          'resourceName': 'Resource 1', 
          'resourceLink': 'http://example.com/resource1'
        }
      ],
      'date': '2020-01-01T12:00:00.000Z'
    };

    var folder = ResourceFolder.fromMap(json);
    expect(folder.id, '1');
    expect(folder.name, 'Folder 1');
    expect(folder.resources.first.resourceName, 'Resource 1');
  });
}
