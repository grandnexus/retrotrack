import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer((_, Reader read) {
      final SessionProvider session = read(sessionProvider).state;

      if (session.isAuth) {
        return const Redirect('/');
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Auth Screen')),
        body: Center(
          child: RaisedButton.icon(
            onPressed: () {
              sessionProvider.read(context).state =
                  const SessionProvider(isAuth: true);
            },
            icon: const Icon(Icons.person),
            label: const Text('Login'),
          ),
        ),
      );
    });
  }
}
