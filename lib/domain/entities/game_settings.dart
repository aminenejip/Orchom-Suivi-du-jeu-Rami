import '../enums/starter_mode.dart';
import 'quick_score_button.dart';

class GameSettings {
  final List<QuickScoreButton> quickScoreButtons;
  final int defaultGhaltaPenalty;
  final StarterMode defaultStarterMode;

  const GameSettings({
    required this.quickScoreButtons,
    this.defaultGhaltaPenalty = 50,
    this.defaultStarterMode = StarterMode.rotation,
  });

  factory GameSettings.defaultSettings() => const GameSettings(
        quickScoreButtons: QuickScoreButton.defaultButtons,
        defaultGhaltaPenalty: 50,
        defaultStarterMode: StarterMode.rotation,
      );

  GameSettings copyWith({
    List<QuickScoreButton>? quickScoreButtons,
    int? defaultGhaltaPenalty,
    StarterMode? defaultStarterMode,
  }) =>
      GameSettings(
        quickScoreButtons: quickScoreButtons ?? this.quickScoreButtons,
        defaultGhaltaPenalty:
            defaultGhaltaPenalty ?? this.defaultGhaltaPenalty,
        defaultStarterMode: defaultStarterMode ?? this.defaultStarterMode,
      );

  Map<String, dynamic> toJson() => {
        'quickScoreButtons':
            quickScoreButtons.map((b) => b.toJson()).toList(),
        'defaultGhaltaPenalty': defaultGhaltaPenalty,
        'defaultStarterMode': defaultStarterMode.toJson(),
      };

  factory GameSettings.fromJson(Map<String, dynamic> json) => GameSettings(
        quickScoreButtons:
            (json['quickScoreButtons'] as List<dynamic>)
                .map((e) =>
                    QuickScoreButton.fromJson(e as Map<String, dynamic>))
                .toList(),
        defaultGhaltaPenalty: json['defaultGhaltaPenalty'] as int? ?? 50,
        defaultStarterMode: json['defaultStarterMode'] != null
            ? StarterMode.fromJson(json['defaultStarterMode'] as String)
            : StarterMode.rotation,
      );
}
