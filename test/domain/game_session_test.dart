import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_session.dart';
import 'package:orchom/domain/entities/player.dart';

GameSession createSession({
  String id = 'session-1',
  String? finalComment,
  List<String>? photoPaths,
}) {
  return GameSession(
    id: id,
    config: GameConfig(
      targetScore: 100,
      ghaltaPenalty: 10,
      playerCount: 2,
    ),
    players: [
      Player(id: 'p1', name: 'Alice'),
      Player(id: 'p2', name: 'Bob'),
    ],
    createdAt: DateTime(2026, 1, 1),
    finalComment: finalComment,
    photoPaths: photoPaths ?? [],
  );
}

void main() {
  group('GameSession finalComment', () {
    test('toJson and fromJson roundtrip preserves finalComment', () {
      final session = createSession(finalComment: 'Super partie !');
      final json = session.toJson();
      final restored = GameSession.fromJson(json);

      expect(restored.finalComment, 'Super partie !');
    });

    test('toJson omits finalComment when null', () {
      final session = createSession();
      final json = session.toJson();

      expect(json.containsKey('finalComment'), isFalse);
    });

    test('fromJson restores null finalComment when key missing', () {
      final json = {
        'id': 's1',
        'config': {
          'targetScore': 100,
          'ghaltaPenalty': 10,
          'playerCount': 2,
          'starterMode': 'rotation',
        },
        'players': [
          {'id': 'p1', 'name': 'Alice', 'score': 0, 'roundScores': <int>[]},
          {'id': 'p2', 'name': 'Bob', 'score': 0, 'roundScores': <int>[]},
        ],
        'rounds': [],
        'currentRound': 1,
        'starterIndex': 0,
        'isFinished': false,
        'createdAt': '2026-01-01T00:00:00.000',
      };

      final restored = GameSession.fromJson(json);
      expect(restored.finalComment, isNull);
    });
  });

  group('GameSession photoPaths', () {
    test('toJson and fromJson roundtrip preserves photoPaths', () {
      final session = createSession(photoPaths: ['/path/to/photo1.jpg']);
      final json = session.toJson();
      final restored = GameSession.fromJson(json);

      expect(restored.photoPaths, hasLength(1));
      expect(restored.photoPaths[0], '/path/to/photo1.jpg');
    });

    test('toJson contains photoPaths even when empty', () {
      final session = createSession();
      final json = session.toJson();

      expect(json['photoPaths'], isA<List>());
      expect((json['photoPaths'] as List), isEmpty);
    });

    test('fromJson restores empty photoPaths when key missing', () {
      final json = {
        'id': 's1',
        'config': {
          'targetScore': 100,
          'ghaltaPenalty': 10,
          'playerCount': 2,
          'starterMode': 'rotation',
        },
        'players': [
          {'id': 'p1', 'name': 'Alice', 'score': 0, 'roundScores': <int>[]},
          {'id': 'p2', 'name': 'Bob', 'score': 0, 'roundScores': <int>[]},
        ],
        'rounds': [],
        'currentRound': 1,
        'starterIndex': 0,
        'isFinished': false,
        'createdAt': '2026-01-01T00:00:00.000',
      };

      final restored = GameSession.fromJson(json);
      expect(restored.photoPaths, isEmpty);
    });

    test('copyWith replaces photoPaths', () {
      final session = createSession();
      final updated = session.copyWith(
        photoPaths: ['/new/photo.jpg'],
      );

      expect(updated.photoPaths, hasLength(1));
      expect(updated.photoPaths[0], '/new/photo.jpg');
    });

    test('copyWith replaces finalComment', () {
      final session = createSession();
      final updated = session.copyWith(finalComment: 'Nouveau commentaire');

      expect(updated.finalComment, 'Nouveau commentaire');
    });
  });
}
