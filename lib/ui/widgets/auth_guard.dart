import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer((_, Reader read) {
      final SessionProvider session = read(sessionProvider).state;

      if (session.isAuth) {
        return child;
      }

      return const Redirect('/auth');
    });
  }
}
