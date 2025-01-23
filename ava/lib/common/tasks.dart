import 'package:flutter/material.dart';

abstract class Task {
  String name;
  int durationInHours;
  late Icon icon;
  late Color color;
  String description;
  late final String type;

  Task({
    required this.name,
    required this.durationInHours,
    this.description = '',
    required this.type,
  });

  Task copyWith({
    String? name,
    int? durationInHours,
    Color? color,
    Icon? icon,
    String? description,
  }) {
    if (this is EmptyTask) {
      return EmptyTask()
        ..name = name ?? this.name
        ..durationInHours = durationInHours ?? this.durationInHours
        ..color = color ?? this.color
        ..icon = icon ?? this.icon
        ..description = description ?? this.description;
    } else if (this is SleepTask) {
      return SleepTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        description: description ?? this.description,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is EatTask) {
      return EatTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        foodType: (this as EatTask).foodType,
        description: description ?? this.description,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is RunTask) {
      return RunTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        targetDistance: (this as RunTask).targetDistance,
        description: description ?? this.description,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is StudyTask) {
      return StudyTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        description: description ?? this.description,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else if (this is FreeTimeTask) {
      return FreeTimeTask(
        name: name ?? this.name,
        durationInHours: durationInHours ?? this.durationInHours,
        description: description ?? this.description,
      )
        ..color = color ?? this.color
        ..icon = icon ?? this.icon;
    } else {
      throw Exception('Unknown task type');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'durationInHours': durationInHours,
      'description': description,
      'type': type,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'Empty':
        return EmptyTask();
      case 'Dormir':
        return SleepTask(
          name: map['name'],
          durationInHours: map['durationInHours'],
          description: map['description'],
        );
      case 'Repas':
        return EatTask(
          name: map['name'],
          durationInHours: map['durationInHours'],
          foodType: List<String>.from(map['foodType'] ?? []),
          description: map['description'],
        );
      case 'Exercice physique':
        return RunTask(
          name: map['name'],
          durationInHours: map['durationInHours'],
          targetDistance: map['targetDistance'] ?? 0.0,
          description: map['description'],
        );
      case 'Etudier':
        return StudyTask(
          name: map['name'],
          durationInHours: map['durationInHours'],
          description: map['description'],
        );
      case 'Temps libre':
        return FreeTimeTask(
          name: map['name'],
          durationInHours: map['durationInHours'],
          description: map['description'],
        );
      default:
        throw Exception('Unknown task type: ${map['type']}');
    }
  }

  void displayDetails() {
    debugPrint(
        'Task: $name, Duration: $durationInHours hours, Description: $description');
  }
}

class EmptyTask extends Task {
  @override
  final Icon icon = const Icon(Icons.do_not_disturb);
  @override
  final Color color = Colors.grey;

  EmptyTask() : super(name: 'Empty Task', durationInHours: 1, type: 'Empty');
}

class SleepTask extends Task {
  @override
  final Icon icon = const Icon(Icons.bedtime);
  @override
  final Color color = Colors.green;

  SleepTask({
    required String name,
    required int durationInHours,
    String description = '',
  }) : super(
            name: name,
            durationInHours: durationInHours,
            description: description,
            type: 'Dormir');

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
    String description = '',
  }) : super(
            name: name,
            durationInHours: durationInHours,
            description: description,
            type: 'Repas');

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({'foodType': foodType});
  }

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
    String description = '',
  }) : super(description: description, type: 'Exercice physique');

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({'targetDistance': targetDistance});
  }

  @override
  void displayDetails() {
    super.displayDetails();
    print('Course sur : $targetDistance km');
  }
}

class StudyTask extends Task {
  @override
  final Icon icon = const Icon(Icons.book);
  @override
  final Color color = Colors.purple;

  StudyTask({
    required String name,
    required int durationInHours,
    String description = '',
  }) : super(
            name: name,
            durationInHours: durationInHours,
            description: description,
            type: 'Etudier');

  @override
  void displayDetails() {
    super.displayDetails();
    print('Study Duration: $durationInHours hours');
  }
}

class FreeTimeTask extends Task {
  @override
  final Icon icon = const Icon(Icons.free_breakfast);
  @override
  final Color color = Colors.cyan;

  FreeTimeTask({
    required String name,
    required int durationInHours,
    String description = '',
  }) : super(
            name: name,
            durationInHours: durationInHours,
            description: description,
            type: 'Temps libre');

  @override
  void displayDetails() {
    super.displayDetails();
    print('Free Time Duration: $durationInHours hours');
  }
}