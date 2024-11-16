import 'package:bonfire/bonfire.dart';
import 'critter_sprite_sheet.dart';

class Critter extends SimpleNpc with BlockMovementCollision, RandomMovement {
  bool enableBehaviors = true;
  double tileSize;

  Critter(Vector2 position, {this.tileSize = 16})
      : super(
          animation: CritterSpriteSheet.simpleDirectionAnimation,
          position: position,
          size: Vector2.all(tileSize * 0.8),
          speed: tileSize,
        );

  @override
  void update(double dt) {
    if (!enableBehaviors) return;

    seeAndMoveToPlayer(
      closePlayer: (player) {},
      observed: () {},
      radiusVision: tileSize * 1.5,
      notObserved: () {
        runRandomMovement(
          dt,
          speed: speed / 10,
          maxDistance: (tileSize),
        );
        return false;
      },
    );
    super.update(dt);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(
          tileSize * 0.4,
          tileSize * 0.4,
        ),
        position: Vector2(
          tileSize * 0.2,
          tileSize * 0.2,
        ),
      ),
    );
    return super.onLoad();
  }
}
