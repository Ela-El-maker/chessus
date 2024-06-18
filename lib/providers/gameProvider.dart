import 'package:chessus/constants.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class GameProvider extends ChangeNotifier {
  bool _vsComputer = false;
  bool _isLoading = false;

  int _player = Squares.white;
  PlayerColor _playerColor = PlayerColor.white;

  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // Saved Time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  int get player => _player;
  PlayerColor get playerColor => _playerColor;

  Duration get whitesTime => _whitesTime;
  Duration get blacksTime => _blacksTime;

  Duration get savedWhitesTime => _savedWhitesTime;
  Duration get savedBlacksTime => _savedBlacksTime;

  //get method
  bool get vsComputer => _vsComputer;
  bool get isLoading => _isLoading;

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
}
