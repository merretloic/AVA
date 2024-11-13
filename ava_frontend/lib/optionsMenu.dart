import 'dart:math';
import 'package:flutter/material.dart';

class OptionsMenu extends StatefulWidget {
  const OptionsMenu({super.key});

  @override
  _OptionsMenuState createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  String _options = '';
  String _optionsResult = '';
  final _optionsController = TextEditingController();

  void _generateOptions() {
    setState(() {
      _optionsResult = '';
      final options = _options.split('\n');
      final random = Random();
      final selectedOption = options[random.nextInt(options.length)];
      _optionsResult = selectedOption;
    });
  }

  void _clearOptions() {
    setState(() {
      _options = '';
      _optionsResult = '';
      _optionsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _optionsController,
              decoration: const InputDecoration(
                labelText: 'Enter options (one per line)',
              ),
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  _options = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _generateOptions,
              child: const Text('Generate Option'),
            ),
            const SizedBox(height: 16.0),
            if (_optionsResult.isNotEmpty)
              Text(
                'Selected Option: $_optionsResult',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _clearOptions,
              child: const Text('Clear Options'),
            ),
          ],
        ),
      ),
    );
  }
}
