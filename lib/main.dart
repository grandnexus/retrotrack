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

  const Color brightGreen = Color(0xFF87FB93);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => SessionProvider(),
        ),
        ChangeNotifierProvider<FeedProvider>(
          create: (_) => FeedProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Retrotrack',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: brightGreen,
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
            color: brightGreen,
            space: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: BeveledRectangleBorder(
              side: BorderSide(color: brightGreen),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            splashColor: Colors.transparent,
          ),
          dialogTheme: const DialogTheme(
            shape: BeveledRectangleBorder(side: BorderSide(color: brightGreen)),
            backgroundColor: Colors.black,
          ),

          //
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, Widget Function(BuildContext)>{
          '/': (_) => const AuthGuard(FeedScreen()),
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
