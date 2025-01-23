import 'package:ava/services/configurationManager.dart';
import 'package:flutter/material.dart';
import 'package:ava/services/websocket_service.dart';

class FormPage extends StatefulWidget {
  final ConfigurationManager configManager;
  const FormPage({super.key, required this.configManager});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _ageController = TextEditingController();
  final _sexeController = TextEditingController();
  final _poidsController = TextEditingController();
  final _sommeilController = TextEditingController();
  final _activiteController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _eauController = TextEditingController();
  final _freqCardiaqueController = TextEditingController();
  final _vitamineDController = TextEditingController();
  final _tempsExpositionController = TextEditingController();
  final _surfaceExposeeController = TextEditingController();
  late WebSocketService _webSocketService;
  String _response = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _webSocketService = WebSocketService(
      onMessage: (data) {
        setState(() {
          _response = data;
          widget.configManager.conseilsNotifier.value = data;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _response = error;
          _isLoading = false;
        });
      },
    );
    _webSocketService.connect();
  }

  void _sendHealthData() {
    if (_ageController.text.isEmpty ||
        _sexeController.text.isEmpty ||
        _poidsController.text.isEmpty ||
        _sommeilController.text.isEmpty ||
        _activiteController.text.isEmpty ||
        _caloriesController.text.isEmpty ||
        _eauController.text.isEmpty ||
        _freqCardiaqueController.text.isEmpty ||
        _vitamineDController.text.isEmpty ||
        _tempsExpositionController.text.isEmpty ||
        _surfaceExposeeController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    _webSocketService.sendHealthData(
      age: int.tryParse(_ageController.text) ?? 0,
      sexe: _sexeController.text,
      poids: double.tryParse(_poidsController.text) ?? 0,
      sommeil: double.tryParse(_sommeilController.text) ?? 0,
      activite: double.tryParse(_activiteController.text) ?? 0,
      calories: double.tryParse(_caloriesController.text) ?? 0,
      eau: double.tryParse(_eauController.text) ?? 0,
      frequenceCardiaque: double.tryParse(_freqCardiaqueController.text) ?? 0,
      vitamineD: double.tryParse(_vitamineDController.text) ?? 0,
      tempsExposition: double.tryParse(_tempsExpositionController.text) ?? 0,
      surfaceExposee: _surfaceExposeeController.text,
    );
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    _ageController.dispose();
    _sexeController.dispose();
    _poidsController.dispose();
    _sommeilController.dispose();
    _activiteController.dispose();
    _caloriesController.dispose();
    _eauController.dispose();
    _freqCardiaqueController.dispose();
    _vitamineDController.dispose();
    _tempsExpositionController.dispose();
    _surfaceExposeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Health Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age (années)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sexeController,
                decoration: InputDecoration(labelText: 'Sexe (M/F)'),
              ),
              TextField(
                controller: _poidsController,
                decoration: InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sommeilController,
                decoration: InputDecoration(labelText: 'Sommeil (heures)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _activiteController,
                decoration: InputDecoration(labelText: 'Activité (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(
                    labelText: 'Calories (kcal consommé par jour)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _eauController,
                decoration: InputDecoration(labelText: 'Eau (liters)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _freqCardiaqueController,
                decoration:
                    InputDecoration(labelText: 'Fréquence Cardiaque (bpm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _vitamineDController,
                decoration: InputDecoration(labelText: 'Vitamine D (µg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _tempsExpositionController,
                decoration:
                    InputDecoration(labelText: 'Temps d\'Exposition (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _surfaceExposeeController,
                decoration: InputDecoration(
                    labelText: 'Surface Exposée (Petite, Moyenne, Grande)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendHealthData,
                child: _isLoading ? CircularProgressIndicator() : Text('Send'),
              ),
              SizedBox(height: 24),
              if (_response.isNotEmpty)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(_response),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
