import 'package:riverpod/riverpod.dart';

final StateProvider<List<int>> listProvider = StateProvider<List<int>>(
    (ProviderReference ref) => List<int>.generate(16, (int index) => index));
