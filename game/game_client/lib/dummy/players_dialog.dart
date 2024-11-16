
import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire_multiplayer/components/my_player/player_mixin.dart';
import 'package:flutter/material.dart';

import '../components/my_player/skills.dart';

class PlayersDialog extends StatefulWidget {

  final PlayerCharacter player;
  final List<PlayerCharacter> remotePlayers;

  const PlayersDialog({super.key, required this.player, required this.remotePlayers});

  @override
  State<StatefulWidget> createState() {
    return _PlayersDialogState();
  }
}

class _PlayersDialogState extends State<PlayersDialog> {

  @override
  Widget build(BuildContext context) {
     return Material(type: MaterialType.transparency, child: Container(
       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
       child: Column(children: [
         Stack(children: [
           Row(children: [
             Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("对周围玩家发起挑战", style: TextStyle(fontWeight: FontWeight.bold))),
           ],mainAxisAlignment: MainAxisAlignment.center),
           Positioned(top: 0, right: 0, child: IconButton(onPressed: (){
             Navigator.of(context).pop();
           }, icon: Icon(Icons.clear)))
         ]),
         Expanded(child: ListView(children: [
           if(widget.remotePlayers.isEmpty)Text("周围暂时无玩家"),
           ...widget.remotePlayers.map<ListTile>((player) {
             final path = player.skinPath;
             return ListTile(
               leading: FutureBuilder(
                 future: Sprite.load(
                   '$path',
                   srcSize: Vector2.all(32),
                   srcPosition: Vector2(0, 32),
                 ),
                 builder: (context, snapshot) {
                   if (!snapshot.hasData) {
                     return const SizedBox();
                   }
                   return Card(
                     color: Colors.green,
                     child: SizedBox(
                       width: 30,
                       height: 30,
                       child: snapshot.data!.asWidget(),
                     ),
                   );
                 },
               ),
               title: Text(player.name),
               trailing: TextButton(child: Text("挑战"), onPressed: () {
                 Navigator.of(context).pop();
                 // _confirmFight();

                 final my = widget.player;
                 final other = player;

                 // for(var i = 0; i < 6+Random().nextInt(50); i++) {
                 //   my.addAttrPoints();
                 // }
                 // for(var i = 0; i < 6+Random().nextInt(40); i++) {
                 //   other.addAttrPoints();
                 // }

                 PlayerCharacter first;
                 PlayerCharacter second;
                 if(my.luckVal > other.luckVal) {
                   first = my;
                   second = other;
                 } else {
                   first = other;
                   second = my;
                 }

                 if(!first.isAlive()) {
                   first.onLogCall(myPrint("${first.name} 已经被击败了"));
                   return;
                 }

                 if(!second.isAlive()) {
                   first.onLogCall(myPrint("${second.name} 已经被击败了"));
                   return;
                 }

                 first.onLogCall(myPrint("攻击开始"));
                 while (first.isAlive() && second.isAlive()) {
                   first.attack(second);
                   if (!second.isAlive()) {
                     first.onLogCall(myPrint('${second.name} 被击败了！'));
                     break;
                   } else if(!first.isAlive()){
                     first.onLogCall(myPrint('${first.name} 被击败了！'));
                     break;
                   }

                   second.attack(first);
                   if (!first.isAlive()) {
                     first.onLogCall(myPrint('${first.name} 被击败了！'));
                     break;
                   } else if (!second.isAlive()) {
                     first.onLogCall(myPrint('${second.name} 被击败了！'));
                     break;
                   }
                 }

               }),
             );
           }).toList()
         ]))
       ]),
     ));
  }

}