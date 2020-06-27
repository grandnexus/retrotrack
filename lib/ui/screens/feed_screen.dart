import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RetroBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Logo(),
            const Divider(),
            Expanded(
              child: ScrollConfiguration(
                behavior: const NoneScrollBehavior(),
                child: ListView.separated(
                  itemCount: 25,
                  separatorBuilder: (_, __) => const Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('item $index'),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: const _FAB(),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () {
        sessionProvider.read(context).state =
            const SessionProvider(isAuth: false);
      },
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/camera');
      },
      label: const Text('ENTRY'),
      icon: const Icon(Icons.add),
    );
  }
}
