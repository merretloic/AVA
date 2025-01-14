import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ava/services/authentication.dart';
import 'package:ava/models/user.dart';
import 'package:ava/screens/splashscreen_wrapper.dart';
import 'package:ava/firebase_options.dart';
import 'package:ava/screens/home/home_screen.dart';
import 'package:ava/screens/authenticate/authenticate_screen.dart';
import 'package:ava/screens/authenticate/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          '/home': (context) => HomeScreen(),
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