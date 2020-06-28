import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (_, SessionProvider session, __) {
        if (session.isAuth) {
          return const Redirect('/', removeUntilRoot: true);
        }

        return Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Logo(showImage: true),
                const SizedBox(height: 16.0),

                //
                RetroOutlineButton(
                  onPressed: () {
                    session.login();
                  },
                  text: 'login',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
