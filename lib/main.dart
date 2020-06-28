import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:retrotrack/core/index.dart';

import 'package:retrotrack/ui/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TemperatureAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(LogEntryAdapter());

  final List<CameraDescription> cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider<SessionProvider>(
      create: (_) => SessionProvider(),
      child: MaterialApp(
        title: 'Retrotrack',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          primaryColorLight: Colors.green[300],
          scaffoldBackgroundColor: Colors.black,
          splashColor: Colors.transparent,
          highlightColor: Colors.grey[900],

          //
          textTheme: GoogleFonts.sourceCodeProTextTheme(
            ThemeData.dark().textTheme,
          ),
          buttonTheme: const ButtonThemeData(
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
            splashColor: Colors.transparent,
          ),
          dialogTheme: const DialogTheme(
            shape:
                BeveledRectangleBorder(side: BorderSide(color: Colors.green)),
            backgroundColor: Colors.black,
          ),

          //
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, Widget Function(BuildContext)>{
          '/': (_) => AuthGuard(
                ChangeNotifierProvider<FeedProvider>(
                  create: (_) => FeedProvider(),
                  child: const FeedScreen(),
                ),
              ),
          '/auth': (_) => const AuthScreen(),
          '/camera': (_) => ChangeNotifierProvider<CameraProvider>(
                create: (_) => CameraProvider(cameras.first),
                child: const CameraScreen(),
              ),
        },
      ),
    ),
  );
}
