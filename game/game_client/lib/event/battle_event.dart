
import 'dart:async';

import 'package:bonfire/base/game_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 定义事件
sealed class BattleLogEvent {}

class AddLogEvent extends BattleLogEvent {
  final String log;
  AddLogEvent(this.log);
}

class ClearLogEvent extends BattleLogEvent {

}

// 定义状态
class BattleLogState {
  final List<String> logs;
  BattleLogState(this.logs);
}

class BattleLogBloc extends Bloc<BattleLogEvent, BattleLogState> {

  BattleLogBloc() : super(BattleLogState([])) {
    on<AddLogEvent>((event, emit) {
      final updatedLogs = List<String>.from(state.logs)..add(event.log);
      emit(BattleLogState(updatedLogs));
    });
    on<ClearLogEvent>((event, emit) {
      emit(BattleLogState([]));
    });
  }

}