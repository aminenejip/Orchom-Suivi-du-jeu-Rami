class Player {
  final String id;
  final String name;
  final int score;
  final List<int> roundScores;

  const Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.roundScores = const [],
  });

  Player addRoundScore(int points) => Player(
        id: id,
        name: name,
        score: score + points,
        roundScores: [...roundScores, points],
      );

  Player removeLastRoundScore() {
    if (roundScores.isEmpty) return this;
    final updatedScores = [...roundScores]..removeLast();
    final total = updatedScores.fold<int>(0, (sum, s) => sum + s);
    return Player(
      id: id,
      name: name,
      score: total,
      roundScores: updatedScores,
    );
  }

  Player copyWith({
    String? id,
    String? name,
    int? score,
    List<int>? roundScores,
  }) =>
      Player(
        id: id ?? this.id,
        name: name ?? this.name,
        score: score ?? this.score,
        roundScores: roundScores ?? this.roundScores,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'score': score,
        'roundScores': roundScores,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        score: json['score'] as int,
        roundScores: (json['roundScores'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
      );
}
