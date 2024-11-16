import 'package:bonfire/bonfire.dart';
import 'package:bonfire_multiplayer/npc/wizard_sprite_sheet.dart';
import 'package:bonfire_multiplayer/spritesheets/players_spritesheet.dart';
import 'package:bonfire_multiplayer/util/player_skin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_events/shared_events.dart';

class Wizard extends SimpleNpc with BlockMovementCollision, TapGesture {
  double lastZoom = 1.0;
  double tileSize;
  ComponentStateModel state;

  Wizard(Vector2 position, {this.tileSize = 16, required this.state})
      : super(
          animation: WizardSpriteSheet.simpleDirectionAnimation,
          position: position,
          size: Vector2.all(tileSize * 0.8),
          speed: tileSize * 1.6,
        );

  void execShowTalk(GameComponent first) {
    lastZoom = gameRef.camera.zoom;
    gameRef.camera.moveToTargetAnimated(
      target: first,
      effectController: EffectController(
        duration: 0.5,
        curve: Curves.easeInOut,
      ),
      zoom: 2,
      onComplete: () {
        _showTalk(PlayerSkin.fromName(state.properties['skin']));
      },
    );
  }

  @override
  void onTap() {
    execShowTalk(this);
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
          tileSize * 0.4,
        ),
      ),
    );
    return super.onLoad();
  }

  void _showTalk(PlayerSkin skin) {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            const TextSpan(
              text:
                  ' Would you tell me, please ...  which way I ought to go from here? ',
            )
          ],
          person: SizedBox(
            width: 100,
            height: 100,
            child: PlayersSpriteSheet.idle(skin.path, SpritSheetDirection.right).asWidget(),
          ),
        ),
        Say(
          text: [
            const TextSpan(
              text: 'That depends a good deal on where you want to get to.',
            ),
          ],
          person: SizedBox(
            width: 100,
            height: 100,
            child: WizardSpriteSheet.idle.asWidget(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            const TextSpan(
              text: ' I don\'t much care where. ',
            ),
          ],
          person: SizedBox(
            width: 100,
            height: 100,
            child: PlayersSpriteSheet.idle(skin.path, SpritSheetDirection.right).asWidget(),
          ),
        ),
        Say(
          text: [
            const TextSpan(
              text: 'Then it doesn\'t much matter which way you go.',
            ),
          ],
          person: SizedBox(
            width: 100,
            height: 100,
            child: WizardSpriteSheet.idle.asWidget(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onClose: () {
        gameRef.camera.moveToPlayerAnimated(
          effectController: EffectController(
            duration: 0.5,
            curve: Curves.easeInOut,
          ),
          zoom: lastZoom,
        );
      },
      onFinish: () {},
      logicalKeyboardKeysToNext: [
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.enter
      ],
    );
  }
}
