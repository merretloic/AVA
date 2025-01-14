import 'package:flutter/material.dart';
import 'configurationManager.dart';
import 'tasks.dart';

class LifeStyleEditingMenu extends StatefulWidget {
  final ConfigurationManager configManager;
  const LifeStyleEditingMenu({super.key, required this.configManager});

  @override
  _LifeStyleEditingState createState() => _LifeStyleEditingState();
}

class _LifeStyleEditingState extends State<LifeStyleEditingMenu> {
  late ConfigurationManager configManager;

  @override
  void initState() {
    super.initState();
    configManager = widget.configManager;
  }

  List<List<Task>> _allLifeStyles = [];
  List<Task> _lifeStyle = List<Task>.generate(
      24, (index) => SleepTask(name: "sommeil", durationInHours: 1));

  void _updateLifeStyle(int id, Task task) {
    setState(() {
      _lifeStyle[id] = task;
    });
  }

  void _confirmLifeStyle() {
    setState(() {
      _allLifeStyles.add(List<Task>.from(_lifeStyle));
      configManager.updateLifeStyle(_allLifeStyles.last);
      _lifeStyle = List<Task>.generate(
          24, (index) => SleepTask(name: "sommeil", durationInHours: 1));
    });
    Navigator.pop(context);
  }

  void _confirmLifeStyleEditing(int index) {
    setState(() {
      _allLifeStyles[index] = (List<Task>.from(_lifeStyle));
      _lifeStyle = List<Task>.generate(
          24, (index) => SleepTask(name: "sommeil", durationInHours: 1));
    });
    Navigator.pop(context);
  }

  Widget _setRender() {
    List<Widget> render = <Widget>[];
    for (int i = 0; i < 24; i++) {
      double dx = (i % 12) * 58.0;
      double dy = (i ~/ 12) * 58.0;
      render.add(LifestyleSlot(
          Offset(dx + 2, dy + 2),
          SleepTask(name: "sommeil", durationInHours: 1),
          i,
          _lifeStyle,
          _updateLifeStyle));
    }
    return Stack(children: render);
  }

  Widget _setAllLifeStylesRender() {
    if (_allLifeStyles.isEmpty) {
      return Container(); // Return an empty container if there are no lifestyles
    }
    List<Widget> render = <Widget>[];
    for (int j = 0; j < _allLifeStyles.length; j++) {
      render.add(Positioned(
        top: j * 140.0, // Adjusted top position to add padding
        left: 0,
        child: Text(
          'Mode de vie ${j + 1}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));

      //Boutons d'édition et de suppression
      render.add(Positioned(
        top: j * 140.0 + 20.0, // Adjusted top position to add padding
        right: 0,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _submitFeedbackEditing(j);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _allLifeStyles.removeAt(j);
                });
              },
            ),
          ],
        ),
      ));

      for (int i = 0; i < 24; i++) {
        double dx = (i % 12) * 58.0;
        double dy = (i ~/ 12) * 58.0 +
            (j * 140.0) +
            20.0; // Adjust dy for each lifestyle and add padding
        render.add(LifestyleSlot(
            Offset(dx + 2, dy + 2), _allLifeStyles[j][i], i, _allLifeStyles[j],
            (id, task) {
          setState(() {
            _allLifeStyles[j][id] = task;
          });
        }));
      }
    }
    double containerHeight = (_allLifeStyles.length * 140.0) +
        20.0; // Calculate container height + 20 pixels for margin
    return Container(
      width: double.infinity,
      height: containerHeight,
      child: Stack(children: render),
    );
  }

  void _submitFeedback() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // This makes sure the dialog cannot be dismissed by clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 700,
            height: 700,
            child: Stack(
              children: [
                _setRender(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _confirmLifeStyle,
                      child: const Text('Confirmer le style de vie'),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 425,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text("Drag and drop tasks to set your lifestyle"),
                  ),
                ),
                DragTask(initPos: const Offset(0.0, 240.0), taskID: 1),
                DragTask(initPos: const Offset(120.0, 240.0), taskID: 2),
                DragTask(initPos: const Offset(240.0, 240.0), taskID: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitFeedbackEditing(int index) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // This makes sure the dialog cannot be dismissed by clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 700,
            height: 700,
            child: Stack(
              children: [
                _setRender(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _confirmLifeStyleEditing(index),
                      child: const Text('Confirmer le style de vie'),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 425,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text("Drag and drop tasks to set your lifestyle"),
                  ),
                ),
                DragTask(initPos: const Offset(0.0, 240.0), taskID: 1),
                DragTask(initPos: const Offset(120.0, 240.0), taskID: 2),
                DragTask(initPos: const Offset(240.0, 240.0), taskID: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    child: const Text('Ajouter un style de vie'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _setAllLifeStylesRender(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DragTask extends StatefulWidget {
  final Offset initPos;
  final int taskID;
  final Task task;

  DragTask({required this.initPos, required this.taskID})
      : task = selectTask(taskID);

  static Task selectTask(int taskID) {
    switch (taskID) {
      case 1:
        return SleepTask(name: "sommeil", durationInHours: 1);
      case 2:
        return EatTask(
            name: "repas", durationInHours: 1, foodType: ["pasta", "salad"]);
      case 3:
        return RunTask(name: "course", durationInHours: 1, targetDistance: 1.0);
      default:
        return SleepTask(name: "sommeil", durationInHours: 1);
    }
  }

  @override
  DragTaskState createState() => DragTaskState();
}

class DragTaskState extends State<DragTask> {
  Offset position = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable<int>(
        data: widget.taskID,
        feedback: Container(
          width: 136.0,
          height: 136.0,
          color: widget.task.color.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.task.name,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                widget.task.icon,
              ],
            ),
          ),
        ),
        childWhenDragging: Container(
          width: 100.0,
          height: 100.0,
          color: Colors.grey,
          child: Center(
            child: Text(widget.task.name),
          ),
        ),
        child: Container(
          width: 100.0,
          height: 100.0,
          color: widget.task.color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.task.name,
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              widget.task.icon,
            ],
          ),
        ),
        onDragEnd: (details) {
          setState(() {
            position = widget.initPos;
          });
        },
      ),
    );
  }
}

class LifestyleSlot extends StatefulWidget {
  final List<Task> lifeStyle;
  final int id;
  final Offset initPos;
  final Task task;
  final Function(int, Task) onUpdate; // Ajoutez cette ligne

  const LifestyleSlot(this.initPos, this.task, this.id, this.lifeStyle,
      this.onUpdate); // Modifiez cette ligne

  @override
  _LifestyleSlotState createState() => _LifestyleSlotState();
}

class _LifestyleSlotState extends State<LifestyleSlot> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.initPos.dx,
      top: widget.initPos.dy,
      child: DragTarget<int>(
        onAcceptWithDetails: (taskID) {
          setState(() {
            widget.onUpdate(widget.id, DragTask.selectTask(taskID.data));
          });
        },
        builder: (BuildContext context, List<int?> accepted,
            List<dynamic> rejected) {
          Task currentTask = widget.lifeStyle[widget.id];
          return Container(
            width: 58.0,
            height: 58.0,
            color: currentTask.color,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currentTask.name,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  currentTask.icon,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
