import 'package:flutter/material.dart';
import 'package:ava/optionsMenu.dart';
import 'package:ava/lifeStyleSummary.dart';
import 'package:ava/tasks.dart';
import 'package:ava/configurationManager.dart';
import 'package:ava/screens/quiz_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.config});
  final String title;
  final ConfigurationManager config;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ConfigurationManager configManager;
  String get style => configManager.style;

  @override
  void initState() {
    super.initState();
    configManager = widget.config;
    debugPrint(configManager.style); // Ajout de l'instruction debugPrint
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

  void _formMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(configManager: configManager),
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  Column(
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
                  const SizedBox(width: 200),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tâche : Repas',
                              style: TextStyle(fontSize: 32),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Aliments :\n- Dinde (200 gr)\n- Féculents (100 gr)\n- Légumes verts (200 gr)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 100),
                ],
              ),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          _formMenu();
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: configManager.isFormFilledNotifier,
          builder: (context, isFormFilled, child) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: isFormFilled
                    ? Colors.lightBlueAccent
                    : const Color.fromARGB(255, 255, 255, 121),
                border: Border.all(color: Colors.black),
              ),
              child: FractionallySizedBox(
                widthFactor: 2 / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      isFormFilled
                          ? 'Merci pour avoir remplis le formulaire !'
                          : 'Attention, vous n\'avez pas encore remplis votre formulaire pour la journée !',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}