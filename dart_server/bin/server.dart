import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> main() async {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(webSocketHandler(_echoWebSocket));

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

void _echoWebSocket(WebSocketChannel webSocket) {
  webSocket.stream.listen(
    (message) {
      webSocket.sink.add('Received: $message');
    },
    onDone: () => print('WebSocket closed'),
    onError: (error) => print('WebSocket error: $error'),
  );
}
