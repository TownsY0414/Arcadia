// ignore_for_file: strict_raw_type

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'src/core/game.dart';
import 'src/game/game_server.dart';
import 'src/game/maps/desert.dart';
import 'src/game/maps/florest.dart';
import 'src/game/maps/new_desert.dart';
import 'src/game/maps/test.dart';
import 'src/game/maps/test_desert.dart';
import 'src/infrastructure/logger/logger_logger.dart';
import 'src/infrastructure/logger/logger_provider.dart';
import 'src/infrastructure/websocket/polo_websocket.dart';
import 'src/infrastructure/websocket/websocket_provider.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

GameServer? game;
final LoggerProvider logger = LoggerLogger();

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final server = await PoloWebsocket().init(
    onClientConnect: onClientConnect,
    onClientDisconnect: onClientDisconnect,
  );
  game ??= GameServer(
    server: server,
    maps: [
      TestDesertMap(),
      //TestMap(),
      //NewDesertMap(),
      // FlorestMap(),
      //  DesertMap(),
    ],
  );
  await game!.start();

  return serve(
    handler.use(
      provider<Game>(
        (context) => game!,
      ),
    ).use(fromShelfMiddleware(
      shelf.corsHeaders(
        headers: {
          shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'http://192.168.31.247',
        },
      ),
    ),),
    ip,
    port,
  );
}

void onClientConnect(PoloClient client, WebsocketProvider websocket) {
  game?.enterClient(client);
}

void onClientDisconnect(PoloClient client) {
  game?.leaveClient(client);
}
