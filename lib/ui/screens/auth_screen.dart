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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Logo(),
              const SizedBox(height: 16),

              //
              OutlineButton(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  sessionProvider.read(context).state =
                      const SessionProvider(isAuth: true);
                },
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
