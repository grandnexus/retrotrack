import 'package:riverpod/riverpod.dart';

final StateProvider<SessionProvider> sessionProvider =
    StateProvider<SessionProvider>(
  (ProviderReference ref) => const SessionProvider(),
);

class SessionProvider {
  const SessionProvider({this.isAuth = false});

  final bool isAuth;

  // bool get isAuth => _isAuth;

  // void login() {
  //   _isAuth = true;
  // }

  // void logout() {
  //   _isAuth = false;
  // }
}
