import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  WebSocketService({
    required void Function(String data) onMessage,
    required void Function(Object error) onError,
  }) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8081/ws'),
      );

      _channel.stream.listen(
        (data) => onMessage(data.toString()),
        onError: (error) {
          print('Erreur WebSocket : $error');
          if (error is WebSocketChannelException) {
            print('Détails de l\'exception : ${error.message}');
          }
          onError(error);
        },
        onDone: () {
          print('Connexion WebSocket fermée.');
        },
      );
    } catch (e) {
      print('Exception lors de la connexion WebSocket : $e');
      onError(e);
    }
  }

  void sendSleepData(double hours) {
    if (_channel.closeCode != null) {
      print('Erreur : le canal WebSocket est déjà fermé.');
      return;
    }
    final message = jsonEncode({
      "type": "get_sleep_state",
      "data": hours,
    });
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}