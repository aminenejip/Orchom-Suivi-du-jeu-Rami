import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_session.dart';
import 'package:orchom/domain/entities/player.dart';
import 'package:orchom/domain/entities/round_score.dart';
import 'package:orchom/domain/enums/starter_mode.dart';
import 'package:orchom/domain/services/game_engine.dart';

GameEngine _createEngine() => GameEngine();

Player _player({
  required String id,
  required String name,
  int score = 0,
  List<int> roundScores = const [],
}) =>
    Player(id: id, name: name, score: score, roundScores: roundScores);

GameSession _session2({
  int targetScore = 100,
  StarterMode starterMode = StarterMode.rotation,
  int starterIndex = 0,
  bool isFinished = false,
  List<RoundScore> rounds = const [],
  int currentRound = 0,
}) {
  return GameSession(
    id: 'session-1',
    config: GameConfig(
      targetScore: targetScore,
      ghaltaPenalty: 10,
      playerCount: 2,
      starterMode: starterMode,
    ),
    players: [
      _player(id: 'p1', name: 'Alice'),
      _player(id: 'p2', name: 'Bob'),
    ],
    rounds: rounds,
    currentRound: currentRound,
    starterIndex: starterIndex,
    isFinished: isFinished,
    createdAt: DateTime(2026, 1, 1),
  );
}

GameSession _session4({
  int targetScore = 100,
  StarterMode starterMode = StarterMode.rotation,
  int starterIndex = 0,
  bool isFinished = false,
  List<RoundScore> rounds = const [],
  int currentRound = 0,
}) {
  return GameSession(
    id: 'session-2',
    config: GameConfig(
      targetScore: targetScore,
      ghaltaPenalty: 10,
      playerCount: 4,
      starterMode: starterMode,
    ),
    players: [
      _player(id: 'p1', name: 'Alice'),
      _player(id: 'p2', name: 'Bob'),
      _player(id: 'p3', name: 'Charlie'),
      _player(id: 'p4', name: 'Diana'),
    ],
    rounds: rounds,
    currentRound: currentRound,
    starterIndex: starterIndex,
    isFinished: isFinished,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('validateSetup', () {
    test('accepts valid session with 2 players', () {
      final engine = _createEngine();
      final session = _session2();
      expect(() => engine.validateSetup(session), returnsNormally);
    });

    test('accepts valid session with 4 players', () {
      final engine = _createEngine();
      final session = _session4();
      expect(() => engine.validateSetup(session), returnsNormally);
    });

    test('refuses invalid playerCount (not 2 or 4)', () {
      expect(
        () => GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 3,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('refuses when actual player count differs from config', () {
      final engine = _createEngine();
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          _player(id: 'p1', name: 'A'),
          _player(id: 'p2', name: 'B'),
          _player(id: 'p3', name: 'C'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => engine.validateSetup(session),
        throwsArgumentError,
      );
    });

    test('refuses targetScore below 1', () {
      final engine = _createEngine();
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 0,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          _player(id: 'p1', name: 'A'),
          _player(id: 'p2', name: 'B'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => engine.validateSetup(session),
        throwsArgumentError,
      );
    });

    test('refuses targetScore above 10000', () {
      final engine = _createEngine();
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 10001,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          _player(id: 'p1', name: 'A'),
          _player(id: 'p2', name: 'B'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => engine.validateSetup(session),
        throwsArgumentError,
      );
    });

    test('refuses empty player name', () {
      final engine = _createEngine();
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          _player(id: 'p1', name: ''),
          _player(id: 'p2', name: 'Bob'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => engine.validateSetup(session),
        throwsArgumentError,
      );
    });

    test('refuses duplicate names with different casing and spacing', () {
      final engine = _createEngine();
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          _player(id: 'p1', name: 'Amine'),
          _player(id: 'p2', name: ' amine '),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(
        () => engine.validateSetup(session),
        throwsArgumentError,
      );
    });
  });

  group('validateRoundScores', () {
    test('refuses when game is already finished', () {
      final engine = _createEngine();
      final session = _session2(isFinished: true);
      expect(
        () => engine.validateRoundScores(session, {'p1': 10, 'p2': 20}),
        throwsArgumentError,
      );
    });

    test('refuses when a score is missing for a player', () {
      final engine = _createEngine();
      final session = _session2();
      expect(
        () => engine.validateRoundScores(session, {'p1': 10}),
        throwsArgumentError,
      );
    });

    test('refuses when a score is provided for an unknown player', () {
      final engine = _createEngine();
      final session = _session2();
      expect(
        () => engine.validateRoundScores(session, {
          'p1': 10,
          'p2': 20,
          'unknown': 99,
        }),
        throwsArgumentError,
      );
    });
  });

  group('addRound', () {
    test('adds a round correctly', () {
      final engine = _createEngine();
      final session = _session2();
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.rounds.length, 1);
      expect(result.rounds.first.roundNumber, 0);
      expect(result.rounds.first.scoresByPlayerId, {'p1': 10, 'p2': 20});
    });

    test('accumulates player scores correctly', () {
      final engine = _createEngine();
      var session = _session2();
      session = engine.addRound(session, {'p1': 10, 'p2': 20});
      session = engine.addRound(session, {'p1': 5, 'p2': 15});
      expect(session.players[0].score, 15);
      expect(session.players[1].score, 35);
    });

    test('adds a RoundScore to the rounds list', () {
      final engine = _createEngine();
      final session = _session2();
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.rounds, hasLength(1));
      expect(result.rounds.first, isA<RoundScore>());
    });

    test('increments currentRound', () {
      final engine = _createEngine();
      final session = _session2();
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.currentRound, 1);
    });

    test('changes starterIndex in rotation mode', () {
      final engine = _createEngine();
      final session = _session2(starterMode: StarterMode.rotation, starterIndex: 0);
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.starterIndex, 1);
    });

    test('keeps same starterIndex in manual mode', () {
      final engine = _createEngine();
      final session = _session2(starterMode: StarterMode.manual, starterIndex: 0);
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.starterIndex, 0);
    });

    test('chooses a valid starterIndex in random mode', () {
      final engine = _createEngine();
      final session = _session2(starterMode: StarterMode.random);
      final result = engine.addRound(session, {'p1': 10, 'p2': 20});
      expect(result.starterIndex, greaterThanOrEqualTo(0));
      expect(result.starterIndex, lessThan(2));
    });

    test('finishes the game when a player reaches or exceeds targetScore', () {
      final engine = _createEngine();
      final session = _session2(targetScore: 15);
      final result = engine.addRound(session, {'p1': 20, 'p2': 5});
      expect(result.isFinished, isTrue);
      expect(result.finishedAt, isNotNull);
    });
  });

  group('getRanking', () {
    test('returns players sorted by ascending score', () {
      final engine = _createEngine();
      final players = [
        _player(id: 'p1', name: 'A', score: 50),
        _player(id: 'p2', name: 'B', score: 10),
        _player(id: 'p3', name: 'C', score: 30),
      ];
      final session = GameSession(
        id: 's',
        config: GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 4,
        ),
        players: players,
        createdAt: DateTime(2026, 1, 1),
      );
      final ranking = engine.getRanking(session);
      expect(ranking[0].id, 'p2');
      expect(ranking[1].id, 'p3');
      expect(ranking[2].id, 'p1');
    });
  });

  group('getWinner', () {
    test('returns null when game is not finished', () {
      final engine = _createEngine();
      final session = _session2();
      expect(engine.getWinner(session), isNull);
    });

    test('returns player with lowest score when game is finished', () {
      final engine = _createEngine();
      final session = _session2(targetScore: 50);
      final result = engine.addRound(session, {'p1': 60, 'p2': 30});
      final winner = engine.getWinner(result);
      expect(winner, isNotNull);
      expect(winner!.id, 'p2');
    });
  });

  group('getLoser', () {
    test('returns null when game is not finished', () {
      final engine = _createEngine();
      final session = _session2();
      expect(engine.getLoser(session), isNull);
    });

    test('returns player with highest score among those who reached targetScore', () {
      final engine = _createEngine();
      final session = _session4(targetScore: 100);
      final result = engine.addRound(session, {
        'p1': 150,
        'p2': 200,
        'p3': 50,
        'p4': 300,
      });
      final loser = engine.getLoser(result);
      expect(loser, isNotNull);
      expect(loser!.id, 'p4');
    });
  });

  group('getCurrentStarter', () {
    test('returns the player at starterIndex', () {
      final engine = _createEngine();
      final session = _session2(starterIndex: 1);
      final starter = engine.getCurrentStarter(session);
      expect(starter, isNotNull);
      expect(starter!.id, 'p2');
    });
  });

  group('undoLastRound', () {
    test('returns same session when no rounds exist', () {
      final engine = _createEngine();
      final session = _session2();
      final result = engine.undoLastRound(session);
      expect(identical(result, session), isTrue);
    });

    test('removes the last round', () {
      final engine = _createEngine();
      var session = _session2();
      session = engine.addRound(session, {'p1': 10, 'p2': 20});
      session = engine.addRound(session, {'p1': 5, 'p2': 15});
      final result = engine.undoLastRound(session);
      expect(result.rounds, hasLength(1));
      expect(result.rounds.first.roundNumber, 0);
    });

    test('removes last scores from players', () {
      final engine = _createEngine();
      var session = _session2();
      session = engine.addRound(session, {'p1': 10, 'p2': 20});
      session = engine.addRound(session, {'p1': 5, 'p2': 15});
      final result = engine.undoLastRound(session);
      expect(result.players[0].score, 10);
      expect(result.players[1].score, 20);
    });

    test('decrements currentRound', () {
      final engine = _createEngine();
      var session = _session2();
      session = engine.addRound(session, {'p1': 10, 'p2': 20});
      final result = engine.undoLastRound(session);
      expect(result.currentRound, 0);
    });

    test('resets isFinished to false and finishedAt to null', () {
      final engine = _createEngine();
      final session = _session2(targetScore: 5);
      final finishedSession = engine.addRound(session, {'p1': 10, 'p2': 3});
      expect(finishedSession.isFinished, isTrue);
      expect(finishedSession.finishedAt, isNotNull);

      final undid = engine.undoLastRound(finishedSession);
      expect(undid.isFinished, isFalse);
      expect(undid.finishedAt, isNull);
    });
  });
}
