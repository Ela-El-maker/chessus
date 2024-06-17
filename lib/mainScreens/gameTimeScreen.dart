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
          title: Text(
            'Choose Game Time',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
            itemCount: gameTimes.length,
            itemBuilder: (context, index) {
              // Get the first word of the game time
              final String label = gameTimes[index].split(' ')[0];

              // get the second word of the game time
              final String gameTime = gameTimes[index].split(' ')[1] +
                  ' ' +
                  gameTimes[index].split(' ')[2] +
                  ' ' +
                  gameTimes[index].split(' ')[3];

              return buildGameType(
                  label: label,
                  gameTime: gameTime,
                  onTap: () {
                    if (label == 'Custom') {}
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameStartUpScreen()));
                  });
            }));
  }
}
