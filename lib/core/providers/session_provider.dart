import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final StateProvider<SessionProvider> sessionProvider =
    StateProvider<SessionProvider>((_) => SessionProvider());

class SessionProvider {
  SessionProvider();

  bool _isAuth = false;

  bool get isAuth => _isAuth;

  void login(BuildContext context, String routeName) {
    _isAuth = true;
    Navigator.pushReplacementNamed(context, routeName);
  }

  void logout() {
    _isAuth = false;
  }
}
