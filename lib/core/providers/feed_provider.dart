import 'package:flutter/material.dart' show ChangeNotifier;

class FeedProvider extends ChangeNotifier {
  FeedProvider();

  final List<int> _list = List<int>.generate(16, (int index) => index);

  List<int> get list => _list;

  void removeFromList(int index) {
    _list.removeAt(index);
    notifyListeners();
  }
}
