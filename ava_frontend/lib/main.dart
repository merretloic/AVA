import 'package:flutter/material.dart';
import 'package:ava_frontend/screens/home/home_screen.dart';
import 'package:ava_frontend/screens/authenticate/verification_screen.dart';
import 'package:ava_frontend/screens/authenticate/authenticate_screen.dart';
import 'package:ava_frontend/screens/splashscreen_wrapper.dart';
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
      home: SplashScreenWrapper(),
        routes: {
          '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page', config: config),
          '/authenticate': (context) => AuthenticateScreen(),
          '/verify': (context) => VerificationScreen(),
        },
    );
  }
}