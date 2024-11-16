import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import '../components/my_player/my_player.dart';
import '../util/common_sprite_sheet.dart';

class EventTrigger extends GameDecoration with Sensor {
  final String event;
  final Paint _paint;

  EventTrigger({
    required Vector2 position,
    required Vector2 size,
    required this.event,
  })  : _paint = Paint()..color = Colors.red.withOpacity(0.5), // 设置颜色和透明度
        super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(position.x / 10, position.y / 10, size.x * 4, size.y * 4),
      _paint,
    );
    // debugPrint("event trigger: render....pos:${position}, size: ${size}", );
  }

  @override
  void onContact(GameComponent component) {
    if (component is MyPlayer) {
      if (event == 'random_event') {
        _triggerRandomEvent();
      }
    }
  }

  void _triggerRandomEvent() {
    // 处理随机事件
    print('Random event triggered!');
  }
}


class SpikesComponent extends GameComponent with TapGesture {

  SpikesComponent();

  @override
  void onTapDownScreen(GestureEvent event) {
    gameRef.add(
      Spikes(Vector2(50, 120),/*event.worldPosition*/),
    );
    super.onTapDownScreen(event);
  }

  @override
  bool get isVisible => true;

  @override
  void onTap() {

  }
}

class Spikes extends GameDecoration with Sensor<MyPlayer> {
  Spikes(Vector2 position)
      : super.withAnimation(
    animation: CommonSpriteSheet.torchAnimated,
    size: Vector2.all(16),
    position: position,
    lightingConfig: LightingConfig(
      radius: 32,
      color: Colors.deepOrangeAccent.withOpacity(0.3),
      withPulse: true,
    ),
  ){
    // call this method to configure interval sensor check contact. default 100 milliseconds.
    setSensorInterval(100);
  }

  @override
  void onContact(MyPlayer component) {
    if (component is Player) {
      component.handleAttack(AttackOriginEnum.ENEMY, 10, 1);
    } else {
      component.handleAttack(AttackOriginEnum.PLAYER_OR_ALLY, 10, 1);
    }
    super.onContact(component);
  }

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(size: size / 1.5, position: size / 8.5, isSolid: true));
    return super.onLoad();
  }
}