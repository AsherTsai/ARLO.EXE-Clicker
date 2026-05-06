import 'package:computer_clicker_game/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'model.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      // Initialize window manager and set the maximum window size for desktop platforms
    ]);
  }
  // For mobile platforms, we can set the orientation to portrait

  runApp(
    // PROVIDER
    ChangeNotifierProvider(create: (context) => Model(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      // THEME
      theme: ThemeData(fontFamily: "Tiny5"),
    );
  }
}
