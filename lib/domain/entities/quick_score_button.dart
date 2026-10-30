class QuickScoreButton {
  final String id;
  final String label;
  final int value;
  final String soundId;

  const QuickScoreButton({
    required this.id,
    required this.label,
    required this.value,
    this.soundId = 'none',
  });

  static const defaultButtons = [
    QuickScoreButton(id: 'qs_default_minus_10', label: 'Kmalt', value: -10),
    QuickScoreButton(
      id: 'qs_default_minus_50',
      label: 'Frach wahdou',
      value: -50,
    ),
    QuickScoreButton(id: 'qs_default_ghalta', label: 'Ghalta', value: 50),
  ];

  QuickScoreButton copyWith({
    String? id,
    String? label,
    int? value,
    String? soundId,
  }) => QuickScoreButton(
    id: id ?? this.id,
    label: label ?? this.label,
    value: value ?? this.value,
    soundId: soundId ?? this.soundId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'value': value,
    'soundId': soundId,
  };

  factory QuickScoreButton.fromJson(Map<String, dynamic> json) =>
      QuickScoreButton(
        id: json['id'] as String,
        label: json['label'] as String,
        value: json['value'] as int,
        soundId: json['soundId'] as String? ?? 'none',
      );
}
