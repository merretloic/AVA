import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  WebSocketService({
    required void Function(String data) onMessage,
    required void Function(Object error) onError,
  }) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8081/ws'),
    );

    _channel.stream.listen(
      (data) => onMessage(data.toString()),
      onError: onError,
    );
  }

  void sendSleepData(double hours) {
    final message = {
      "type": "get_sleep_state",
      "data": hours,
    };
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}