import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ava_frontend/screens/authenticate/authenticate_screen.dart';
import 'package:ava_frontend/configurationManager.dart';
import 'package:ava_frontend/screens/home/home_screen.dart';
import 'package:ava_frontend/models/user.dart';

class SplashScreenWrapper extends StatelessWidget {
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