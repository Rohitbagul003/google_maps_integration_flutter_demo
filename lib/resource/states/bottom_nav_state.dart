import 'package:flutter/material.dart';

///INFO: Contains index of bottom navigation
class BottomNavState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set setSelectedIndex(val) {
    if (_selectedIndex != val) {
      _selectedIndex = val;
      notifyListeners();
    }
  }
}
