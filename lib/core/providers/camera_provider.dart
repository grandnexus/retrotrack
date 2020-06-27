import 'package:riverpod/riverpod.dart';

final StateProvider<CameraProvider> cameraProvider =
    StateProvider<CameraProvider>(
  (ProviderReference ref) => const CameraProvider(),
);

class CameraProvider {
  const CameraProvider({
    this.peopleImagePath,
    this.thermometerImagePath,
  });

  final String peopleImagePath;
  final String thermometerImagePath;
}
