import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (_, SessionProvider session, __) {
        if (session.isAuth) {
          return child;
        }

        return const Redirect('/auth');
      },
    );
  }
}
