import 'package:chessus/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

Widget buildGameType(
    {required String label,
    String? gameTime,
    IconData? icon,
    required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon)
              : gameTime! == '60+0'
                  ? SizedBox.shrink()
                  : Text(gameTime),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}

String getTimerToDisplay({
  required GameProvider gameProvider,
  required bool isUser,
}) {
  String timer = '';
  // Check if isUser
  if (isUser) {
    if (gameProvider.player == Squares.white) {
      timer = gameProvider.whitesTime.toString().substring(2, 7);
    }
    if (gameProvider.player == Squares.black) {
      timer = gameProvider.blacksTime.toString().substring(2, 7);
    }
  } else {
    // Other -> Ai or person
    if (gameProvider.player == Squares.white) {
      timer = gameProvider.whitesTime.toString().substring(2, 7);
    }
    if (gameProvider.player == Squares.black) {
      timer = gameProvider.blacksTime.toString().substring(2, 7);
    }
  }
  return timer;
}

// method to display the correct time below the board, if user is white then display white time
// if user is black then display black time

final List<String> gameTimes = [
  'Bullet 1+0',
  'Bullet 2+1',
  'Bullet 3+0',
  'Bullet 3+2',
  'Bullet 5+0',
  'Bullet 5+3',
  'Rapid 10+0',
  'Rapid 10+5',
  'Rapid 15+10',
  'Classical 30+0',
  'Classical 30+20',
  'Custom 60+0',
];
