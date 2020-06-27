import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthScreen extends HookWidget {
  const AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer((_, read) {
      final SessionProvider session = read(sessionProvider).state;
      if (session.isAuth) {
        return const Redirect('/');
      }

      return Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Logo(),
              const SizedBox(height: 16),

              //
              RetroOutlineButton(
                onPressed: () {
                  session.login(context, '/');
                },
                text: 'login',
              ),
            ],
          ),
        ),
      );
    });
  }
}
