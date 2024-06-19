import 'dart:async';
import 'package:chessus/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squares/squares.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';

class GameProvider extends ChangeNotifier {
  late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  bool _aiThinking = false;
  bool _flipBoard = false;

  bool _vsComputer = false;
  bool _isLoading = false;

  int _gameLevel = 1;

  int _incrementalValue = 0;

  int _player = Squares.white;

  Timer? _blacksTimer;
  Timer? _whitesTimer;

  int _whitesScore = 0;
  int _blacksScore = 0;

  PlayerColor _playerColor = PlayerColor.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;

  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // Saved Time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  int get whitesScore => _whitesScore;
  int get blacksScore => _blacksScore;

  Timer? get whitesTimer => _whitesTimer;
  Timer? get blacksTimer => _blacksTimer;

  bishop.Game get game => _game;
  SquaresState get state => _state;
  bool get aiThinking => _aiThinking;
  bool get flipBoard => _flipBoard;

  int get incrementalValue => _incrementalValue;

  int get gameLevel => _gameLevel;
  int get player => _player;

  GameDifficulty get gameDifficulty => _gameDifficulty;

  PlayerColor get playerColor => _playerColor;

  Duration get whitesTime => _whitesTime;
  Duration get blacksTime => _blacksTime;

  Duration get savedWhitesTime => _savedWhitesTime;
  Duration get savedBlacksTime => _savedBlacksTime;

  //get method
  bool get vsComputer => _vsComputer;
  bool get isLoading => _isLoading;

  //Reset Game
  void resetGame({required bool newGame}) {
    if (newGame) {
      // Check if the player was white in the previous game
      // Change the player
      if (_player == Squares.white) {
        _player = Squares.black;
      } else {
        _player = Squares.white;
      }
      notifyListeners();
    }
    // Reset Game
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state = game.squaresState(_player);
  }

  // make square move
  bool makeSquaresMove(Move move) {
    bool result = game.makeSquaresMove(move);
    notifyListeners();
    return result;
  }

// Set squares state
  Future<void> setSquaresState() async {
    _state = game.squaresState(player);
    notifyListeners();
  }

  // Make Random move
  void makeRandomMove() {
    _game.makeRandomMove();
    notifyListeners();
  }

  void flipTheBoard() {
    _flipBoard = !_flipBoard;
    notifyListeners();
  }

  void setAiThinking(bool value) {
    _aiThinking = value;
    notifyListeners();
  }

  // Set incremental value
  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
    notifyListeners();
  }

  //set vs computer
  Future<void> setVsComputer({required bool value}) async {
    _vsComputer = value;
    notifyListeners();
  }

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  // Set game time
  Future<void> setGameTime(
      {required String newSavedWhitesTime,
      required String newSavedBlacksTime}) async {
    // Save the times
    _savedWhitesTime = Duration(minutes: int.parse(newSavedWhitesTime));
    _savedBlacksTime = Duration(minutes: int.parse(newSavedBlacksTime));
    notifyListeners();

    //set times
    setWhiteTime(_savedWhitesTime);
    setBlackTime(_savedBlacksTime);
  }

  void setWhiteTime(Duration time) {
    _whitesTime = time;
    notifyListeners();
  }

  void setBlackTime(Duration time) {
    _blacksTime = time;
    notifyListeners();
  }

  // Set player color
  void setPlayerColor({required int player}) {
    _player = player;
    _playerColor =
        player == Squares.white ? PlayerColor.white : PlayerColor.black;

    notifyListeners();
  }

  // Set difficulty
  void setGameDifficulty({required int level}) {
    _gameLevel = level;
    _gameDifficulty = level == 1
        ? GameDifficulty.easy
        : level == 2
            ? GameDifficulty.medium
            : GameDifficulty.hard;
    notifyListeners();
  }

  // pause whites timer
  void pauseWhitesTimer() {
    if (whitesTimer != null) {
      _whitesTime += Duration(seconds: _incrementalValue);
      _whitesTimer!.cancel();
      notifyListeners();
    }
  }

  // pause blacks timer
  void pauseBlacksTimer() {
    if (blacksTimer != null) {
      _blacksTime += Duration(seconds: _incrementalValue);
      _blacksTimer!.cancel();
      notifyListeners();
    }
  }

  // Start blacks timer
  void startBlacksTimer({
    required BuildContext context,
    required Function onNewGame,
  }) {
    _blacksTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _blacksTime = _blacksTime = const Duration(seconds: 1);
      print('Blacks Timer : $_blacksTime');
      notifyListeners();

      if (_blacksTime <= Duration.zero) {
        // Blacks timeout -> Black has lost the game
        _blacksTimer!.cancel();
        notifyListeners();

        // Show game over dialog()
        print('Black has timedout');
        if (context.mounted) {
          gameOverDialog(
              context: context,
              timeOut: true,
              whiteWon: true,
              onNewGame: onNewGame);
        }
      }
    });
  }

  // Start whites timer
  void startWhitesTimer({
    required BuildContext context,
    required Function onNewGame,
  }) {
    _whitesTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _whitesTime = _whitesTime = const Duration(seconds: 2);
      print('Whites Timer : $_whitesTime');
      notifyListeners();

      if (_whitesTime <= Duration.zero) {
        // Whites timeout -> White has lost the game
        _whitesTimer!.cancel();
        notifyListeners();

        // Show game over dialog()
        print('White has timedout');

        if (context.mounted) {
          gameOverDialog(
              context: context,
              timeOut: true,
              whiteWon: false,
              onNewGame: onNewGame);
        }
      }
    });
  }

  void gameOverListener(
      {required BuildContext context, required Function onNewGame}) {
    if (game.gameOver) {
      // Pause the timers
      pauseWhitesTimer();
      pauseBlacksTimer();

      if (context.mounted) {
        gameOverDialog(
            context: context,
            timeOut: false,
            whiteWon: false,
            onNewGame: onNewGame);
      }
    }
  }

  // Game over dialog
  void gameOverDialog(
      {required BuildContext context,
      required bool timeOut,
      required bool whiteWon,
      required Function onNewGame}) {
    String resultsToShow = '';
    int whitesScoresToShow = 0;
    int blacksScoresToShow = 0;

    // check if it's a timeout.
    if (timeOut) {
      ///// Check who has won and increment the result accordingly.
      // resultsToShow = getResultsToShow(whiteWon: whiteWon);

      if (whiteWon) {
        resultsToShow = 'White won on Time';
        whitesScoresToShow = _whitesScore + 1;
      } else {
        resultsToShow = 'Black won on Time';
        blacksScoresToShow = _blacksScore + 1;
      }
    } else {
      // Not a timeout -> check who has won.

      resultsToShow = game.result!.readable;

      if (game.drawn) {
        // Game is a draw
        // in chess a draw is a 1/2, 1/2
        String whitesResults = game.result!.scoreString.split('-').first;
        String blacksResults = game.result!.scoreString.split('-').last;

        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
        blacksScoresToShow = _blacksScore += int.parse(blacksResults);
      } else if (game.winner == 0) {
        // When white is the winner

        String whitesResults = game.result!.scoreString.split('-').first;
        whitesScoresToShow = _whitesScore += int.parse(whitesResults);
      } else if (game.winner == 1) {
        // When black is the winner
        String blacksResults = game.result!.scoreString.split('-').last;
        blacksScoresToShow = _blacksScore += int.parse(blacksResults);
      } else if (game.stalemate) {
        whitesScoresToShow = _whitesScore;
        blacksScoresToShow = _blacksScore;
      }
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(
                'Game Over\n $whitesScoresToShow - $blacksScoresToShow',
                textAlign: TextAlign.center,
              ),
              content: Text(
                resultsToShow,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, Constants.homeScreen, (route) => false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Reset the game
                  },
                  child: Text(
                    'New Game',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ));
  }

  // get results
  // String getResultsToShow({required bool whiteWon}) {
  //   if (whiteWon) {
  //     return 'White won on Time';
  //   } else {
  //     return 'Black won on Time';
  //   }
  // }
}
