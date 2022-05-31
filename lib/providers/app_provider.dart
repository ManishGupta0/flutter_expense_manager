import 'package:flutter/foundation.dart';
import 'package:flutter_expense_manager/models/app_model.dart';

class AppProvider extends ChangeNotifier {
  final AppModel _appModel = AppModel();

  AppModel get model => _appModel;

  void notify() {
    notifyListeners();
  }

  void updatePage(int page) {
    _appModel.appPage = page;
    notifyListeners();
  }

  void updateDeveloperMode(bool value) {
    _appModel.developerMode = value;
    notifyListeners();
  }
}
