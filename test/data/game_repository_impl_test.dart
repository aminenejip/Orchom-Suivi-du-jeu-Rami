import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_session.dart';
import 'package:orchom/domain/entities/player.dart';
import 'package:orchom/domain/enums/starter_mode.dart';
import 'package:orchom/domain/services/game_engine.dart';
import 'package:orchom/data/local/app_database.dart';
import 'package:orchom/data/repositories/game_repository_impl.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDatabase;
  late GameRepositoryImpl repository;

  setUp(() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    appDatabase = AppDatabase(databaseName: 'test_$timestamp.db');
    repository = GameRepositoryImpl(appDatabase);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  GameSession createTestSession({
    String id = 'session-1',
    int targetScore = 100,
    StarterMode starterMode = StarterMode.rotation,
    int starterIndex = 0,
    bool isFinished = false,
    int currentRound = 0,
    DateTime? createdAt,
    DateTime? finishedAt,
    String? finalComment,
    List<String>? photoPaths,
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
      finalComment: finalComment,
      photoPaths: photoPaths ?? [],
    );
  }

  group('active session', () {
    test('saveActiveSession saves an active game', () async {
      await repository.saveActiveSession(createTestSession());
      expect(await repository.hasActiveSession(), isTrue);
    });

    test('hasActiveSession returns false when no active session exists', () async {
      expect(await repository.hasActiveSession(), isFalse);
    });

    test('hasActiveSession returns true after saveActiveSession', () async {
      await repository.saveActiveSession(createTestSession());
      expect(await repository.hasActiveSession(), isTrue);
    });

    test('getActiveSession returns null when no active session exists', () async {
      expect(await repository.getActiveSession(), isNull);
    });

    test('getActiveSession restores a saved session correctly', () async {
      final session = createTestSession(
        currentRound: 3,
        starterIndex: 1,
        isFinished: false,
      );
      await repository.saveActiveSession(session);
      final restored = await repository.getActiveSession();
      expect(restored, isNotNull);
      expect(restored!.id, session.id);
      expect(restored.config.targetScore, session.config.targetScore);
      expect(restored.config.playerCount, session.config.playerCount);
      expect(restored.config.starterMode, session.config.starterMode);
      expect(restored.currentRound, session.currentRound);
      expect(restored.starterIndex, session.starterIndex);
      expect(restored.isFinished, session.isFinished);
      expect(restored.finishedAt, session.finishedAt);
    });

    test('getActiveSession restores players correctly', () async {
      await repository.saveActiveSession(createTestSession());
      final restored = await repository.getActiveSession();
      expect(restored!.players, hasLength(2));
      expect(restored.players[0].id, 'p1');
      expect(restored.players[0].name, 'Alice');
      expect(restored.players[1].id, 'p2');
      expect(restored.players[1].name, 'Bob');
    });

    test('getActiveSession restores cumulative scores correctly', () async {
      final engine = GameEngine();
      var session = createTestSession();
      session = engine.addRound(session, {'p1': 20, 'p2': -10});
      session = engine.addRound(session, {'p1': 50, 'p2': 30});
      await repository.saveActiveSession(session);
      final restored = await repository.getActiveSession();
      expect(restored!.players[0].score, 70);
      expect(restored.players[1].score, 20);
    });

    test('getActiveSession restores the rounds list correctly', () async {
      final engine = GameEngine();
      var session = createTestSession();
      session = engine.addRound(session, {'p1': 20, 'p2': -10});
      session = engine.addRound(session, {'p1': 50, 'p2': 30});
      await repository.saveActiveSession(session);
      final restored = await repository.getActiveSession();
      expect(restored!.rounds, hasLength(2));
    });

    test('getActiveSession restores scoresByPlayerId for each round', () async {
      final engine = GameEngine();
      var session = createTestSession();
      session = engine.addRound(session, {'p1': 20, 'p2': -10});
      session = engine.addRound(session, {'p1': 50, 'p2': 30});
      await repository.saveActiveSession(session);
      final restored = await repository.getActiveSession();
      expect(restored!.rounds[0].scoresByPlayerId, {'p1': 20, 'p2': -10});
      expect(restored.rounds[1].scoresByPlayerId, {'p1': 50, 'p2': 30});
    });

    test('saveActiveSession replaces old session when new one is saved', () async {
      await repository.saveActiveSession(createTestSession(
        id: 'session-1',
        currentRound: 1,
      ));
      await repository.saveActiveSession(createTestSession(
        id: 'session-2',
        currentRound: 5,
      ));
      final restored = await repository.getActiveSession();
      expect(restored!.id, 'session-2');
      expect(restored.currentRound, 5);
    });

    test('clearActiveSession removes the active session', () async {
      await repository.saveActiveSession(createTestSession());
      await repository.clearActiveSession();
      expect(await repository.hasActiveSession(), isFalse);
      expect(await repository.getActiveSession(), isNull);
    });
  });

  group('game history', () {
    test('saveGameToHistory saves a finished game to history', () async {
      await repository.saveGameToHistory(createTestSession(
        isFinished: true,
        finishedAt: DateTime(2026, 6, 1),
      ));
      final history = await repository.getGameHistory();
      expect(history, hasLength(1));
    });

    test('getGameHistory returns saved games', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 's1',
        isFinished: true,
        finishedAt: DateTime(2026, 6, 1),
      ));
      await repository.saveGameToHistory(createTestSession(
        id: 's2',
        isFinished: true,
        finishedAt: DateTime(2026, 6, 2),
      ));
      final history = await repository.getGameHistory();
      expect(history, hasLength(2));
    });

    test('getGameHistory returns history sorted newest first', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 's1',
        isFinished: true,
      ));
      await Future.delayed(const Duration(milliseconds: 2));
      await repository.saveGameToHistory(createTestSession(
        id: 's2',
        isFinished: true,
      ));
      final history = await repository.getGameHistory();
      expect(history, hasLength(2));
      expect(history[0].id, 's2');
      expect(history[1].id, 's1');
    });

    test('getHistoryGameById returns the correct game by id', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 'find-me',
        isFinished: true,
      ));
      final found = await repository.getHistoryGameById('find-me');
      expect(found, isNotNull);
      expect(found!.id, 'find-me');
    });

    test('getHistoryGameById returns null if id does not exist', () async {
      final found = await repository.getHistoryGameById('non-existent');
      expect(found, isNull);
    });

    test('deleteHistoryGame deletes only the requested game', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 's1',
        isFinished: true,
      ));
      await repository.saveGameToHistory(createTestSession(
        id: 's2',
        isFinished: true,
      ));
      await repository.deleteHistoryGame('s1');
      final history = await repository.getGameHistory();
      expect(history, hasLength(1));
      expect(history[0].id, 's2');
    });

    test('clearHistory removes all history', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 's1',
        isFinished: true,
      ));
      await repository.saveGameToHistory(createTestSession(
        id: 's2',
        isFinished: true,
      ));
      await repository.clearHistory();
      final history = await repository.getGameHistory();
      expect(history, isEmpty);
    });

    test('history save preserves finishedAt', () async {
      final finishedAt = DateTime(2026, 6, 4, 12, 30, 0);
      await repository.saveGameToHistory(createTestSession(
        id: 'finish-test',
        isFinished: true,
        finishedAt: finishedAt,
      ));
      final restored = await repository.getHistoryGameById('finish-test');
      expect(restored!.finishedAt, isNotNull);
      expect(
        restored.finishedAt!.toIso8601String(),
        finishedAt.toIso8601String(),
      );
    });

    test('history save preserves finalComment', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 'comment-test',
        isFinished: true,
        finishedAt: DateTime(2026, 6, 5),
        finalComment: 'Superbe partie !',
      ));
      final restored = await repository.getHistoryGameById('comment-test');
      expect(restored!.finalComment, 'Superbe partie !');
    });

    test('history save preserves photoPaths', () async {
      await repository.saveGameToHistory(createTestSession(
        id: 'photo-test',
        isFinished: true,
        finishedAt: DateTime(2026, 6, 5),
        photoPaths: ['/photos/img1.jpg', '/photos/img2.jpg'],
      ));
      final restored = await repository.getHistoryGameById('photo-test');
      expect(restored!.photoPaths, hasLength(2));
      expect(restored.photoPaths[0], '/photos/img1.jpg');
      expect(restored.photoPaths[1], '/photos/img2.jpg');
    });

    test('history save preserves all previous rounds', () async {
      final engine = GameEngine();
      var session = createTestSession(id: 'multi-round');
      session = engine.addRound(session, {'p1': 20, 'p2': -10});
      session = engine.addRound(session, {'p1': 50, 'p2': 30});
      final finishedSession = engine.addRound(session, {'p1': 100, 'p2': 5});

      await repository.saveGameToHistory(finishedSession);
      final restored = await repository.getHistoryGameById('multi-round');

      expect(restored!.rounds, hasLength(3));
      expect(restored.rounds[0].scoresByPlayerId, {'p1': 20, 'p2': -10});
      expect(restored.rounds[1].scoresByPlayerId, {'p1': 50, 'p2': 30});
      expect(restored.rounds[2].scoresByPlayerId, {'p1': 100, 'p2': 5});
      expect(restored.players[0].score, 170);
      expect(restored.players[1].score, 25);
    });
  });

  group('multi-round scenario', () {
    test('saves and restores a session with multiple rounds correctly', () async {
      final engine = GameEngine();
      var session = createTestSession(id: 'multi-round-scenario');
      session = engine.addRound(session, {'p1': 20, 'p2': -10});
      session = engine.addRound(session, {'p1': 50, 'p2': 30});

      await repository.saveActiveSession(session);
      final restored = await repository.getActiveSession();

      expect(restored!.rounds, hasLength(2));
      expect(restored.players[0].score, 70);
      expect(restored.players[1].score, 20);
      expect(restored.rounds[0].scoresByPlayerId, {'p1': 20, 'p2': -10});
      expect(restored.rounds[1].scoresByPlayerId, {'p1': 50, 'p2': 30});
    });
  });
}
