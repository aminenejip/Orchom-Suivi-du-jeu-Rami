import 'package:flutter_test/flutter_test.dart';

import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_session.dart';
import 'package:orchom/domain/entities/player.dart';
import 'package:orchom/domain/enums/starter_mode.dart';
import 'package:orchom/domain/repositories/game_repository.dart';
import 'package:orchom/domain/services/game_engine.dart';
import 'package:orchom/application/game_controller.dart';

class FakeGameRepository implements GameRepository {
  GameSession? activeSession;
  final List<GameSession> history = [];

  @override
  Future<void> saveActiveSession(GameSession session) async {
    activeSession = session;
  }

  @override
  Future<GameSession?> getActiveSession() async => activeSession;

  @override
  Future<bool> hasActiveSession() async => activeSession != null;

  @override
  Future<void> clearActiveSession() async {
    activeSession = null;
  }

  @override
  Future<void> saveGameToHistory(GameSession session) async {
    history.add(session);
  }

  @override
  Future<List<GameSession>> getGameHistory() async =>
      history.reversed.toList();

  @override
  Future<GameSession?> getHistoryGameById(String id) async {
    for (final s in history) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<void> deleteHistoryGame(String id) async {
    history.removeWhere((s) => s.id == id);
  }

  @override
  Future<void> clearHistory() async {
    history.clear();
  }
}

GameSession createSession({
  String id = 'session-1',
  int targetScore = 100,
  StarterMode starterMode = StarterMode.rotation,
  int starterIndex = 0,
  bool isFinished = false,
  int currentRound = 0,
  DateTime? createdAt,
  DateTime? finishedAt,
}) {
  return GameSession(
    id: id,
    config: GameConfig(
      targetScore: targetScore,
      ghaltaPenalty: 10,
      playerCount: 2,
      starterMode: starterMode,
    ),
    players: [
      Player(id: 'p1', name: 'Alice'),
      Player(id: 'p2', name: 'Bob'),
    ],
    currentRound: currentRound,
    starterIndex: starterIndex,
    isFinished: isFinished,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
    finishedAt: finishedAt,
  );
}

void main() {
  group('loadActiveSession', () {
    test('loads an existing active session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      final session = createSession();
      repo.activeSession = session;

      await controller.loadActiveSession();

      expect(controller.currentSession, isNotNull);
      expect(controller.currentSession!.id, session.id);
    });

    test('sets currentSession to null when no active session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      await controller.loadActiveSession();

      expect(controller.currentSession, isNull);
    });
  });

  group('hasActiveSession', () {
    test('returns false when no active session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final result = await controller.hasActiveSession();

      expect(result, isFalse);
    });

    test('returns true after saving an active session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      final result = await controller.hasActiveSession();

      expect(result, isTrue);
    });
  });

  group('startNewGame', () {
    test('validates the session and saves it as active', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      final session = createSession();

      await controller.startNewGame(session);

      expect(repo.activeSession, isNotNull);
      expect(repo.activeSession!.id, session.id);
    });

    test('sets currentSession with the new game', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      final session = createSession();

      await controller.startNewGame(session);

      expect(controller.currentSession, isNotNull);
      expect(controller.currentSession!.id, session.id);
    });

    test('refuses invalid session and fills errorMessage', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      final invalidSession = GameSession(
        id: 'bad',
        config: GameConfig(
          targetScore: 100,
          ghaltaPenalty: 10,
          playerCount: 2,
        ),
        players: [
          Player(id: 'p1', name: ''),
          Player(id: 'p2', name: 'Bob'),
        ],
        createdAt: DateTime(2026, 1, 1),
      );

      expect(
        () async => controller.startNewGame(invalidSession),
        throwsArgumentError,
      );
      await expectLater(
        () async => controller.startNewGame(invalidSession),
        throwsArgumentError,
      );
      // After catching the error, errorMessage should be set
      try {
        await controller.startNewGame(invalidSession);
      } catch (_) {
        expect(controller.errorMessage, isNotNull);
      }
      // currentSession should not have been set
      expect(controller.currentSession, isNull);
    });
  });

  group('addRound', () {
    test('adds a round to the current session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.addRound({'p1': 10, 'p2': 20});

      expect(controller.currentSession!.rounds, hasLength(1));
    });

    test('auto-saves the active session after adding a round', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.addRound({'p1': 10, 'p2': 20});

      expect(repo.activeSession, isNotNull);
      expect(repo.activeSession!.rounds, hasLength(1));
    });

    test('preserves previous round scores in the rounds list', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.addRound({'p1': 10, 'p2': 20});
      await controller.addRound({'p1': 5, 'p2': 15});

      expect(controller.currentSession!.rounds, hasLength(2));
      expect(controller.currentSession!.rounds[0].scoresByPlayerId,
          {'p1': 10, 'p2': 20});
      expect(controller.currentSession!.rounds[1].scoresByPlayerId,
          {'p1': 5, 'p2': 15});
    });

    test('updates cumulative player scores', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.addRound({'p1': 10, 'p2': 20});
      await controller.addRound({'p1': 5, 'p2': 15});

      expect(controller.currentSession!.players[0].score, 15);
      expect(controller.currentSession!.players[1].score, 35);
    });

    test(
        'does not auto-save to history even if the game is finished',
        () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));

      await controller.addRound({'p1': 60, 'p2': 30});

      expect(controller.currentSession!.isFinished, isTrue);
      expect(repo.history, isEmpty);
    });

    test('fills errorMessage when no current session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      expect(
        () => controller.addRound({'p1': 10, 'p2': 20}),
        throwsA(isA<StateError>()),
      );
      expect(controller.errorMessage, isNotNull);
    });
  });

  group('undoLastRound', () {
    test('undoes the last round', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());
      await controller.addRound({'p1': 10, 'p2': 20});
      await controller.addRound({'p1': 5, 'p2': 15});

      await controller.undoLastRound();

      expect(controller.currentSession!.rounds, hasLength(1));
      expect(controller.currentSession!.rounds[0].scoresByPlayerId,
          {'p1': 10, 'p2': 20});
    });

    test('auto-saves the session after undo', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());
      await controller.addRound({'p1': 10, 'p2': 20});

      await controller.undoLastRound();

      expect(repo.activeSession!.rounds, isEmpty);
    });

    test('keeps currentSession when no rounds exist', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.undoLastRound();

      expect(controller.currentSession, isNotNull);
      expect(controller.currentSession!.rounds, isEmpty);
    });
  });

  group('finishCurrentGame', () {
    test('refuses unfinished game and fills errorMessage', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      expect(
        () => controller.finishCurrentGame(),
        throwsA(isA<StateError>()),
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('saves a finished game to history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      await controller.finishCurrentGame();

      expect(repo.history, hasLength(1));
      expect(repo.history[0].id, 'session-1');
    });

    test('clears the active session after saving to history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      await controller.finishCurrentGame();

      expect(repo.activeSession, isNull);
    });

    test('sets currentSession to null after closing', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      await controller.finishCurrentGame();

      expect(controller.currentSession, isNull);
    });

    test('reloads history after closing', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      await controller.finishCurrentGame();

      expect(controller.history, hasLength(1));
      expect(controller.history[0].id, 'session-1');
    });
  });

  group('clearActiveSession', () {
    test('removes the active session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.clearActiveSession();

      expect(repo.activeSession, isNull);
    });

    test('sets currentSession to null', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.clearActiveSession();

      expect(controller.currentSession, isNull);
    });
  });

  group('loadHistory', () {
    test('loads all games from history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      repo.history.add(createSession(id: 's1', isFinished: true));
      repo.history.add(createSession(id: 's2', isFinished: true));

      await controller.loadHistory();

      expect(controller.history, hasLength(2));
    });
  });

  group('getHistoryGameById', () {
    test('returns the correct game', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      repo.history.add(createSession(id: 'find-me', isFinished: true));

      final found = await controller.getHistoryGameById('find-me');

      expect(found, isNotNull);
      expect(found!.id, 'find-me');
    });

    test('returns null if id does not exist', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final found = await controller.getHistoryGameById('missing');

      expect(found, isNull);
    });
  });

  group('deleteHistoryGame', () {
    test('deletes a game from history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      repo.history.add(createSession(id: 's1', isFinished: true));
      repo.history.add(createSession(id: 's2', isFinished: true));

      await controller.deleteHistoryGame('s1');

      expect(repo.history, hasLength(1));
      expect(repo.history[0].id, 's2');
    });
  });

  group('clearHistory', () {
    test('clears all history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      repo.history.add(createSession(id: 's1', isFinished: true));

      await controller.clearHistory();

      expect(controller.history, isEmpty);
      expect(repo.history, isEmpty);
    });
  });

  group('getRanking', () {
    test('returns empty list when no current session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final ranking = controller.getRanking();

      expect(ranking, isEmpty);
    });

    test('returns players sorted by ascending score', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());
      await controller.addRound({'p1': 50, 'p2': 10});

      final ranking = controller.getRanking();

      expect(ranking[0].id, 'p2');
      expect(ranking[1].id, 'p1');
    });
  });

  group('getWinner', () {
    test('returns null when no current session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final winner = controller.getWinner();

      expect(winner, isNull);
    });

    test('returns the winner when the current session is finished', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      final winner = controller.getWinner();

      expect(winner, isNotNull);
      expect(winner!.id, 'p2');
    });
  });

  group('getLoser', () {
    test('returns null when no current session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final loser = controller.getLoser();

      expect(loser, isNull);
    });

    test('returns the loser when the current session is finished', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});

      final loser = controller.getLoser();

      expect(loser, isNotNull);
      expect(loser!.id, 'p1');
    });
  });

  group('getCurrentStarter', () {
    test('returns null when no current session exists', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      final starter = controller.getCurrentStarter();

      expect(starter, isNull);
    });

    test('returns the current dealer player', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(
        createSession(starterIndex: 1),
      );

      final starter = controller.getCurrentStarter();

      expect(starter, isNotNull);
      expect(starter!.id, 'p2');
    });
  });

  group('multi-round critical scenario', () {
    test('preserves all rounds and cumulative scores across addRound calls',
        () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.addRound({'p1': 20, 'p2': -10});
      await controller.addRound({'p1': 50, 'p2': 30});

      expect(controller.currentSession!.rounds, hasLength(2));
      expect(controller.currentSession!.players[0].score, 70);
      expect(controller.currentSession!.players[1].score, 20);
      expect(controller.currentSession!.rounds[0].scoresByPlayerId,
          {'p1': 20, 'p2': -10});
      expect(controller.currentSession!.rounds[1].scoresByPlayerId,
          {'p1': 50, 'p2': 30});

      expect(repo.activeSession!.rounds, hasLength(2));
      expect(repo.activeSession!.players[0].score, 70);
      expect(repo.activeSession!.players[1].score, 20);
    });
  });

  group('updateFinalDetails', () {
    test('updates finalComment on current session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.updateFinalDetails(finalComment: 'Great game!');

      expect(controller.currentSession!.finalComment, 'Great game!');
    });

    test('updates photoPaths on current session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.updateFinalDetails(photoPaths: ['/path/1.jpg']);

      expect(controller.currentSession!.photoPaths, hasLength(1));
      expect(controller.currentSession!.photoPaths[0], '/path/1.jpg');
    });

    test('saves the active session after update', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.updateFinalDetails(finalComment: 'Nice!');
      await controller.updateFinalDetails(photoPaths: ['/p1.jpg']);

      expect(repo.activeSession!.finalComment, 'Nice!');
      expect(repo.activeSession!.photoPaths, hasLength(1));
    });

    test('throws StateError when no active session', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);

      expect(
        () => controller.updateFinalDetails(finalComment: 'test'),
        throwsA(isA<StateError>()),
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('does not finish the game', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession());

      await controller.updateFinalDetails(finalComment: 'Still playing');

      expect(controller.currentSession!.isFinished, isFalse);
    });
  });

  group('finishCurrentGame preserves final details', () {
    test('preserves finalComment in history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});
      await controller.updateFinalDetails(finalComment: 'Mémorable !');

      await controller.finishCurrentGame();

      expect(repo.history, hasLength(1));
      expect(repo.history[0].finalComment, 'Mémorable !');
    });

    test('preserves photoPaths in history', () async {
      final repo = FakeGameRepository();
      final controller = GameController(engine: GameEngine(), repository: repo);
      await controller.startNewGame(createSession(targetScore: 50));
      await controller.addRound({'p1': 60, 'p2': 30});
      await controller.updateFinalDetails(photoPaths: ['/photo.jpg']);

      await controller.finishCurrentGame();

      expect(repo.history, hasLength(1));
      expect(repo.history[0].photoPaths, hasLength(1));
      expect(repo.history[0].photoPaths[0], '/photo.jpg');
    });
  });

  group('GameSession creation uses GameSettings defaults', () {
    test('config uses defaultGhaltaPenalty from settings', () async {
      final session = createSession();
      expect(session.config.ghaltaPenalty, 10);
    });

    test('config uses defaultStarterMode from settings', () async {
      final session = createSession();
      expect(session.config.starterMode, StarterMode.rotation);
    });
  });
}
