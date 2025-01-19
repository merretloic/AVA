import 'package:ava_frontend/lifeStyleSummary.dart';
import 'package:ava_frontend/tasks.dart';
import 'package:flutter/material.dart';
import 'optionsMenu.dart';
import 'configurationManager.dart';
import 'quiz_page.dart';
import 'carousel.dart'; // Import du fichier Carousel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  late final ConfigurationManager configManager;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    configManager = widget.config;
    currentIndex = DateTime.now().hour;

    configManager.currentLifeStyle.addListener(() {
      setState(() {
        currentIndex = DateTime.now().hour;
      });
    });
  }

  void _navigateToPreviousTask() {
    setState(() {
      currentIndex = (currentIndex - 1 + 24) % 24;
    });
  }

  void _navigateToNextTask() {
    setState(() {
      currentIndex = (currentIndex + 1) % 24;
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
        backgroundColor: Colors.black, // Couleur noire pour la barre
        toolbarHeight: 80, // Hauteur de la barre augmentée
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Chemin du logo
              height: 50, // Hauteur agrandie
              width: 50, // Largeur agrandie
            ),
            const SizedBox(width: 10), // Espacement entre l'image et le texte
            const Text(
              "AVA",
              style: TextStyle(
                color: Colors.white, // Texte en blanc
                fontSize: 24, // Taille du texte augmentée
                fontWeight: FontWeight.bold, // Texte en gras
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30), // Espace supplémentaire pour descendre les boutons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'settings',
                    backgroundColor: Colors.black, // Fond noir
                    onPressed: _optionMenu,
                    tooltip: 'Settings',
                    child: const Icon(Icons.settings, color: Colors.white), // Icône blanche
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'lifestyle',
                    backgroundColor: Colors.black, // Fond noir
                    onPressed: _lifeStyleSummaryMenu,
                    tooltip: 'Lifestyle Summary',
                    child: const Icon(Icons.favorite, color: Colors.white), // Icône blanche
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Carousel(
                configManager: configManager,
                currentIndex: currentIndex,
                onPrevious: _navigateToPreviousTask,
                onNext: _navigateToNextTask,
              ),
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
