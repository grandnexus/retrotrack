import 'package:flutter/material.dart' show ChangeNotifier;

class SessionProvider extends ChangeNotifier {
  SessionProvider();

  bool _isAuth = false;

  bool get isAuth => _isAuth;

  void login() {
    _isAuth = true;
    notifyListeners();
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
