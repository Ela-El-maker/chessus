import 'package:chessus/constants.dart';
import 'package:chessus/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen(
      {super.key, required this.isCustomTime, required this.gameTime});

  final bool isCustomTime;
  final String gameTime;

  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  PlayerColor playerColorGroup = PlayerColor.white;
  GameDifficulty gameLevelGroup = GameDifficulty.easy;

  int whiteTimeinMinutes = 0;
  int blackTimeinMinutes = 0;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Setup Game",
          style: TextStyle(color: const Color.fromARGB(255, 207, 93, 93)),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // RadioList Tile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: PlayerColorRadioButton(
                      title: "Play as ${PlayerColor.white.name}",
                      value: PlayerColor.white,
                      groupValue: playerColorGroup,
                      onChanged: (value) {
                        setState(() {
                          playerColorGroup = value!;
                        });
                      }),
                ),
                widget.isCustomTime
                    ? BuildCustomTime(
                        time: whiteTimeinMinutes.toString(),
                        onLeftArrowClicked: () {
                          setState(() {
                            whiteTimeinMinutes--;
                          });
                        },
                        onRightArrowClicked: () {
                          setState(() {
                            whiteTimeinMinutes++;
                          });
                        })
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              widget.gameTime,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: PlayerColorRadioButton(
                      title: "Play as ${PlayerColor.black.name}",
                      value: PlayerColor.black,
                      groupValue: playerColorGroup,
                      onChanged: (value) {
                        setState(() {
                          playerColorGroup = value!;
                        });
                      }),
                ),
                widget.isCustomTime
                    ? BuildCustomTime(
                        time: blackTimeinMinutes.toString(),
                        onLeftArrowClicked: () {
                          setState(() {
                            blackTimeinMinutes--;
                          });
                        },
                        onRightArrowClicked: () {
                          setState(() {
                            blackTimeinMinutes++;
                          });
                        })
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              widget.gameTime,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            gameProvider.vsComputer
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Game Difficult',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GameLevelRadioButton(
                            title: GameDifficulty.easy.name,
                            value: GameDifficulty.easy,
                            groupValue: gameLevelGroup,
                            onChanged: (value) {
                              setState(() {
                                gameLevelGroup = value!;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GameLevelRadioButton(
                            title: GameDifficulty.medium.name,
                            value: GameDifficulty.medium,
                            groupValue: gameLevelGroup,
                            onChanged: (value) {
                              setState(() {
                                gameLevelGroup = value!;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GameLevelRadioButton(
                            title: GameDifficulty.hard.name,
                            value: GameDifficulty.hard,
                            groupValue: gameLevelGroup,
                            onChanged: (value) {
                              setState(() {
                                gameLevelGroup = value!;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  //  Navigate to the gamescreen
                  playGame(gameProvider: gameProvider);
                },
                child: Text('Play'))
          ],
        ),
      ),
    );
  }

  void playGame({required GameProvider gameProvider}) {
    // check if it is custom time
    if (widget.isCustomTime) {
      // check all timer are greater than 0
      if (whiteTimeinMinutes <= 0 || blackTimeinMinutes <= 0) {
        // Show snackbar
        showSnackBar(context: context, content: 'Time cannot be 0');
        return;
      }
    }
    //1. Show loading progrogress ->loader
    gameProvider.setIsLoading(value: true);

    // 2. Save time for both players and player color.
    gameProvider.setGameTime(
        newSavedWhitesTime: whiteTimeinMinutes.toString(),
        newSavedBlacksTime: blackTimeinMinutes.toString());

    //3. Navigate to game screen

    Navigator.pushNamed(context, Constants.gameScreen);
  }
}
