import 'package:chessus/mainScreens/aboutScreen.dart';
import 'package:chessus/mainScreens/gameTimeScreen.dart';
import 'package:chessus/mainScreens/settingScreen.dart';
import 'package:flutter/material.dart';

import '../helper/helperMethods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'CHESSUS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            buildGameType(
                label: "Play VS Computer",
                icon: Icons.computer,
                onTap: () {
                  // Goto =>> computer player
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameTimeScreen()));
                }),
            buildGameType(
                label: "Play VS Friend",
                icon: Icons.person,
                onTap: () {
                  // Goto =>> computer player
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameTimeScreen()));
                }),
            buildGameType(
                label: "Settings",
                icon: Icons.settings,
                onTap: () {
                  // Goto =>> computer player
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                }),
            buildGameType(
                label: "About",
                icon: Icons.info_outline,
                onTap: () {
                  // Goto =>> computer player
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutScreen()));
                }),
          ],
        ),
      ),
    );
  }
}
