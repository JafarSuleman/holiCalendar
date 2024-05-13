import 'package:flutter/material.dart';

enum StartWeek { sunday, monday }

class ThemeChanger with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _holidayColor = const Color(0xffE25E2A);
  Color _importantDayColor = const Color(0xff006400);
  Color sundayColor = Colors.red;
  StartWeek _startWeek = StartWeek.sunday;

  ThemeMode get themeMode => _themeMode;

  Color get holidayColor => _holidayColor;

  Color get importantDayColor => _importantDayColor;

  Color get sundayColors => sundayColor;

  StartWeek get startWeek => _startWeek;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setHolidayColor(Color color) {
    _holidayColor = color;
    notifyListeners();
  }

  void setImportantDayColor(Color color) {
    _importantDayColor = color;
    notifyListeners();
  }

  void setSundayDayColor(Color color) {
    sundayColor = color;
    notifyListeners();
  }

  void setStartWeek(StartWeek startWeek) {
    _startWeek = startWeek;
    notifyListeners();
  }
}
