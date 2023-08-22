import 'package:flutter/material.dart';

import '../../utility/enum.dart';

///INFO: Its a basic class extended for all other states
class BaseState extends ChangeNotifier {
  AppState _appState = AppState.initial;

  AppState get appState => _appState;

  set setAppState(AppState state) {
    _appState = state;
    notifyListeners();
  }
}
