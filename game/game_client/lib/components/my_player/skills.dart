import 'dart:math' as math;
import 'package:bonfire_multiplayer/components/my_player/player_mixin.dart';
import 'package:flutter/cupertino.dart';

mixin AttrPoints {
  double _attrPoints = 0;//每点属性值=1攻击力 或1防御力 或10生命值 或1幸运值

  addAttrPoints({int val = 1}) {
    _attrPoints += val;
    onAttrPointsChanged(_attrPoints);
  }

  double get attrPoints => _attrPoints;

  onAttrPointsChanged(double attrPoints);
}

mixin Hp {
  double _hp = 100; //生命
  int _count = 0;
  double _recoverHp = 0;
  double _decrease = 0;

  double get hp => _hp;
  set hp(v) => _hp = v;

  double get recoverHp => _recoverHp;
  double get decrease => _decrease;
  set decrease(v) => _decrease = v * 1.0;

  addHp({double val = 1, bool byAttr = false}) {
    _hp += val;
    bool upgrade = false;
    if(byAttr) {
      _count += 1;
      upgrade = _count % 3 == 0;
    }
    onHpChanged(_hp, upgrade);
  }

  minusHp({double hp = 1}){
    _hp -= hp;
    onHpChanged(_hp, false);
  }

  onHpChanged(double hp, bool upgrade);

  setRecoverHp(double hp){
    _recoverHp = hp;
  }

  bool isAlive() {
    bool _alive = _hp > 0;
    if(!_alive && _recoverHp != 0) {
      _hp += _recoverHp;
      onHpChanged(_hp, false);
      onRecover(_recoverHp);
      return true;
    }
    return _alive;
  }

  onRecover(double recoverHp);

  ko({double probability = 0}){
    if(onKo(probability)){
      _hp = 0;
    }
  }

  bool onKo(double probability);
}

mixin AttackPower {
  double _attackPower = 10; //攻击力
  int _attack_count = 0;
  double _damage2Attack = 0;

  double get attackPower => _attackPower;
  double get damage2Attack => _damage2Attack;
  set damage2Attack(v) => _damage2Attack = v;

  addAttackPower({double val = 1, bool byAttr = false}) {
    _attackPower += val;
    bool upgrade = false;
    if(byAttr) {
      _attack_count += 1;
      upgrade = _attack_count % 3 == 0;
    }
    onAttackPowerChanged(_attackPower, upgrade);
  }

  onAttackPowerChanged(double attackPower, bool upgrade);
}

mixin DefencePower {
  double _defencePower = 5;//防御力
  int _defence_count = 0;

  double get defencePower => _defencePower;

  addDefencePower({double val = 1, bool byAttr = false}) {
    _defencePower += val;
    bool upgrade = false;
    if(byAttr) {
      _defence_count += 1;
      upgrade = _defence_count % 3 == 0;
    }
    onDefencePowerChanged(_defencePower, upgrade);
  }

  onDefencePowerChanged(double defencePower, bool upgrade);
}

mixin EvasionRate {
  double _evasionRate = 0.1;//闪避10%
  bool _hasReflect = false;

  double get evasionRate => _evasionRate;
  bool get hasReflect => _hasReflect;
  set hasReflect(v) => _hasReflect = v;

  addEvasionRate({double val = 0.01}) {
    _evasionRate += val;
    onEvasionRateChanged(_evasionRate);
  }

  onEvasionRateChanged(double evasionRate);
}

mixin TriggerProbability {
  double _triggerProbability = 0.05;//基础技能触发概率5%

  double get triggerProbability => _triggerProbability;

  addTriggerProbability({double val = 0.01}) {
    _triggerProbability += val;
    onTriggerProbabilityChanged(_triggerProbability);
  }

  onTriggerProbabilityChanged(double triggerProbability);
}

mixin LuckValue {
  double _luckVal = 0;//幸运值
  int _luck_count = 0;

  double get luckVal => _luckVal;

  addLuckValue({double val = 1, bool byAttr = false}) {
    _luckVal+= val;
    bool upgrade = false;
    if(byAttr) {
      _luck_count += 1;
      upgrade = _luck_count % 3 == 0;
    }
    onLuckValueChanged(_luckVal, upgrade);
  }

  onLuckValueChanged(double luckValue, bool upgrade);
}

mixin RandomGenerator {
  T selectRandom<T>(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('The list cannot be empty');
    }
    final randomIndex = math.Random().nextInt(items.length);
    return items[randomIndex];
  }
}

typedef SkillCallback = (int, double) Function(int, PlayerCharacter, PlayerCharacter, ValueChanged<String> logCallback);

const kSkillCallbackTypeNone = -1;//忽视防御
const kSkillCallbackTypeIgnoreDefence = 0;//忽视防御
const kSkillCallbackTypeIncAttack = 1;//倍增攻击力
const kSkillCallbackTypeDecAttack = 2;//降低伤害
const kSkillCallbackTypeIgnoreEvasion = 3;//降低对方的闪避
const kSkillCallbackTypeReflectDamage = 4;//反弹伤害
const kSkillCallbackTypeBlockSkill = 5;//封印对方一个技能
const kSkillCallbackTypeTriggerSkill = 6;//必定触发一个技能
const kSkillCallbackTypeDamage2Attack = 7;//将伤害转化攻击力

class Skill {
  final String name;
  final double triggerProbability;
  final String description;
  final SkillCallback? callback;
  int grade = 1;
  final int id;

  Skill(this.id, this.name, this.triggerProbability, this.description, {this.callback});

  (int, double) invoke(PlayerCharacter p, PlayerCharacter n, ValueChanged<String> logCallback) {
    return callback?.call(grade, p, n, logCallback) ?? (kSkillCallbackTypeNone, 0);
  }

  void upgrade({String user = '', ValueChanged<String>? logCallback}){
    grade += grade < 5 ? 1 : 0;
    logCallback?.call(myPrint("$user: $name技能 升级到$grade"));
  }
}

String myPrint(String log){
  print(log);
  return log;
}

// 秋（HP）技能
var autumnSkills = [
  Skill(100,'强壮身躯', 0.0, '每等级提升50生命值，共250生命值', callback: (g, p, n, log){
    p.addHp(val: 50.0 * g);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(101,'鲜血打击', 0.1, '下次攻击附带最大生命值2，4，6，8，10%的伤害', callback: (g, p, n, log){
    var list = [0.02, 0.04, 0.06, 0.08, 0.10];
    var damage = p._hp * list[g-1];
    p.minusHp(hp: damage);
    log(myPrint("${p.name}使用技能被附带伤害: $damage"));
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(102,'中伤', 0.1, '10%概率使敌方损失对方当前生命值3，6，9，12，15%的伤害', callback: (g, p, n, log) {
    final list = [0.03,0.06, 0.09, 0.12];
    var damage = n._hp * list[g-1];
    n.minusHp(hp: damage);
    log(myPrint("${n.name}: 被附加伤害: $damage"));
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(103,'牺牲', 0.0, '战斗开始触发，损失最大生命值的5，10，15，20，25%造成等量伤害（无视防御）', callback: (g, p, n, log) {
    final damage = p._hp * .25;
    p.minusHp(hp: damage);
    n.minusHp(hp: damage);

    log(myPrint("各自受伤 ${p.name} :$damage, ${n.name} :$damage 并且忽视${n.name}的防御"));
    return (kSkillCallbackTypeIgnoreDefence, 0);
  }),
  Skill(104,'信仰圣光', 0.0,'死亡后重生，拥有最大生命值的50%复生，每场战斗一次', callback: (g, p, n, log) {
    p.setRecoverHp(p._hp * 0.5);
    return (kSkillCallbackTypeNone, 0);
  })
];

// 夏（攻击）技能
var summerSkills = [
  Skill(200,'磨刀', 0.0, '每等级提升5攻击力，共25攻击力', callback: (g, p, n, log) {
    p.addAttackPower(val: g * 5);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(206,'暴击', 0.1, '10%概率触发，下次攻击附带*1.2，*1.4，*1.6，*1.8，*2.0倍伤害', callback: (g, p, n, log) {
    final list = [1.2, 1.4, 1.6, 1.8];
    final attack = p._attackPower * list[g-1];
    log(myPrint("${p.name}攻击附带${list[g-1]}倍伤害 攻击力为$attack"));
    return (kSkillCallbackTypeIncAttack, attack);
  }),
  Skill(207,'吸血', 0.1, '10%概率触发，下次攻击获得20%，40%，60%，80%，100%治疗', callback: (g, p, n, log) {
    final list = [0.2, 0.4, 0.6 ,0.8, 1];
    final recover = p._hp * list[g-1];
    p.addHp(val: recover);
    log(myPrint("${p.name}将获得治疗$recover"));
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(208,'怒意', 0.1, '10%概率触发，在本场战斗中，增加1，2，3，4，5攻击力', callback: (g, p, n, log) {
    final list = [1, 2, 3, 4, 5];
    final power = list[g-1] * 1.0;
    p.addAttackPower(val: power);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(209,'恩赐解脱', 0.05, '5%概率秒杀对方（概率不可提升）', callback: (g, p, n, log){
    n.ko(probability: 0.05);
    return (kSkillCallbackTypeNone, 0);
  })
];

// 冬（防御）技能
var winterSkills = [
  Skill(300,'防御专精', 0.0, '每等级提升5防御，共25防御', callback: (g, p, n, log) {
    p.addDefencePower(val: g * 5);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(301,'格挡', 0.1, '10%概率触发，格挡10%，20%，40%，60%，80%伤害', callback: (g, p, n, log) {
    final list = [0.1, 0.2, 0.4, 0.6, 0.8];
    final damage = list[g-1];
    // print("${n.name}: 获得了格挡$damage倍伤害");
    return (kSkillCallbackTypeDecAttack, damage);
  }),
  Skill(302,'不屈', 0.1,  '10%概率触发，在本场战斗中，增加1，2，3，4，5防御力', callback: (g, p, n, log) {
    final list = [1.0, 2.0, 3.0, 4.0, 5.0];
    p.addDefencePower(val: list[g-1]);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(303,'无光之盾', 0.1,'10%概率触发，将上回和伤害转化为攻击力，转化比例：20%，40%，60%，80%，100%', callback: (g, p, n, log) {
    final list = [0.2, 0.4, 0.6, 0.8, 1];
    var damage = list[g-1] * 1.0;
    return (kSkillCallbackTypeDamage2Attack, damage);
  }),
  Skill(304,'最终防御', 0.0, '受到致命伤害时，阻止死亡持续三回合（每回合触发一次）')
];

// 春（幸运）技能
var springSkills = [
  Skill(400,'鹰眼', 0.0, '每等级无视敌方闪避：2%，4%，6%，8%，10%', callback: (g, p, n, log){
    final list = [0.02, 0.04, 0.06, 0.08, 0.1];
    final evasion = list[g-1];
    return (kSkillCallbackTypeIgnoreEvasion, evasion);
  }),
  Skill(401,'蜘蛛感应', 0.1,'10%概率触发，增加1%，1.5%，2%，2.5%，3%闪避', callback: (g, p, n, log) {
    final list = [0.01, 0.015, 0.02, 0.025, 0.03];
    p.addEvasionRate(val: list[g-1]);
    return (kSkillCallbackTypeNone, 0);
  }),
  Skill(402,'幸运一击', 0.1,'10%概率触发，必定触发玩家拥有的随机的1级，2级，3级，4级，5级普通技能', callback: (g, p, n, log) {
    return (kSkillCallbackTypeTriggerSkill, 0);
  }),
  Skill(403,'神圣反击', 0.1,'闪避后有10%触发，反弹闪避的伤害给对方，此伤害不能触发神圣反击', callback: (g, p, n, log) {
    return (kSkillCallbackTypeReflectDamage, 0);
  }),
  Skill(404,'终极封印', 0.0,'本场战斗，随机封印一个地方技能', callback: (g, p, n, log) {
    return (kSkillCallbackTypeBlockSkill, 0);
  })
];


// class Character with Hp, AttackPower, DefencePower, EvasionRate, AttrPoints, LuckValue, TriggerProbability, RandomGenerator{
//   String name;
//   List<Skill> ownSkills = [];
//
//   Character(this.name);
//
//   onSkillAdd(Skill skill) {
//     print("$name: 添加了技能 ${skill.description} 等级: ${skill.grade}");
//   }
//
//   @override
//   onAttrPointsChanged(double attr) {
//     int index = selectRandom([0, 1, 2, 3]);
//     switch(index){
//       case 0:
//         addHp(val: 10, byAttr: true);
//         break;
//       case 1:
//         addAttackPower(byAttr: true);
//         break;
//       case 2:
//         addDefencePower(byAttr: true);
//         break;
//       case 3:
//         addLuckValue(byAttr: true);
//         break;
//     }
//   }
//
//   @override
//   onHpChanged(double hp, bool upgrade) {
//     if(upgrade) {
//       var index = selectRandom([0,1,2,3,4]);
//       var skill = autumnSkills[index];
//       if(ownSkills.any((e) => e.id == skill.id)) {
//         ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name);
//       } else {
//         onSkillAdd(skill);
//         ownSkills.add(skill);
//       }
//     }
//   }
//
//   @override
//   onAttackPowerChanged(double attackPower, bool upgrade) {
//     if(upgrade) {
//       var index = selectRandom([0,1,2,3,4]);
//       var skill = summerSkills[index];
//       if(ownSkills.any((e) => e.id == skill.id)) {
//         ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name);
//       } else {
//         onSkillAdd(skill);
//         ownSkills.add(skill);
//       }
//     }
//   }
//
//   @override
//   onDefencePowerChanged(double defencePower, bool upgrade) {
//     if(upgrade) {
//       var index = selectRandom([0,1,2,3,4]);
//       var skill = winterSkills[index];
//       if(ownSkills.any((e) => e.id == skill.id)) {
//         ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name);
//       } else {
//         onSkillAdd(skill);
//         ownSkills.add(skill);
//       }
//     }
//   }
//
//   @override
//   onLuckValueChanged(double luckValue, bool upgrade) {
//     double v20 = luckValue % 20;
//     if(v20 == 0) {
//       addEvasionRate();
//     }
//     double v5 = luckValue % 5;
//     if(v5 == 0) {
//       addTriggerProbability();
//     }
//     if(upgrade) {
//       var index = selectRandom([0,1,2,3,4]);
//       var skill = springSkills[index];
//       if(ownSkills.any((e) => e.id == skill.id)) {
//         ownSkills.where((e) => e.id == skill.id).firstOrNull?.upgrade(user: name);
//       } else {
//         onSkillAdd(skill);
//         ownSkills.add(skill);
//       }
//     }
//   }
//
//   @override
//   onRecover(double recoverHp) {
//     print('$name 使用了复活，生命值增加$recoverHp, 当前$_hp');
//   }
//
//   @override
//   bool onKo(double probability) {
//     bool occur = Random().nextDouble() < probability;
//     print('$name: ${occur ? '触发' : '未触发'}概率$probability${occur ? '' : '未'}被秒杀');
//     return occur;
//   }
//
//   @override
//   onTriggerProbabilityChanged(double triggerProbability) {
//
//   }
//
//   void attack(MyPlayer opponent, {double reflect = 0}) {//y=ATK*（1-DEF/（DEF+k））k=5
//
//     bool _trigger = false;
//
//     for (var skill in ownSkills) {
//       if(_hp == 0 || opponent._hp == 0){
//         return;
//       }
//
//       bool occur = (Random().nextDouble() + _triggerProbability) < skill.triggerProbability;
//
//       if (occur || _trigger) {
//         var (type, value) = skill.invoke(this, opponent);
//         print('$name: 触发了技能 ${skill.name}: ${skill.description} 等级: ${skill.grade}');
//         // print("damage: $damage, ${skill.damageMultiplier}");
//
//         double defencePower = opponent._defencePower;
//         double attackPower = _attackPower;
//         double evasionRate = opponent._evasionRate;
//         bool decrease = type == kSkillCallbackTypeDecAttack;
//         bool reflect = type == kSkillCallbackTypeReflectDamage;
//         bool block = type == kSkillCallbackTypeBlockSkill;
//         bool damage2Attack = type == kSkillCallbackTypeDamage2Attack;
//         bool trigger = type == kSkillCallbackTypeTriggerSkill;
//
//         if(trigger) {
//           _trigger = true;
//           print('$name: 获得了下次必定触发的技能');
//         }
//
//         if(damage2Attack) {
//           _damage2Attack = value;
//           print('$name: 获得了伤害转化为攻击力$value');
//         }
//
//         if(decrease) {
//           _decrease = value;
//           print("$name: 获得了格挡$value倍伤害");
//         }
//
//         if(reflect) {
//           _hasReflect = true;
//           print('$name: 获得了伤害反弹');
//         }
//
//         if(block) {
//           int index = selectRandom(List.generate(opponent.ownSkills.length, (index)=>index));
//           print("${opponent.name}: 被封印了技能 ${opponent.ownSkills[index].description}");
//           opponent.ownSkills.removeAt(index);
//         }
//
//         if(type == kSkillCallbackTypeIgnoreDefence) {
//           defencePower = 0;
//         } else if(type == kSkillCallbackTypeIncAttack) {
//           attackPower = value;
//         } else if(type == kSkillCallbackTypeIgnoreEvasion) {
//           evasionRate -= value;
//         }
//         var damage = getDamage(defence: defencePower, attack: attackPower);
//         opponent.receiveDamage(damage, evasionRate, onReflect: ()=>onReflect(damage));
//         return;
//       }
//     }
//     if(_hp == 0 || opponent._hp == 0){
//       return;
//     }
//     print('$name: 进行普通攻击');
//     final damage = getDamage(defence: opponent._defencePower);
//     opponent.receiveDamage(damage, opponent._evasionRate, onReflect: ()=>onReflect(damage));
//   }
//
//   onReflect(double damage){
//     addHp(val: -damage);
//     print("$name: 被反弹伤害 $damage, 剩余生命值: $_hp");
//   }
//
//   void receiveDamage(double damage, double evasionRate, {VoidCallback? onReflect}) {
//     if (Random().nextDouble() < evasionRate) {
//       print('$name: 闪避了攻击!');
//     } else {
//       // print('$name: hasReflect:$_hasReflect, decrease:$_decrease, damage2Attack:$_damage2Attack');
//       if(_hasReflect) {
//         _hasReflect = false;
//         onReflect?.call();
//         return;
//       }
//       if(_decrease != 0) {
//         damage = damage - _decrease * damage;
//         print("$name: 使用了降低伤害, 把伤害降低了 ${_decrease * damage}");
//         _decrease = 0;
//       }
//       if(_damage2Attack != 0) {
//         addAttackPower(val: damage * _damage2Attack);
//         print("$name: 将伤害转化成攻击力 ${damage * _damage2Attack}");
//       }
//       _hp -= damage;
//       print('$name: 受到了 $damage 点伤害, 剩余生命值: $_hp');
//     }
//   }
//
//   double getDamage({double? defence, double? attack}) {
//     var k = 5;
//     var ATK = attack ?? _attackPower;
//     var DEF = defence ?? _defencePower;
//     var y = ATK * (1-DEF/(DEF+k));
//     return y;
//   }
//
//   @override
//   onEvasionRateChanged(double evasionRate) {
//
//   }
// }

/*
void main() {

  Character characterA = Character("A");
  Character characterB = Character("B");

  for(var i = 0; i < 6+Random().nextInt(50); i++) {
    characterA.addAttrPoints();
  }
  for(var i = 0; i < 6+Random().nextInt(40); i++) {
    characterB.addAttrPoints();
  }

  Character first;
  Character second;
  if(characterA._luckVal > characterB._luckVal) {
    first = characterA;
    second = characterB;
  } else {
    first = characterB;
    second = characterA;
  }
  while (first.isAlive() && second.isAlive()) {
    first.attack(second);
    if (!second.isAlive()) {
      print('${second.name} 被击败了！');
      break;
    } else if(!first.isAlive()){
      print('${first.name} 被击败了！');
      break;
    }

    second.attack(first);
    if (!first.isAlive()) {
      print('${first.name} 被击败了！');
      break;
    } else if (!second.isAlive()) {
      print('${second.name} 被击败了！');
      break;
    }
  }
}*/