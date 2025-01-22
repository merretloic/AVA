import 'package:flutter/material.dart';
import 'package:ava/optionsMenu.dart';
import 'package:ava/lifeStyleSummary.dart';
import 'package:ava/configurationManager.dart';
import 'package:ava/screens/quiz_page.dart';
import 'package:ava/carousel.dart';
import 'package:ava/form_page.dart';
import 'package:ava/services/websocket_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.config});
  final String title;
  final ConfigurationManager config;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ConfigurationManager configManager;
  late WebSocketService _webSocketService;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    configManager = widget.config;
    currentIndex = DateTime.now().hour;

    // Initialisation du service WebSocket
    _webSocketService = WebSocketService(
      onMessage: (data) {
        debugPrint('Message WebSocket reçu : $data');
        // Ajoutez ici le traitement du message reçu si nécessaire
      },
      onError: (error) {
        debugPrint('Erreur WebSocket : $error');
        // Ajoutez ici la gestion des erreurs si nécessaire
      },
    );

    // Listener pour mettre à jour l'index en fonction de l'heure
    configManager.currentLifeStyle.addListener(() {
      setState(() {
        currentIndex = DateTime.now().hour;
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose(); // Libère les ressources WebSocket
    super.dispose();
  }

  void _navigateToFormPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  Future<void> _sendDataToFirebase(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add(data);
      debugPrint('Données envoyées à Firebase : $data');
    } catch (e) {
      debugPrint('Erreur lors de l\'envoi à Firebase : $e');
    }
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
        backgroundColor: Colors.black,
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              "AVA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'settings',
                    backgroundColor: Colors.black,
                    onPressed: _optionMenu,
                    tooltip: 'Settings',
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'lifestyle',
                    backgroundColor: Colors.black,
                    onPressed: _lifeStyleSummaryMenu,
                    tooltip: 'Lifestyle Summary',
                    child: const Icon(Icons.favorite, color: Colors.white),
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
                onPrevious: () {
                  _navigateToPreviousTask();
                  _sendDataToFirebase({
                    'type': 'task_navigation',
                    'direction': 'previous',
                    'timestamp': DateTime.now(),
                  });
                },
                onNext: () {
                  _navigateToNextTask();
                  _sendDataToFirebase({
                    'type': 'task_navigation',
                    'direction': 'next',
                    'timestamp': DateTime.now(),
                  });
                },
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
                widthFactor: 0.9, // Adjusted to fit within the screen
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isFormFilled
                            ? 'Merci pour avoir remplis le formulaire !'
                            : 'Attention, vous n\'avez pas encore remplis votre formulaire pour la journée !',
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFormPage,
        tooltip: 'Envoyer des données au WebSocket',
        child: const Icon(Icons.send),
      ),
    );
  }
}
