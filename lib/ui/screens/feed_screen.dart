import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Screen'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              sessionProvider.read(context).state =
                  const SessionProvider(isAuth: false);
            },
          ),
        ],
      ),
    );
  }
}
