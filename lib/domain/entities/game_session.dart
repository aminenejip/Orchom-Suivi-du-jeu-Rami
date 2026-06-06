import 'game_config.dart';
import 'player.dart';
import 'round_score.dart';

class GameSession {
  final String id;
  final GameConfig config;
  final List<Player> players;
  final List<RoundScore> rounds;
  final int currentRound;
  final int starterIndex;
  final bool isFinished;
  final DateTime createdAt;
  final DateTime? finishedAt;
  final String? finalComment;
  final List<String> photoPaths;

  const GameSession({
    required this.id,
    required this.config,
    required this.players,
    this.rounds = const [],
    this.currentRound = 0,
    this.starterIndex = 0,
    this.isFinished = false,
    required this.createdAt,
    this.finishedAt,
    this.finalComment,
    this.photoPaths = const [],
  });

  GameSession copyWith({
    String? id,
    GameConfig? config,
    List<Player>? players,
    List<RoundScore>? rounds,
    int? currentRound,
    int? starterIndex,
    bool? isFinished,
    DateTime? createdAt,
    DateTime? finishedAt,
    String? finalComment,
    List<String>? photoPaths,
  }) =>
      GameSession(
        id: id ?? this.id,
        config: config ?? this.config,
        players: players ?? this.players,
        rounds: rounds ?? this.rounds,
        currentRound: currentRound ?? this.currentRound,
        starterIndex: starterIndex ?? this.starterIndex,
        isFinished: isFinished ?? this.isFinished,
        createdAt: createdAt ?? this.createdAt,
        finishedAt: finishedAt ?? this.finishedAt,
        finalComment: finalComment ?? this.finalComment,
        photoPaths: photoPaths ?? this.photoPaths,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'config': config.toJson(),
        'players': players.map((p) => p.toJson()).toList(),
        'rounds': rounds.map((r) => r.toJson()).toList(),
        'currentRound': currentRound,
        'starterIndex': starterIndex,
        'isFinished': isFinished,
        'createdAt': createdAt.toIso8601String(),
        'finishedAt': finishedAt?.toIso8601String(),
        if (finalComment != null) 'finalComment': finalComment,
        'photoPaths': photoPaths,
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        id: json['id'] as String,
        config: GameConfig.fromJson(json['config'] as Map<String, dynamic>),
        players: (json['players'] as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, dynamic>))
            .toList(),
        rounds: (json['rounds'] as List<dynamic>)
            .map((e) => RoundScore.fromJson(e as Map<String, dynamic>))
            .toList(),
        currentRound: json['currentRound'] as int,
        starterIndex: json['starterIndex'] as int,
        isFinished: json['isFinished'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        finishedAt: json['finishedAt'] != null
            ? DateTime.parse(json['finishedAt'] as String)
            : null,
        finalComment: json['finalComment'] as String?,
        photoPaths: json['photoPaths'] != null
            ? (json['photoPaths'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
            : [],
      );
}
