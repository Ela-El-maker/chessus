import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  bool _vsComputer = false;
  bool _isLoading = false;

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
}
