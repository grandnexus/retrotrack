import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:hive/hive.dart' show Box, Hive;

import 'package:retrotrack/core/index.dart' show LogEntry;

class FeedProvider extends ChangeNotifier {
  FeedProvider() {
    _init();
  }

  List<LogEntry> _list;
  bool _isLoading = true;

  List<LogEntry> get list => _list;
  bool get isLoading => _isLoading;

  Future<void> removeLogEntry(LogEntry logEntry) async {
    final Box<LogEntry> logEntryBox = await Hive.openBox('log_entries');

    logEntryBox.delete(logEntry.key);
  }

  void removeFromList(LogEntry log) {
    _list.remove(log);
    removeLogEntry(log);
    notifyListeners();
  }

  Future<void> _init() async {
    final Box<LogEntry> data = await Hive.openBox<LogEntry>('log_entries');

    if (data.isEmpty) {
      _list = <LogEntry>[];
    } else {
      _list = data.values.toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    final Box<LogEntry> data = await Hive.openBox<LogEntry>('log_entries');

    if (data.isEmpty) {
      _list = <LogEntry>[];
    } else {
      _list = data.values.toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
