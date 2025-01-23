import 'package:flutter/material.dart';
import 'package:ava/common/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfigurationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ValueNotifier<String> _styleNotifier = ValueNotifier<String>("Day");
  ValueNotifier<List<Task>> _currentLifeStyle = ValueNotifier<List<Task>>(
      List<Task>.generate(24, (index) => EmptyTask()));
  ValueNotifier<List<List<Task>>> _allLifeStyles =
      ValueNotifier<List<List<Task>>>([
    List<Task>.generate(24, (index) => EmptyTask())
  ]);
  final ValueNotifier<bool> _isFormFilled = ValueNotifier<bool>(false);
  final ValueNotifier<String> _conseils = ValueNotifier<String>("");

  ConfigurationManager() {
    _initializeLifeStyles();
  }

Future<void> _initializeLifeStyles() async {
  final user = _auth.currentUser;
  if (user != null) {
    try {
      final doc = await _firestore
          .collection('lifestyle')
          .doc(user.uid)
          .collection('lifestyle')
          .doc('lifestylesData')
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final allLifeStylesData = data['allLifeStyles'] as List<dynamic>?;
          if (allLifeStylesData != null) {
            _allLifeStyles.value = _groupTasksByLifeStyle(
              allLifeStylesData.map((taskData) => Task.fromMap(taskData)).toList(),
            );
          }

          final activeLifeStyleData = data['activeLifeStyle'] as List<dynamic>?;
          if (activeLifeStyleData != null) {
            _currentLifeStyle.value = activeLifeStyleData
                .map((taskData) => Task.fromMap(taskData))
                .toList();
          }
        }
      }
    } catch (e) {
      print("Error loading from Firestore: $e");
    }
  }
}

List<List<Task>> _groupTasksByLifeStyle(List<Task> tasks) {
  return [tasks];
}
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

  bool getIsFormFilled() {
    return _isFormFilled.value;
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

  void updateIsFormFilled() {
    _isFormFilled.value = !_isFormFilled.value;
  }

  bool get isFormFilled => _isFormFilled.value;

  ValueNotifier<String> get styleNotifier => _styleNotifier;
  ValueNotifier<List<Task>> get currentLifeStyle => _currentLifeStyle;
  ValueNotifier<List<List<Task>>> get allLifeStyles => _allLifeStyles;
  ValueNotifier<bool> get isFormFilledNotifier => _isFormFilled;
  ValueNotifier<String> get conseilsNotifier => _conseils;

  String get conseils => _conseils.value;

  void setConseils(String newConseils) {
    _conseils.value = newConseils;
  }
}
