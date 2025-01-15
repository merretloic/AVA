import 'package:flutter/material.dart';
import './tasks.dart';

class ConfigurationManager {
  final ValueNotifier<String> _styleNotifier = ValueNotifier<String>("Day");
  ValueNotifier<List<Task>> _currentLifeStyle = ValueNotifier<List<Task>>(
      List<Task>.generate(24, (index) => EmptyTask()));
  ValueNotifier<List<List<Task>>> _allLifeStyles =
      ValueNotifier<List<List<Task>>>(
          [List<Task>.generate(24, (index) => EmptyTask())]);

  String get style => _styleNotifier.value;

  void setStyle(String newStyle) {
    _styleNotifier.value = newStyle;
  }

  String getStyle() {
    return _styleNotifier.value;
  }

  String getLifeStyle() {
    return _currentLifeStyle.value.toString();
  }

  void updateStyle() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 18 || currentHour < 6) {
      _styleNotifier.value = "Night";
    } else {
      _styleNotifier.value = "Day";
    }
  }

  void updateLifeStyle(List<Task> newLifeStyle) {
    _currentLifeStyle.value = newLifeStyle;
  }

  void updateAllLifeStyles(List<List<Task>> newAllLifeStyles) {
    _allLifeStyles.value = newAllLifeStyles;
  }

  ValueNotifier<String> get styleNotifier => _styleNotifier;
  ValueNotifier<List<Task>> get currentLifeStyle => _currentLifeStyle;
  ValueNotifier<List<List<Task>>> get allLifeStyles => _allLifeStyles;
}
