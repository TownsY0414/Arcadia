import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../event/battle_event.dart';


class BattleList extends GameDecoration{
  double tileSize = 16;
  BattleLogBloc battleLogBloc;

  BattleList(Vector2 position, this.battleLogBloc, {this.tileSize = 16})
      : super(
    size: Vector2.all(tileSize * 0.6),
    position: position,
  );

  @override
  void update(double dt) {
    if (gameRef.player != null && checkInterval('update battle', 500, dt)) {
      //print("update BattleList>>>>>>>>");
    }
    super.update(dt);
  }

  @override
  void onMount() {
    battleLogBloc.stream.listen((state) => {
      if(state.logs.length == 1) {
        showModalBottomSheet(context: context, builder: (_) {
          return Material(type: MaterialType.card, child: Container(decoration: const BoxDecoration(color: Colors.white), child: BlocBuilder<BattleLogBloc, BattleLogState>(bloc: battleLogBloc, builder: (context, state) {
            return ListView.builder(itemBuilder: (_, index) {
              return Text(state.logs[index]);
            }, itemCount: state.logs.length);
          })));
        }).then((_){
          battleLogBloc.add(ClearLogEvent());
        })
      }
    });
    super.onMount();
  }
}