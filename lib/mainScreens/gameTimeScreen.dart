import 'package:chessus/constants.dart';
import 'package:chessus/helper/helperMethods.dart';
import 'package:chessus/mainScreens/gameStartUpScreen.dart';
import 'package:chessus/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTimeScreen extends StatefulWidget {
  const GameTimeScreen({super.key});

  @override
  State<GameTimeScreen> createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    print('VS Value: ${gameProvider.vsComputer}');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Choose Game Time',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
            itemCount: gameTimes.length,
            itemBuilder: (context, index) {
              // get the first word of the game time
              final String label = gameTimes[index].split(' ')[0];

              // gat the second word from game time
              final String gameTime = gameTimes[index].split(' ')[1];

              return buildGameType(
                  label: label,
                  gameTime: gameTime,
                  onTap: () {
                    if (label == Constants.custom) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameStartUpScreen(
                                  isCustomTime: true, gameTime: gameTime)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameStartUpScreen(
                                  isCustomTime: true, gameTime: gameTime)));
                    }
                  },);
            },),);
  }
}
