part of 'my_player_bloc.dart';

class MyPlayerState extends Equatable {
  final Vector2 position;
  final MoveDirectionEnum? direction;
  final MoveDirectionEnum lastDirection;
  final CharacterState characterState;

  const MyPlayerState({
    required this.characterState,
    required this.position,
    required this.direction,
    required this.lastDirection,
  });

  MyPlayerState copyWith({
    Vector2? position,
    MoveDirectionEnum? direction,
    MoveDirectionEnum? lastDirection,
    CharacterState? characterState,
  }) {
    return MyPlayerState(
      characterState: characterState ?? this.characterState,
      position: position ?? this.position,
      direction: direction,
      lastDirection: lastDirection ?? this.lastDirection,
    );
  }

  @override
  List<Object?> get props => [position, direction, lastDirection, characterState];

  @override
  String toString() {
    return 'MyPlayerState{position: $position, direction: $direction, lastDirection: $lastDirection, characterState: $characterState}';
  }
}
