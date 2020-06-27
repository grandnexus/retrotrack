import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class AuthGuard extends HookWidget {
  const AuthGuard(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final SessionProvider session = useProvider(sessionProvider).state;

    if (session.isAuth) {
      return child;
    }

    return const Redirect('/auth');
  }
}
