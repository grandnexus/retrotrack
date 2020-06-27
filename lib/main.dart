import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrotrack/ui/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<CameraDescription> cameras = await availableCameras();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Retrotrack',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, Widget Function(BuildContext)>{
          '/': (_) => const AuthGuard(FeedScreen()),
          '/auth': (_) => const AuthScreen(),
          '/camera': (_) => CameraScreen(cameras.first),
        },
      ),
    ),
  );
}
