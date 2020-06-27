import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/ui/index.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Retrotrack',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, Widget Function(BuildContext)>{
          '/': (_) => const AuthGuard(FeedScreen()),
          '/auth': (_) => const AuthScreen(),
          '/counter': (_) => const CounterScreen(),
        },
      ),
    ),
  );
}
