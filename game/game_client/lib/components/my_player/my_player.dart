import 'package:bonfire/bonfire.dart';
import 'package:bonfire_bloc/bonfire_bloc.dart';
import 'package:bonfire_multiplayer/components/my_player/bloc/my_player_bloc.dart';
import 'package:bonfire_multiplayer/event/battle_event.dart';
import 'package:bonfire_multiplayer/spritesheets/players_spritesheet.dart';
import 'package:bonfire_multiplayer/util/extensions.dart';
import 'package:bonfire_multiplayer/util/name_bottom.dart';
import 'package:bonfire_multiplayer/util/player_skin.dart';
import 'package:flutter/material.dart';

import 'player_mixin.dart';

class MyPlayer extends PlayerCharacter
    with
        BlockMovementCollision,
        WithNameBottom,
        UseLifeBar,
        BonfireBlocListenable<MyPlayerBloc, MyPlayerState> {

  JoystickMoveDirectional? _joystickDirectional;
  bool sendedIdle = false;


  MyPlayer({
    required BattleLogBloc block,
    required super.position,
    required String name,
    required PlayerSkin skin,
    Direction? initDirection,
    super.speed,
  }) : super(
          battleLogBloc: block,
          name: name,
          skinPath: skin.path,
          size: Vector2.all(32),
          animation: PlayersSpriteSheet.simpleAnimation(skin.path),
          initDirection: initDirection ?? Direction.down,
        ) {
    this.name = name;

    setupLifeBar(
      borderRadius: BorderRadius.circular(2),
      borderWidth: 2,
    );
  }

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (isMounted) {
      _joystickDirectional = event.directional;
    }

    // comments this part to not move the player
    // super.onJoystickChangeDirectional(event);
  }

  @override
  void update(double dt) {
    // sent move state
    _sendMoveState();
    super.update(dt);
  }

  @override
  onCharacterStateChanged(CharacterState state) {
     bloc.add(UpdateMyCharacterStateEvent(state: state));
  }

  void _sendMoveState() {
    // send move state if not stoped
    if (_joystickDirectional == JoystickMoveDirectional.IDLE) {
      if (!sendedIdle) {
        sendedIdle = true;
        _sendMove();
      }
    } else if (_joystickDirectional != null) {
      sendedIdle = false;
      _sendMove();
    }
  }

  @override
  void onNewState(MyPlayerState state) {
    if (state.position.distanceTo(position) > 4) {
      add(
        MoveEffect.to(
          state.position,
          EffectController(duration: 0.05),
        ),
      );
    }
    if (state.direction != null) {
      moveFromDirection(state.direction!.toDirection());
    } else {
      lastDirection = state.lastDirection.toDirection();
      stopMove(forceIdle: true);
    }
    super.onNewState(state);
  }

  void _sendMove() {
    bloc.add(
      UpdateMoveStateEvent(
        position: position,
        direction: _joystickDirectional?.toMoveDirection(),
      ),
    );
  }

  @override
  void onRemove() {
    bloc.add(DisposeEvent());
    super.onRemove();
  }

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(size: size / 2, position: size / 4));
    return super.onLoad();
  }

  @override
  void onRemoveLife(double life) {
    showDamage(
      life,
      config: TextStyle(
        fontSize: width / 3,
        color: Colors.red,
      ),
    );
    super.onRemoveLife(life);
  }
}
