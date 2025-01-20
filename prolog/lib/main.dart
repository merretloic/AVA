import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebSocketScreen(),
    );
  }
}

class WebSocketScreen extends StatefulWidget {
  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'), // Remplacez par l'adresse de votre serveur WebSocket
  );
  String _response = ''; // Variable pour stocker la réponse du serveur

  @override
  void dispose() {
    _channel.sink.close(); // Fermer la connexion WebSocket lorsque le widget est détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Réponse du serveur :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _response = snapshot.data.toString(); // Mettre à jour la réponse
                  }
                  return SingleChildScrollView(
                    child: Text(
                      _response.isNotEmpty ? _response : 'Aucune réponse reçue.',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Exemple d'envoi de message au serveur (ici tester_regles)
                _channel.sink.add('tester_regles');
              },
              child: Text('Envoyer une requête'),
            ),
          ],
        ),
      ),
    );
  }
}