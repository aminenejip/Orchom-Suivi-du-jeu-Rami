import 'package:flutter/foundation.dart';

import '../domain/entities/game_session.dart';
import '../domain/entities/player.dart';
import '../domain/repositories/game_repository.dart';
import '../domain/services/game_engine.dart';

class GameController extends ChangeNotifier {
  final GameEngine engine;
  final GameRepository repository;

  GameSession? _currentSession;
  List<GameSession> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  GameController({
    required this.engine,
    required this.repository,
  });

  GameSession? get currentSession => _currentSession;
  List<GameSession> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> updateFinalDetails({
    String? finalComment,
    List<String>? photoPaths,
  }) async {
    if (_currentSession == null) {
      final error = 'No active session';
      _setError(error);
      throw StateError(error);
    }
    final updated = _currentSession!.copyWith(
      finalComment: finalComment,
      photoPaths: photoPaths,
    );
    _currentSession = updated;
    await repository.saveActiveSession(updated);
    notifyListeners();
  }

  Future<void> loadActiveSession() async {
    _setLoading(true);
    try {
      _currentSession = await repository.getActiveSession();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> hasActiveSession() async {
    return repository.hasActiveSession();
  }

  Future<void> updatePlayerName(String playerId, String newName) async {
    if (_currentSession == null) {
      final error = 'No active session';
      _setError(error);
      throw StateError(error);
    }

    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      final error = 'Le nom ne peut pas être vide';
      _setError(error);
      throw ArgumentError(error);
    }

    final isDuplicate = _currentSession!.players.any(
      (p) =>
          p.id != playerId &&
          p.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );
    if (isDuplicate) {
      final error = 'Un autre joueur a déjà ce nom';
      _setError(error);
      throw ArgumentError(error);
    }

    _setLoading(true);
    try {
      final updatedPlayers = _currentSession!.players.map((p) {
        if (p.id == playerId) {
          return p.copyWith(name: trimmedName);
        }
        return p;
      }).toList();

      final updated = _currentSession!.copyWith(players: updatedPlayers);
      _currentSession = updated;
      await repository.saveActiveSession(updated);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startNewGame(GameSession session) async {
    _setLoading(true);
    try {
      engine.validateSetup(session);
      _currentSession = session;
      await repository.saveActiveSession(session);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addRound(Map<String, int> scoresByPlayerId) async {
    if (_currentSession == null) {
      final error = 'No active session';
      _setError(error);
      throw StateError(error);
    }
    _setLoading(true);
    try {
      final updated = engine.addRound(_currentSession!, scoresByPlayerId);
      _currentSession = updated;
      await repository.saveActiveSession(updated);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> undoLastRound() async {
    if (_currentSession == null) {
      final error = 'No active session';
      _setError(error);
      throw StateError(error);
    }
    _setLoading(true);
    try {
      final updated = engine.undoLastRound(_currentSession!);
      _currentSession = updated;
      await repository.saveActiveSession(updated);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> finishCurrentGame() async {
    if (_currentSession == null) {
      final error = 'No active session';
      _setError(error);
      throw StateError(error);
    }
    if (!_currentSession!.isFinished) {
      final error = 'Game is not finished yet';
      _setError(error);
      throw StateError(error);
    }
    _setLoading(true);
    try {
      await repository.saveGameToHistory(_currentSession!);
      await repository.clearActiveSession();
      _currentSession = null;
      await _refreshHistory();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearActiveSession() async {
    _setLoading(true);
    try {
      await repository.clearActiveSession();
      _currentSession = null;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadHistory() async {
    _setLoading(true);
    try {
      _history = await repository.getGameHistory();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<GameSession?> getHistoryGameById(String id) async {
    return repository.getHistoryGameById(id);
  }

  Future<void> deleteHistoryGame(String id) async {
    _setLoading(true);
    try {
      await repository.deleteHistoryGame(id);
      await _refreshHistory();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearHistory() async {
    _setLoading(true);
    try {
      await repository.clearHistory();
      _history = [];
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  List<Player> getRanking() {
    if (_currentSession == null) return [];
    return engine.getRanking(_currentSession!);
  }

  Player? getWinner() {
    if (_currentSession == null) return null;
    return engine.getWinner(_currentSession!);
  }

  Player? getLoser() {
    if (_currentSession == null) return null;
    return engine.getLoser(_currentSession!);
  }

  Player? getCurrentStarter() {
    if (_currentSession == null) return null;
    return engine.getCurrentStarter(_currentSession!);
  }

  Future<void> _refreshHistory() async {
    _history = await repository.getGameHistory();
  }
}
