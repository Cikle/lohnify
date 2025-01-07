import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewTypeProvider with ChangeNotifier {
  static const String _viewTypeKey = 'is_employer_view';
  final SharedPreferences _prefs;
  bool _isEmployerView;

  ViewTypeProvider(this._prefs)
      : _isEmployerView = _prefs.getBool(_viewTypeKey) ?? false;

  bool get isEmployerView => _isEmployerView;

  Future<void> toggleView() async {
    _isEmployerView = !_isEmployerView;
    await _prefs.setBool(_viewTypeKey, _isEmployerView);
    notifyListeners();
  }
}
