import 'package:chessus/constants.dart';
import 'package:chessus/mainScreens/aboutScreen.dart';
import 'package:chessus/mainScreens/gameScreen.dart';
import 'package:chessus/mainScreens/gameTimeScreen.dart';
import 'package:chessus/mainScreens/homeScreen.dart';
import 'package:chessus/mainScreens/settingScreen.dart';
import 'package:chessus/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GameProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomeScreen(),
      initialRoute: Constants.homeScreen,
      routes: {
        Constants.homeScreen: (context) => HomeScreen(),
        Constants.gameScreen: (context) => GameScreen(),
        Constants.settingScreen: (context) => SettingsScreen(),
        Constants.aboutScreen: (context) => AboutScreen(),
        // Constants.gameStartUpScreen: (context) => GameStartUpScreen(),
        Constants.gameTimeScreen: (context) => GameTimeScreen(),
        // Constants.homeScreen: (context) => HomeScreen(),
      },
    );
  }
}
