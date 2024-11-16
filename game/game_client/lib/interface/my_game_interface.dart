import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class MyGameInterface extends GameInterface {
  static const followerWidgetTestId = 'follower';

  @override
  void onMount() async {

    await add(InterfaceComponent(
      spriteUnselected: Sprite.load('blue_button1.png'),
      spriteSelected: Sprite.load('blue_button2.png'),
      size: Vector2(40, 40),
      id: 5,
      position: Vector2(kToolbarHeight, kToolbarHeight),
      selectable: true,
      onTapComponent: (selected) {
        _addFollowerWidgetExample(selected);
      },
    ));

    super.onMount();
  }

  void _addFollowerWidgetExample(bool selected) {
    if (!selected && FollowerWidget.isVisible(followerWidgetTestId)) {
      FollowerWidget.remove(followerWidgetTestId);
      return;
    }
    gameRef.player?.let((player) {
      FollowerWidget.show(
        identify: followerWidgetTestId,
        context: context,
        target: player,
        child: const TestWidget(size: Size(100, 50)),
      );
    });
  }
}

class TestWidget extends StatelessWidget {

  final Size? size;

  const TestWidget({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(type: MaterialType.transparency,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.3),
        border: Border.all(color: Colors.red, width: 0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {
          FollowerWidget.remove(
            MyGameInterface.followerWidgetTestId,
          );
        },
        child: const Text("I'm sorry!", style: TextStyle(color: Colors.black, fontSize: 8)),
      ),
    ),);
  }
}
