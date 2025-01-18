import 'package:flutter/material.dart';

abstract class Task {
  String name;
  int durationInHours;
  late Icon icon;
  late Color color;

  Task({
    required this.name,
    required this.durationInHours,
  });

  Task copyWith(
      {String? name, int? durationInHours, Color? color, Icon? icon}) {
    if (this is EmptyTask) {
      return EmptyTask()
        ..name = name ?? this.name
        ..durationInHours = durationInHours ?? this.durationInHours
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is SleepTask) {
      return SleepTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is EatTask) {
      return EatTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        foodType: (this as EatTask).foodType,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is RunTask) {
      return RunTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        targetDistance: (this as RunTask).targetDistance,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else {
      throw Exception('Unknown task type');
    }
  }

  // Common method for all task types
  void displayDetails() {
    debugPrint('Task: $name, Duration: $durationInHours hours');
  }
}

class EmptyTask extends Task {
  static const type = 'Empty';
  @override
  final Icon icon = const Icon(Icons.do_not_disturb);
  @override
  final Color color = Colors.grey;

  EmptyTask() : super(name: 'Empty Task', durationInHours: 1);
}

class SleepTask extends Task {
  static const type = 'Sleep';
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
  static const type = 'Eat';
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
  static const type = 'Run';
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

class StudyTask extends Task {
  static const type = 'Study';
  @override
  final Icon icon = const Icon(Icons.book);
  @override
  final Color color = Colors.purple;

  StudyTask({
    required String name,
    required int durationInHours,
  }) : super(name: name, durationInHours: durationInHours);

  @override
  void displayDetails() {
    super.displayDetails();
    print('Study Duration: $durationInHours hours');
  }
}

class FreeTimeTask extends Task {
  static const type = 'FreeTime';
  @override
  final Icon icon = const Icon(Icons.free_breakfast);
  @override
  final Color color = Colors.cyan;

  FreeTimeTask({
    required String name,
    required int durationInHours,
  }) : super(name: name, durationInHours: durationInHours);

  @override
  void displayDetails() {
    super.displayDetails();
    print('Free Time Duration: $durationInHours hours');
  }
}
