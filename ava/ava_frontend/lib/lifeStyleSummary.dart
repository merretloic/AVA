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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.',
                    style: TextStyle(fontSize: 16),
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
                border: Border.all(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
