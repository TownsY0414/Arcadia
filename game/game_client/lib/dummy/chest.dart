import 'package:bonfire/bonfire.dart';
import 'package:bonfire_multiplayer/dummy/potion_life.dart';

import '../util/common_sprite_sheet.dart';

class Chest extends GameDecoration with TapGesture, Vision {
  bool _observedPlayer = false;
  double tileSize = 16;
  late TextPaint _textConfig;

  Chest(Vector2 position, {this.tileSize = 16})
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
      _addPotions();
      removeFromParent();
    }
  }

  @override
  void onTapCancel() {}

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
