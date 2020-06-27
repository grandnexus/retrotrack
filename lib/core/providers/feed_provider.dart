import 'package:riverpod/riverpod.dart';

final StateProvider<FeedProvider> feedProvider =
    StateProvider<FeedProvider>((ProviderReference ref) => FeedProvider());

class FeedProvider {
  FeedProvider();

  List<int> _list = <int>[];

  List<int> get list => _list;

  List<int> generateList() {
    _list = List<int>.generate(16, (int index) => index);
    return _list;
  }

  void removeFromList(int index) {
    _list.removeAt(index);
  }
}
