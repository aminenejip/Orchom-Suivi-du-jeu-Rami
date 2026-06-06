class QuickScoreButton {
  final String id;
  final String label;
  final int value;

  const QuickScoreButton({
    required this.id,
    required this.label,
    required this.value,
  });

  static const defaultButtons = [
    QuickScoreButton(id: 'qs_default_-10', label: '-10', value: -10),
    QuickScoreButton(id: 'qs_default_-20', label: '-20', value: -20),
    QuickScoreButton(id: 'qs_default_-100', label: '-100', value: -100),
    QuickScoreButton(id: 'qs_default_+Ghalta', label: '+Ghalta', value: 50),
  ];

  QuickScoreButton copyWith({
    String? id,
    String? label,
    int? value,
  }) =>
      QuickScoreButton(
        id: id ?? this.id,
        label: label ?? this.label,
        value: value ?? this.value,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'value': value,
      };

  factory QuickScoreButton.fromJson(Map<String, dynamic> json) =>
      QuickScoreButton(
        id: json['id'] as String,
        label: json['label'] as String,
        value: json['value'] as int,
      );
}
