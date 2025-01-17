import 'package:flutter/material.dart';
import 'configurationManager.dart';
import 'lifeStyleEditing.dart';

class LifeStyleSummaryMenu extends StatefulWidget {
  final ConfigurationManager configManager;
  const LifeStyleSummaryMenu({super.key, required this.configManager});

  @override
  _LifeStyleState createState() => _LifeStyleState();
}

class _LifeStyleState extends State<LifeStyleSummaryMenu> {
  late ConfigurationManager configManager;

  @override
  void initState() {
    super.initState();
    configManager = widget.configManager;
  }

  void _lifeStyleEditingMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LifeStyleEditingMenu(configManager: configManager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: const Text(
                    'Bilan de style de vie :',
                    style: TextStyle(fontSize: 32),
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _lifeStyleEditingMenu,
                    child: const Text('Editer style de vie'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Votre style de vie est sain à 78% !',
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Conseils d\'améliorations :',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sommeil',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Il est recommandé de dormir au moins 8 heures par jour, pensez à rajouter une heure de sommeil à votre style de vie.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Alimentation',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Essayez de manger plus de fruits et légumes pour une alimentation équilibrée.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red[100],
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Exercice',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Il est conseillé de faire au moins 30 minutes d\'exercice par jour.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
