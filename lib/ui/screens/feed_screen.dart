import 'dart:io';

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
            Logo(
              color: Colors.black,
              bgColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const NoneScrollBehavior(),
                child: Consumer<FeedProvider>(
                  builder: (_, FeedProvider feed, __) {
                    if (feed.isLoading) {
                      return const Center(child: Text('LOADING...'));
                    } else {
                      if (feed.list.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('NO ENTRY'),
                              RetroOutlineButton(
                                text: 'Refresh',
                                onPressed: () async => feed.refresh(),
                              )
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          feed.refresh();
                        },
                        child: ListView.separated(
                          itemCount: feed.list.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, int index) {
                            return _LogDisplay(
                              feed.list[feed.list.length - index - 1],
                            );
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

class _LogDisplay extends StatelessWidget {
  const _LogDisplay(this.log);

  final LogEntry log;

  @override
  Widget build(BuildContext context) {
    const Duration snapDuration = Duration(seconds: 4);
    final GlobalKey<SnappableState> key = GlobalKey<SnappableState>();
    final FeedProvider feed = Provider.of<FeedProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Snappable(
        key: key,
        duration: snapDuration,
        child: GestureDetector(
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
          child: InkWell(
            onTap: () {},
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.file(File(log.photoUrl), fit: BoxFit.fitWidth),
                  ),
                  VerticalDivider(
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                    width: 16,
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: log.people.map((Person p) {
                          final bool danger = p.temperature.temperature >= 37.5;

                          return Row(
                            children: <Widget>[
                              Image.file(File(p.photoUrl), height: 40),
                              const Spacer(),
                              Text(
                                p.temperature.temperature.toString(),
                                style: !danger
                                    ? Theme.of(context).textTheme.bodyText1
                                    : Theme.of(context).textTheme.subtitle1,
                              ),
                              if (danger)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.error_outline,
                                      color: Colors.red),
                                )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
