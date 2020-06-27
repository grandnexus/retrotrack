import 'package:riverpod/riverpod.dart';

final StateProvider<int> counterProvider =
    StateProvider<int>((ProviderReference ref) => 0);
