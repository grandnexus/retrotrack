import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/ui/index.dart';
import 'package:snappable/snappable.dart';

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
                child: Consumer((_, Reader read) {
                  final List<int> list = read(listProvider).state;

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final GlobalKey<SnappableState> key =
                          GlobalKey<SnappableState>();

                      return Snappable(
                        key: key,
                        child: ListTile(
                          onLongPress: () async {
                            final bool res = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => _DeleteDialog(),
                            );
                            if (res) {
                              key.currentState.snap().then((_) => listProvider
                                  .read(context)
                                  .state
                                  .removeAt(index));
                            }
                          },
                          title: Text('Person $index'.toUpperCase()),
                          trailing: const Text('37.0\u2103'),
                        ),
                      );
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: const _FAB(),
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

class _DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'REMOVE RECORD',
        textAlign: TextAlign.center,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: const Text('NO'),
            onPressed: () => Navigator.pop(context, false),
          ),
          RaisedButton(
            child: const Text('YES'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
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
