import 'package:ava_frontend/lifeStyleEditing.dart';
import 'package:flutter/material.dart';
import 'optionsMenu.dart';
import 'configurationManager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConfigurationManager config = ConfigurationManager();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', config: config),
    );
  }
}

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

  void _lifeStyleEditingMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LifeStyleEditingMenu(),
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
                    _lifeStyleEditingMenu();
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
