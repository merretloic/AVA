import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ava/services/authentication.dart';
import 'package:ava/models/user.dart';
import 'package:ava/screens/splashscreen_wrapper.dart';
import 'package:ava/screens/home/home_screen.dart';
import 'package:ava/screens/authenticate/authenticate_screen.dart';
import 'package:ava/screens/authenticate/verification_screen.dart';
import 'package:ava/services/configurationManager.dart';
import 'package:ava/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenWrapper(),
        routes: {
          '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
          '/authenticate': (context) => AuthenticateScreen(),
          '/verify': (context) => VerificationScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
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
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenWrapper(),
        routes: {
          '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
          '/authenticate': (context) => AuthenticateScreen(),
          '/verify': (context) => VerificationScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}