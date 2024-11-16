import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import '../../dummy/player_battle_list.dart';
import '../../event/battle_event.dart';
import 'skills.dart';

class PlayerCharacter extends SimplePlayer with Hp, AttackPower, DefencePower, EvasionRate, AttrPoints, LuckValue, TriggerProbability, RandomGenerator{

  String name;
  String skinPath;

  List<Skill> ownSkills = [];
  late BattleLogBloc battleLogBloc;
  late CharacterState _state;

  // size: ,
  // animation: PlayersSpriteSheet.simpleAnimation(skin.path),
  // initDirection: initDirection ?? Direction.down,

  PlayerCharacter({
    required this.battleLogBloc,
    required this.name,
    required this.skinPath,
    required Vector2 position,
    required Vector2 size,
    SimpleDirectionAnimation? animation,
    Direction initDirection = Direction.right,
    double? speed,
    double life = 100,
  }) : super(position: position, size: size, animation: animation, initDirection: initDirection, speed: speed, life: life){
    _state = CharacterState(hp: hp, attack: attackPower, defence: defencePower, evasionRate: evasionRate, attriPoints: attrPoints, luckVal: luckVal, triggerProbability: triggerProbability);
  }

  CharacterState get characterState => _state;

  onCharacterStateChanged(CharacterState state){}

  @override
  onAttrPointsChanged(double attr) {
    int index = selectRandom([0, 1, 2, 3]);
    switch(index){
      case 0:
        addHp(val: 10, byAttr: true);
        break;
      case 1:
        addAttackPower(byAttr: true);
        break;
      case 2:
        addDefencePower(byAttr: true);
        break;
      case 3:
        addLuckValue(byAttr: true);
        break;
    }
    _state = _state.copyWith(attriPoints: attr, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  onLogCall(log) {
    battleLogBloc.add(AddLogEvent(log));
  }

  @override
  onHpChanged(double hp, bool upgrade) {
    if(upgrade) {
      var index = selectRandom([0,1,2,3,4]);
      var skill = autumnSkills[index];
      if(ownSkills.any((e) => e.id == skill.id)) {
        ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name, logCallback: (v) => onLogCall(v));
      } else {
        onSkillAdd(skill);
        ownSkills.add(skill);
      }
    }
    _state = _state.copyWith(hp: hp, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  @override
  onAttackPowerChanged(double attackPower, bool upgrade) {
    if(upgrade) {
      var index = selectRandom([0,1,2,3,4]);
      var skill = summerSkills[index];
      if(ownSkills.any((e) => e.id == skill.id)) {
        ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name, logCallback: (v) => onLogCall(v));
      } else {
        onSkillAdd(skill);
        ownSkills.add(skill);
      }
    }
    _state = _state.copyWith(attack: attackPower, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  @override
  onDefencePowerChanged(double defencePower, bool upgrade) {
    if(upgrade) {
      var index = selectRandom([0,1,2,3,4]);
      var skill = winterSkills[index];
      if(ownSkills.any((e) => e.id == skill.id)) {
        ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name, logCallback: (v) => onLogCall(v));
      } else {
        onSkillAdd(skill);
        ownSkills.add(skill);
      }
    }
    _state = _state.copyWith(defence: defencePower, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  @override
  onLuckValueChanged(double luckValue, bool upgrade) {
    double v20 = luckValue % 20;
    if(v20 == 0) {
      addEvasionRate();
    }
    double v5 = luckValue % 5;
    if(v5 == 0) {
      addTriggerProbability();
    }
    if(upgrade) {
      var index = selectRandom([0,1,2,3,4]);
      var skill = springSkills[index];
      if(ownSkills.any((e) => e.id == skill.id)) {
        ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name, logCallback: (v) => onLogCall(v));
      } else {
        onSkillAdd(skill);
        ownSkills.add(skill);
      }
    }
    _state = _state.copyWith(luckVal: luckValue, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  onSkillAdd(Skill skill) {
    onLogCall(myPrint("$name: 添加了技能 ${skill.description} 等级: ${skill.grade}"));
  }

  @override
  onRecover(double recoverHp) {
    onLogCall(myPrint('$name 使用了复活，生命值增加$recoverHp, 当前$hp'));
  }

  @override
  bool onKo(double probability) {
    bool occur = Random().nextDouble() < probability;
    onLogCall(myPrint('$name: ${occur ? '触发' : '未触发'}概率$probability${occur ? '' : '未'}被秒杀'));
    return occur;
  }

  @override
  onTriggerProbabilityChanged(double triggerProbability) {
    _state.copyWith(triggerProbability: triggerProbability, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  @override
  onEvasionRateChanged(double evasionRate) {
    _state = _state.copyWith(evasionRate: evasionRate, skills: ownSkills);
    onCharacterStateChanged(_state);
  }

  void onReflect(double damage){
    addHp(val: -damage);
    onLogCall(myPrint("$name: 被反弹伤害 $damage, 剩余生命值: $hp"));
  }

  void attack(PlayerCharacter opponent, {double reflect = 0}) {//y=ATK*（1-DEF/（DEF+k））k=5

    bool _trigger = false;

    for (var skill in ownSkills) {
      if(hp == 0 || opponent.hp == 0){
        return;
      }

      bool occur = (Random().nextDouble() + triggerProbability) < skill.triggerProbability;

      if (occur || _trigger) {
        var (type, value) = skill.invoke(this, opponent, (log){
          onLogCall(log);
        });
        onLogCall(myPrint('$name: 触发了技能 ${skill.name}: ${skill.description} 等级: ${skill.grade}'));
        // print("damage: $damage, ${skill.damageMultiplier}");

        double defencePower = opponent.defencePower;
        double attackPower = this.attackPower;
        double evasionRate = opponent.evasionRate;
        bool decrease = type == kSkillCallbackTypeDecAttack;
        bool reflect = type == kSkillCallbackTypeReflectDamage;
        bool block = type == kSkillCallbackTypeBlockSkill;
        bool damage2Attack = type == kSkillCallbackTypeDamage2Attack;
        bool trigger = type == kSkillCallbackTypeTriggerSkill;

        if(trigger) {
          _trigger = true;
          onLogCall(myPrint('$name: 获得了下次必定触发的技能'));
        }

        if(damage2Attack) {
          this.damage2Attack = value;
          onLogCall(myPrint('$name: 获得了伤害转化为攻击力$value'));
        }

        if(decrease) {
          this.decrease = value;
          onLogCall(myPrint("$name: 获得了格挡$value倍伤害"));
        }

        if(reflect) {
          this.hasReflect = true;
          onLogCall(myPrint('$name: 获得了伤害反弹'));
        }

        if(block) {
          int index = selectRandom(List.generate(opponent.ownSkills.length, (index)=>index));
          onLogCall(myPrint("${opponent.name}: 被封印了技能 ${opponent.ownSkills[index].description}"));
          opponent.ownSkills.removeAt(index);
        }

        if(type == kSkillCallbackTypeIgnoreDefence) {
          defencePower = 0;
        } else if(type == kSkillCallbackTypeIncAttack) {
          attackPower = value;
        } else if(type == kSkillCallbackTypeIgnoreEvasion) {
          evasionRate -= value;
        }
        var damage = getDamage(defence: defencePower, attack: attackPower);
        opponent.receiveDamage(damage, evasionRate, onReflect: ()=>onReflect(damage));
        return;
      }
    }
    if(hp == 0 || opponent.hp == 0){
      return;
    }
    onLogCall(myPrint('$name: 进行普通攻击'));
    final damage = getDamage(defence: opponent.defencePower);
    opponent.receiveDamage(damage, opponent.evasionRate, onReflect: ()=>onReflect(damage));
  }

  void receiveDamage(double damage, double evasionRate, {VoidCallback? onReflect}) {
    if (Random().nextDouble() < evasionRate) {
      onLogCall(myPrint('$name: 闪避了攻击!'));
    } else {
      // print('$name: hasReflect:$_hasReflect, decrease:$_decrease, damage2Attack:$_damage2Attack');
      if(hasReflect) {
        hasReflect = false;
        onReflect?.call();
        return;
      }
      if(decrease != 0) {
        damage = damage - decrease * damage;
        onLogCall(myPrint("$name: 使用了降低伤害, 把伤害降低了 ${decrease * damage}"));
        decrease = 0;
      }
      if(damage2Attack != 0) {
        addAttackPower(val: damage * damage2Attack);
        onLogCall(myPrint("$name: 将伤害转化成攻击力 ${damage * damage2Attack}"));
      }
      hp -= damage;
      onLogCall(myPrint('$name: 受到了 $damage 点伤害, 剩余生命值: $hp'));
    }
  }

  double getDamage({double? defence, double? attack}) {
    var k = 5;
    var ATK = attack ?? attackPower;
    var DEF = defence ?? defencePower;
    var y = ATK * (1-DEF/(DEF+k));
    return y;
  }
}

class CharacterState extends Equatable{
  final double? hp;
  final double? attack;
  final double? defence;
  final double? evasionRate;
  final double? attriPoints;
  final double? luckVal;
  final double? triggerProbability;
  final List<Skill>? skills;

  CharacterState({this.hp, this.attack, this.defence, this.evasionRate, this.attriPoints, this.luckVal, this.triggerProbability, this.skills});

  CharacterState copyWith({
    double? hp,
    double? attack,
    double? defence,
    double? evasionRate,
    double? attriPoints,
    double? luckVal,
    double? triggerProbability,
    List<Skill>? skills
  }) {
    return CharacterState(
        hp: hp ?? this.hp,
        attack: attack ?? this.attack,
        defence: defence ?? this.defence,
        evasionRate: evasionRate ?? this.evasionRate,
        attriPoints: attriPoints ?? this.attriPoints,
        luckVal: luckVal ?? this.luckVal,
        triggerProbability: triggerProbability ?? this.triggerProbability,
        skills: skills ?? this.skills
    );
  }

  @override
  List<Object?> get props => [hp, attack, defence, evasionRate, attriPoints, luckVal, triggerProbability, skills];

  @override
  String toString() {
    return 'CharacterState{hp: $hp, attack: $attack, defence: $defence, evasionRate: $evasionRate, '
        'attriPoints: $attriPoints, luckVal: $luckVal, triggerProbability: $triggerProbability, skills: ${skills?.map((e)=>e.toString())?.join("\n")}';
  }
}