import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire_multiplayer/components/my_player/player_mixin.dart';
import 'package:flutter/cupertino.dart';
import '../util/common_sprite_sheet.dart';

class PotionLife extends GameDecoration with Sensor<Player>, Movement {
  final double life;
  double _lifeDistributed = 0;
  double tileSize = 16;

  PotionLife(Vector2 position, this.life, {Vector2? size, this.tileSize = 16})
      : super.withSprite(
          sprite: CommonSpriteSheet.potionLifeSprite,
          position: position,
          size: size ?? Vector2.all(tileSize * 0.5),
        );

  @override
  void onContact(Player component) {
    debugPrint("lifeDistributed: $_lifeDistributed, life: $life");
    // if (_lifeDistributed < life) {
    //   double newLife = life * 1 - _lifeDistributed;
    //   _lifeDistributed += newLife;
    //   component.addLife(newLife.roundToDouble());
    // }

    for(int i = 0; i < 60 + Random().nextInt(100); i++) {
      (component as PlayerCharacter).addAttrPoints();
    }

    removeFromParent();
    super.onContact(component);
  }

  @override
  void onMount() {
    gameRef.generateValues(
      const Duration(seconds: 1),
      onChange: (value) {
        spriteOffset = Vector2(0, 5 * -value);
      },
      infinite: true,
    );
    super.onMount();
  }
}
