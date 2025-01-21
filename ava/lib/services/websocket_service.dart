import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  final WebSocketChannel _channel;
  final Function(String) _onMessage;
  final Function(String) _onError;

  WebSocketService({
    required Function(String) onMessage,
    required Function(String) onError,
  })  : _onMessage = onMessage,
        _onError = onError,
        _channel = WebSocketChannel.connect(
          Uri.parse('ws://localhost:8081/ws'),
        );

  void connect() {
    _channel.stream.listen(
      (data) async {
        try {
          final parsed = jsonDecode(data.toString());
          final formattedResponse = _formatResponse(parsed);
          _onMessage(formattedResponse);
          await _saveToFirebase(formattedResponse);
        } catch (e) {
          _onError('Error parsing response');
        }
      },
      onError: (error) {
        _onError('Error: $error');
      },
    );
  }

  void sendHealthData({
    required int age,
    required String sexe,
    required double poids,
    required double sommeil,
    required double activite,
    required double calories,
    required double eau,
    required double frequenceCardiaque,
    required double vitamineD,
    required double tempsExposition,
    required String surfaceExposee,
  }) {
    final message = {
      "type": "get_recommendations",
      "data": {
        "age": age,
        "sexe": sexe,
        "poids": poids,
        "sommeil": sommeil,
        "activite": activite,
        "calories": calories,
        "eau": eau,
        "frequence_cardiaque": frequenceCardiaque,
        "vitamine_d": vitamineD,
        "temps_exposition": tempsExposition,
        "surface_exposee": surfaceExposee
      }
    };

    final jsonString = jsonEncode(message);
    print('Sending: $jsonString');
    _channel.sink.add(jsonString);
  }

  String _formatResponse(Map<String, dynamic> response) {
    List<Map<String, String>> formattedList = response.entries.map((entry) {
      return {
        "state": entry.key,
        "recommendations": entry.value.toString()
      };
    }).toList();

    return jsonEncode(formattedList);
  }

  Future<void> _saveToFirebase(String response) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('healthData')
          .doc(userId)
          .collection('records')
          .add({
        'response': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void dispose() {
    _channel.sink.close();
  }
}