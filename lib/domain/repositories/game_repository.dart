import '../entities/game_session.dart';

abstract class GameRepository {
  Future<void> saveActiveSession(GameSession session);

  Future<GameSession?> getActiveSession();

  Future<bool> hasActiveSession();

  Future<void> clearActiveSession();

  Future<void> saveGameToHistory(GameSession session);

  Future<List<GameSession>> getGameHistory();

  Future<GameSession?> getHistoryGameById(String id);

  Future<void> deleteHistoryGame(String id);

  Future<void> clearHistory();
}
