import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire_multiplayer/components/my_player/my_player.dart';
import 'package:bonfire_multiplayer/components/my_player/player_mixin.dart';
import 'package:bonfire_multiplayer/components/my_remote_player/my_remote_player.dart';
import 'package:bonfire_multiplayer/dummy/players_dialog.dart';
import 'package:bonfire_multiplayer/dummy/potion_life.dart';
import 'package:flutter/material.dart';
import 'package:shared_events/shared_events.dart';

import '../util/common_sprite_sheet.dart';
import '../util/player_skin.dart';

class Battle extends GameDecoration with TapGesture, Vision {
  bool _observedPlayer = false;
  double tileSize = 16;
  late TextPaint _textConfig;
  List<ComponentStateModel> players = [];

  Battle(Vector2 position, this.players, {this.tileSize = 16})
      : super.withAnimation(
          animation: CommonSpriteSheet.chestAnimated,
          size: Vector2.all(tileSize * 0.6),
          position: position,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: width / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.player != null && checkInterval('SeepLayr', 500, dt)) {
      seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!_observedPlayer) {
            _observedPlayer = true;
            _showEmote();
          }
        },
        notObserved: () {
          _observedPlayer = false;
        },
        radiusVision: tileSize,
      );
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_observedPlayer) {
      _textConfig.render(
        canvas,
        'Touch me !!',
        Vector2(width / -1.5, -height),
      );
    }
  }

  @override
  void onTap() {
    if (_observedPlayer) {
      //_addPotions();
      _addFightDialog();
      removeFromParent();
    }
  }

  @override
  void onTapCancel() {}

  _addFightDialog() {
    PlayerCharacter? player = gameRef.player as PlayerCharacter;
    List<PlayerCharacter> players = gameRef.visibles().whereType<MyRemotePlayer>().map<PlayerCharacter>((e) => e as PlayerCharacter).toList();
    showModalBottomSheet(context: gameRef.context, builder: (_){
      return PlayersDialog(player: player!, remotePlayers: players);
    });
  }

  _confirmFight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('发起主动挑战？'),
          content: Text('即将开启一次激烈战斗！'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('开打'),
              onPressed: () {
                // 在这里添加确定按钮的逻辑
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addPotions() {
    var p1 = position.translated(width * 2, height * -1.5);
    gameRef.add(
      PotionLife(
        p1,
        10,
      ),
    );

    var p2 = position.translated(width * 2, height * 2);
    gameRef.add(
      PotionLife(
        p2,
        10,
      ),
    );

    _addSmokeExplosion(p1);
    _addSmokeExplosion(p2);
  }

  void _addSmokeExplosion(Vector2 position) {
    gameRef.add(
      AnimatedGameObject(
        animation: CommonSpriteSheet.smokeExplosion,
        position: position,
        size: Vector2.all(tileSize * 0.5),
        loop: false,
      ),
    );
  }

  void _showEmote() {
    add(
      AnimatedGameObject(
        animation: CommonSpriteSheet.emote,
        size: size,
        position: size / -2,
        loop: false,
      ),
    );
  }
}
