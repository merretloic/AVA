import 'package:flutter/material.dart';

class ConfigurationManager {
  final ValueNotifier<String> _styleNotifier = ValueNotifier<String>("Day");

  String get style => _styleNotifier.value;

  void setStyle(String newStyle) {
    _styleNotifier.value = newStyle;
  }

  String getStyle() {
    return _styleNotifier.value;
  }

  void updateStyle() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 18 || currentHour < 6) {
      _styleNotifier.value = "Night";
    } else {
      _styleNotifier.value = "Day";
    }
  }

  ValueNotifier<String> get styleNotifier => _styleNotifier;
}
