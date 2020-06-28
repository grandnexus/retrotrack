import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                child: Consumer<FeedProvider>(
                  builder: (_, FeedProvider feed, __) {
                    if (feed.isLoading) {
                      return const Center(child: Text('LOADING...'));
                    } else {
                      if (feed.list.isEmpty) {
                        return const Center(child: Text('NO ENTRY'));
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          feed.refresh();
                        },
                        child: ListView.separated(
                          itemCount: feed.list.length,
                          separatorBuilder: (_, __) => const Divider(
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (_, int index) {
                            return _ListTile(feed.list[index]);
                          },
                        ),
                      );
                    }
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

class _ListTile extends StatelessWidget {
  const _ListTile(this.log);

  final LogEntry log;

  @override
  Widget build(BuildContext context) {
    const Duration snapDuration = Duration(seconds: 4);
    final GlobalKey<SnappableState> key = GlobalKey<SnappableState>();
    final FeedProvider feed = Provider.of<FeedProvider>(context);

    return Snappable(
      key: key,
      duration: snapDuration,
      child: ListTile(
        onLongPress: () async {
          final bool res = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => _DeleteDialog(),
          );
          if (res) {
            key.currentState.snap().then((_) async {
              await Future<void>.delayed(snapDuration);
              feed.removeFromList(log);
            });
          }
        },
        title: Text(log.people.length.toString()),
        trailing: const Text('37.0\u2103'),
      ),
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
          RetroOutlineButton(
            text: 'no',
            onPressed: () => Navigator.pop(context, false),
          ),
          RetroOutlineButton(
            text: 'yes',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
