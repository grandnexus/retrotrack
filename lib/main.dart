import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrotrack/ui/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<CameraDescription> cameras = await availableCameras();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Retrotrack',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          primaryColorLight: Colors.green[300],
          scaffoldBackgroundColor: Colors.black,

          //
          textTheme: GoogleFonts.sourceCodeProTextTheme(
            ThemeData.dark().textTheme,
          ),
          buttonTheme: const ButtonThemeData(
            height: 56,
            splashColor: Colors.transparent,
            textTheme: ButtonTextTheme.primary,
            shape: BeveledRectangleBorder(),
          ),
          dividerTheme: const DividerThemeData(
            thickness: 1,
            color: Colors.green,
            space: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: BeveledRectangleBorder(
              side: BorderSide(color: Colors.green),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),

          //
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
