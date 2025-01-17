import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ava/screens/authenticate/authenticate_screen.dart';
import 'package:ava/configurationManager.dart';
import 'package:ava/screens/home/home_screen.dart';
import 'package:ava/models/user.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationManager config = ConfigurationManager();
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AuthenticateScreen();
    } else {
      return MyHomePage(title: 'Flutter Demo Home Page', config: config);
    }
  }
}