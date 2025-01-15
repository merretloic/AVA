import 'package:flutter/material.dart';
import 'package:ava_frontend/optionsMenu.dart';
import 'package:ava_frontend/lifeStyleSummary.dart';
import 'package:ava_frontend/tasks.dart';
import 'package:ava_frontend/configurationManager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.config});
  final String title;
  final ConfigurationManager config;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final ConfigurationManager configManager;
  String get style => configManager.style;

  @override
  void initState() {
    super.initState();
    configManager = widget.config;
    print(configManager.style); // Ajout de l'instruction print
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _optionMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionsMenu(configManager: configManager),
      ),
    );
  }

  void _lifeStyleSummaryMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LifeStyleSummaryMenu(configManager: configManager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'settings',
                  onPressed: () {
                    _optionMenu();
                  },
                  tooltip: 'Settings',
                  child: const Icon(Icons.settings),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'lifestyle',
                  onPressed: () {
                    _lifeStyleSummaryMenu();
                  },
                  tooltip: 'Favorite',
                  child: const Icon(Icons.favorite),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ValueListenableBuilder<String>(
                  valueListenable: configManager.styleNotifier,
                  builder: (context, value, child) {
                    return Text('Il fait : $value');
                  },
                ),
                ValueListenableBuilder<List<Task>>(
                  valueListenable: configManager.currentLifeStyle,
                  builder: (context, value, child) {
                    return Text(
                        'Tâche actuelle : ${value[DateTime.now().hour].name}');
                  },
                ),
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'increment',
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
