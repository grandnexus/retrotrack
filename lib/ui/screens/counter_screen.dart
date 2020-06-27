import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        child: Consumer((_, Reader read) {
          final int count = read(counterProvider).state;
          return Text('$count');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // No need to rebuild the floating button when the counter changes, so we use "read"
        onPressed: () => counterProvider.read(context).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
