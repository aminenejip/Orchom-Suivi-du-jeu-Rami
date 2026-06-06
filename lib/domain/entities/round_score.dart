class RoundScore {
  final int roundNumber;
  final Map<String, int> scoresByPlayerId;
  final DateTime createdAt;

  const RoundScore({
    required this.roundNumber,
    required this.scoresByPlayerId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'roundNumber': roundNumber,
        'scoresByPlayerId': scoresByPlayerId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory RoundScore.fromJson(Map<String, dynamic> json) => RoundScore(
        roundNumber: json['roundNumber'] as int,
        scoresByPlayerId: (json['scoresByPlayerId'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value as int)),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
