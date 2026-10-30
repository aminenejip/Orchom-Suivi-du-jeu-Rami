import '../enums/app_theme_mode.dart';
import '../enums/starter_mode.dart';
import 'quick_score_button.dart';

class GameSettings {
  final List<QuickScoreButton> quickScoreButtons;
  final int defaultGhaltaPenalty;
  final StarterMode defaultStarterMode;
  final AppThemeMode appThemeMode;

  const GameSettings({
    required this.quickScoreButtons,
    this.defaultGhaltaPenalty = 50,
    this.defaultStarterMode = StarterMode.rotation,
    this.appThemeMode = AppThemeMode.light,
  });

  factory GameSettings.defaultSettings() => const GameSettings(
        quickScoreButtons: QuickScoreButton.defaultButtons,
        defaultGhaltaPenalty: 50,
        defaultStarterMode: StarterMode.rotation,
        appThemeMode: AppThemeMode.light,
      );

  GameSettings copyWith({
    List<QuickScoreButton>? quickScoreButtons,
    int? defaultGhaltaPenalty,
    StarterMode? defaultStarterMode,
    AppThemeMode? appThemeMode,
  }) =>
      GameSettings(
        quickScoreButtons: quickScoreButtons ?? this.quickScoreButtons,
        defaultGhaltaPenalty:
            defaultGhaltaPenalty ?? this.defaultGhaltaPenalty,
        defaultStarterMode: defaultStarterMode ?? this.defaultStarterMode,
        appThemeMode: appThemeMode ?? this.appThemeMode,
      );

  Map<String, dynamic> toJson() => {
        'quickScoreButtons':
            quickScoreButtons.map((b) => b.toJson()).toList(),
        'defaultGhaltaPenalty': defaultGhaltaPenalty,
        'defaultStarterMode': defaultStarterMode.toJson(),
        'appThemeMode': appThemeMode.toJson(),
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
        appThemeMode: json['appThemeMode'] != null
            ? AppThemeMode.fromJson(json['appThemeMode'] as String)
            : AppThemeMode.light,
      );
}
