import '../enums/starter_mode.dart';
import 'quick_score_button.dart';

class GameConfig {
  final int targetScore;
  final int ghaltaPenalty;
  final int playerCount;
  final StarterMode starterMode;
  final List<QuickScoreButton> quickScoreButtons;

  const GameConfig({
    required this.targetScore,
    required this.ghaltaPenalty,
    required this.playerCount,
    this.starterMode = StarterMode.rotation,
    this.quickScoreButtons = QuickScoreButton.defaultButtons,
  }) : assert(
          playerCount == 2 || playerCount == 4,
          'playerCount must be 2 or 4',
        );

  GameConfig copyWith({
    int? targetScore,
    int? ghaltaPenalty,
    int? playerCount,
    StarterMode? starterMode,
    List<QuickScoreButton>? quickScoreButtons,
  }) =>
      GameConfig(
        targetScore: targetScore ?? this.targetScore,
        ghaltaPenalty: ghaltaPenalty ?? this.ghaltaPenalty,
        playerCount: playerCount ?? this.playerCount,
        starterMode: starterMode ?? this.starterMode,
        quickScoreButtons: quickScoreButtons ?? this.quickScoreButtons,
      );

  Map<String, dynamic> toJson() => {
        'targetScore': targetScore,
        'ghaltaPenalty': ghaltaPenalty,
        'playerCount': playerCount,
        'starterMode': starterMode.toJson(),
        'quickScoreButtons': quickScoreButtons.map((b) => b.toJson()).toList(),
      };

  factory GameConfig.fromJson(Map<String, dynamic> json) => GameConfig(
        targetScore: json['targetScore'] as int,
        ghaltaPenalty: json['ghaltaPenalty'] as int,
        playerCount: json['playerCount'] as int,
        starterMode: StarterMode.fromJson(json['starterMode'] as String),
        quickScoreButtons: json['quickScoreButtons'] != null
            ? (json['quickScoreButtons'] as List<dynamic>)
                .map((e) =>
                    QuickScoreButton.fromJson(e as Map<String, dynamic>))
                .toList()
            : QuickScoreButton.defaultButtons,
      );
}
