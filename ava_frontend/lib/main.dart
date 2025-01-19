import 'package:ava_frontend/lifeStyleSummary.dart';
import 'package:flutter/material.dart';
import 'optionsMenu.dart';
import 'configurationManager.dart';
import 'quiz_page.dart';
import 'carousel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late ConfigurationManager config;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    config = ConfigurationManager();

    // Configuration initiale des notifications
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    debugPrint("Notifications initialized");
  }

  Future<void> _showNotification(String taskName) async {
    if (config.currentLifeStyle.value.isNotEmpty) {
      taskName = config.currentLifeStyle.value[DateTime.now().hour].name;
    } else {
      debugPrint("Tâche non trouvée ou configuration non initialisée.");
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Remplacez par un ID de canal valide
      'your_channel_name', // Remplacez par un nom de canal valide
      channelDescription: 'your_channel_description', // Ajoutez une description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Afficher une notification
    await flutterLocalNotificationsPlugin.show(
      0, // ID unique pour la notification
      'Task Reminder',
      'You have a pending task: $taskName',
      platformChannelSpecifics,
    );
    debugPrint("Notification shown: $taskName");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Lorsque l'application passe en arrière-plan
      debugPrint("App is in background");
      String taskName = config.currentLifeStyle.value[DateTime.now().hour].name;
      _showNotification('Tâche actuelle : $taskName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ava life assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Ava life assistant', config: config),
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
                    child: const Icon(Icons.settings,
                        color: Colors.white), // Icône blanche
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'lifestyle',
                    backgroundColor: Colors.black, // Fond noir
                    onPressed: _lifeStyleSummaryMenu,
                    tooltip: 'Lifestyle Summary',
                    child: const Icon(Icons.favorite,
                        color: Colors.white), // Icône blanche
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Column(
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
                ),
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
