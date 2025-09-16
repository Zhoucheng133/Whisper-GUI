import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper_gui/main_window.dart';
import 'package:whisper_gui/utils/controller.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "Whisper GUI"
  );
  Get.put(Controller());
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final brightness = MediaQuery.of(context).platformBrightness; 

    return MaterialApp(
      theme: brightness==Brightness.dark ? ThemeData.dark().copyWith(
        textTheme: GoogleFonts.notoSansScTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white, 
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ) : ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: GoogleFonts.notoSansScTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainWindow()
      ),
    );
  }
}
