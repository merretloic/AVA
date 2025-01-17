import 'package:flutter/material.dart';

abstract class Task {
  final String name;
  final int durationInHours;
  late Icon icon;
  late Color color;

  Task({
    required this.name,
    required this.durationInHours,
  });

  // Common method for all task types
  void displayDetails() {
    print('Task: $name, Duration: $durationInHours hours');
  }
}

class EmptyTask extends Task {
  @override
  final Icon icon = const Icon(Icons.do_not_disturb);
  @override
  final Color color = Colors.grey;

  EmptyTask() : super(name: 'Empty Task', durationInHours: 1);
}

class SleepTask extends Task {
  @override
  final Icon icon = const Icon(Icons.bedtime);
  @override
  final Color color = Colors.green;

  SleepTask({
    required String name,
    required int durationInHours,
  }) : super(name: name, durationInHours: durationInHours);

  @override
  void displayDetails() {
    super.displayDetails();
    print('Required Document: $durationInHours');
  }
}

class EatTask extends Task {
  final List<String> foodType;
  @override
  final Icon icon = const Icon(Icons.food_bank);
  @override
  final Color color = const Color.fromARGB(255, 255, 247, 0);

  EatTask({
    required String name,
    required int durationInHours,
    required this.foodType,
  }) : super(name: name, durationInHours: durationInHours);

  @override
  void displayDetails() {
    super.displayDetails();
    print('Food Type: $foodType');
  }
}

class RunTask extends Task {
  final double targetDistance;
  @override
  final Icon icon = const Icon(Icons.directions_run);
  @override
  final Color color = Colors.blue;

  RunTask({
    required super.name,
    required super.durationInHours,
    required this.targetDistance,
  });

  @override
  void displayDetails() {
    super.displayDetails();
    print('Course sur : $targetDistance km');
  }
}
