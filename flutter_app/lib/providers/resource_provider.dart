import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/resource.dart';

class ResourceProvider with ChangeNotifier {
  ResourceFolder? _currentResourceFolder;

  ResourceFolder? get currentResourceFolder => _currentResourceFolder;

  void setCurrentResourceFolder(ResourceFolder resourceFolder) {
    _currentResourceFolder = resourceFolder;
    notifyListeners();
  }

  void clearCurrentResourceFolder() {
    _currentResourceFolder = null;
    notifyListeners();
  }
}
