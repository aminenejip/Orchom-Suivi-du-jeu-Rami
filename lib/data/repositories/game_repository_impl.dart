import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../domain/entities/game_session.dart';
import '../../domain/repositories/game_repository.dart';
import '../local/app_database.dart';

class GameRepositoryImpl implements GameRepository {
  final AppDatabase _appDatabase;

  GameRepositoryImpl(this._appDatabase);

  @override
  Future<void> saveActiveSession(GameSession session) async {
    final db = await _appDatabase.database;
    await db.delete('active_session');
    await db.insert(
      'active_session',
      {
        'id': session.id,
        'session_json': jsonEncode(session.toJson()),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<GameSession?> getActiveSession() async {
    final db = await _appDatabase.database;
    final rows = await db.query('active_session', limit: 1);
    if (rows.isEmpty) return null;
    final json = jsonDecode(rows.first['session_json'] as String)
        as Map<String, dynamic>;
    return GameSession.fromJson(json);
  }

  @override
  Future<bool> hasActiveSession() async {
    final db = await _appDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM active_session'),
    );
    return (count ?? 0) > 0;
  }

  @override
  Future<void> clearActiveSession() async {
    final db = await _appDatabase.database;
    await db.delete('active_session');
  }

  @override
  Future<void> saveGameToHistory(GameSession session) async {
    final db = await _appDatabase.database;
    await db.insert(
      'game_history',
      {
        'id': session.id,
        'session_json': jsonEncode(session.toJson()),
        'created_at': session.createdAt.toIso8601String(),
        'finished_at': session.finishedAt?.toIso8601String(),
        'saved_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<GameSession>> getGameHistory() async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'game_history',
      orderBy: 'saved_at DESC',
    );
    return rows.map((row) {
      final json = jsonDecode(row['session_json'] as String)
          as Map<String, dynamic>;
      return GameSession.fromJson(json);
    }).toList();
  }

  @override
  Future<GameSession?> getHistoryGameById(String id) async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'game_history',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final json = jsonDecode(rows.first['session_json'] as String)
        as Map<String, dynamic>;
    return GameSession.fromJson(json);
  }

  @override
  Future<void> deleteHistoryGame(String id) async {
    final db = await _appDatabase.database;
    await db.delete(
      'game_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearHistory() async {
    final db = await _appDatabase.database;
    await db.delete('game_history');
  }
}
