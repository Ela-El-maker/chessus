import 'dart:math';
import 'package:chessus/helper/helperMethods.dart';
import 'package:chessus/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';
import '../service/assets_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    final gameProvider = context.read<GameProvider>();
    gameProvider.resetGame(newGame: false);

    if (mounted) {
      letOtherPlayerPlayFirst();
    }

    super.initState();
  }

  void letOtherPlayerPlayFirst() {
    // Wait for widget to rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final gameProvider = context.read<GameProvider>();
      if (gameProvider.state.state == PlayState.theirTurn &&
          !gameProvider.aiThinking) {
        gameProvider.setAiThinking(true);
        await Future.delayed(
            Duration(milliseconds: Random().nextInt(4750) + 250));
        gameProvider.game.makeRandomMove();
        gameProvider.setAiThinking(false);
        gameProvider.setSquaresState().whenComplete(() {
          // Pause timer for white
          gameProvider.pauseWhitesTimer();

          startTimer(isWhitesTimer: false, onNewGame: () {});
        });
      }
    });
  }

  // void _flipBoard() => setState(() => flipBoard = !flipBoard);

  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();
    print('Move: ${move}');
    print('White Time : ${gameProvider.whitesTime}');
    print('Black Time : ${gameProvider.blacksTime}');
    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState().whenComplete(() {
        if (gameProvider.player == Squares.white) {
// Pause timer for white
          gameProvider.pauseWhitesTimer();

          startTimer(isWhitesTimer: false, onNewGame: () {});
        } else {
          // Pause timer for blacks
          gameProvider.pauseBlacksTimer();

          startTimer(isWhitesTimer: true, onNewGame: () {});
        }
      });
    }
    if (gameProvider.state.state == PlayState.theirTurn &&
        !gameProvider.aiThinking) {
      gameProvider.setAiThinking(true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      gameProvider.game.makeRandomMove();
      gameProvider.setAiThinking(false);
      gameProvider.setSquaresState().whenComplete(() {
        if (gameProvider.player == Squares.white) {
          // Pause timer for blacks
          gameProvider.pauseBlacksTimer();

          startTimer(isWhitesTimer: true, onNewGame: () {});
        } else {
          // Pause timer for white
          gameProvider.pauseWhitesTimer();

          startTimer(isWhitesTimer: false, onNewGame: () {});
        }
      });
    }

    // Listen if it is game over
    checkGameOverListener();
  }

  void checkGameOverListener() {
    final gameProvider = context.read<GameProvider>();

    gameProvider.gameOverListener(
        context: context,
        onNewGame: () {
          // Start  new game.
        });
  }

  void startTimer({
    required bool isWhitesTimer,
    required Function onNewGame,
  }) {
    final gameProvider = context.read<GameProvider>();
    if (isWhitesTimer) {
      // Start timer for white

      gameProvider.startWhitesTimer(context: context, onNewGame: onNewGame);
    } else {
      //STart timer for black
      gameProvider.startBlacksTimer(context: context, onNewGame: onNewGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    print('White Time : ${gameProvider.whitesTime}');
    print('Black Time : ${gameProvider.blacksTime}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // TODO show dialog if sure
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
        title: const Text(
          'CHESSUS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              gameProvider.resetGame(newGame: false);
            },
            icon: const Icon(
              Icons.start_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              gameProvider.flipTheBoard();
            },
            icon: const Icon(
              Icons.rotate_left,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Consumer<GameProvider>(builder: (context, value, child) {
        String whitesTimer =
            getTimerToDisplay(gameProvider: gameProvider, isUser: true);

        String blacksTimer =
            getTimerToDisplay(gameProvider: gameProvider, isUser: false);

        return Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Opponent data
            ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(AssetsManager.stockfishIcon),
              ),
              title: Text('Stockfish'),
              subtitle: Text('Rating: 3000'),
              trailing: Text(
                blacksTimer,
                style: TextStyle(fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BoardController(
                state: gameProvider.flipBoard
                    ? gameProvider.state.board.flipped()
                    : gameProvider.state.board,
                playState: gameProvider.state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: gameProvider.state.moves,
                onMove: _onMove,
                onPremove: _onMove,
                markerTheme: MarkerTheme(
                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),

            // Opponent data
            ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(AssetsManager.userIcon),
              ),
              title: Text('User301'),
              subtitle: Text('Rating: 1200'),
              trailing: Text(
                whitesTimer,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      }),
    );
  }
}
