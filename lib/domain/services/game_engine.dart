import 'dart:math';

import '../entities/game_session.dart';
import '../entities/player.dart';
import '../entities/round_score.dart';
import '../enums/starter_mode.dart';

class GameEngine {
  void validateSetup(GameSession session) {
    final config = session.config;
    final playerCount = config.playerCount;

    if (playerCount != 2 && playerCount != 4) {
      throw ArgumentError('playerCount must be 2 or 4');
    }

    if (session.players.length != playerCount) {
      throw ArgumentError(
        'Actual player count (${session.players.length}) does not match '
        'config player count ($playerCount)',
      );
    }

    if (config.targetScore < 1 || config.targetScore > 10000) {
      throw ArgumentError('targetScore must be between 1 and 10000');
    }

    for (final player in session.players) {
      if (player.name.trim().isEmpty) {
        throw ArgumentError('Player name cannot be empty');
      }
    }

    final normalizedNames = session.players
        .map((p) => p.name.trim().toLowerCase())
        .toList();
    final uniqueNames = normalizedNames.toSet();
    if (uniqueNames.length != session.players.length) {
      throw ArgumentError('Player names must be unique');
    }
  }

  void validateRoundScores(
    GameSession session,
    Map<String, int> scoresByPlayerId,
  ) {
    if (session.isFinished) {
      throw ArgumentError('Game is already finished');
    }

    final playerIds = session.players.map((p) => p.id).toSet();

    if (scoresByPlayerId.length != playerIds.length) {
      throw ArgumentError(
        'scoresByPlayerId must contain exactly all players',
      );
    }

    for (final playerId in playerIds) {
      if (!scoresByPlayerId.containsKey(playerId)) {
        throw ArgumentError('Missing score for player $playerId');
      }
    }

    for (final playerId in scoresByPlayerId.keys) {
      if (!playerIds.contains(playerId)) {
        throw ArgumentError('Unknown player $playerId');
      }
    }
  }

  GameSession addRound(
    GameSession session,
    Map<String, int> scoresByPlayerId,
  ) {
    validateRoundScores(session, scoresByPlayerId);

    final updatedPlayers = session.players.map((player) {
      final points = scoresByPlayerId[player.id]!;
      return player.addRoundScore(points);
    }).toList();

    final roundScore = RoundScore(
      roundNumber: session.currentRound,
      scoresByPlayerId: scoresByPlayerId,
      createdAt: DateTime.now(),
    );

    final finished = _anyPlayerReachedTarget(updatedPlayers, session.config.targetScore);

    return session.copyWith(
      players: updatedPlayers,
      rounds: [...session.rounds, roundScore],
      currentRound: session.currentRound + 1,
      starterIndex: calculateNextStarterIndex(session),
      isFinished: finished,
      finishedAt: finished ? DateTime.now() : null,
    );
  }

  GameSession undoLastRound(GameSession session) {
    if (session.rounds.isEmpty) return session;

    final lastRound = session.rounds.last;

    final updatedPlayers = session.players.map((player) {
      if (lastRound.scoresByPlayerId.containsKey(player.id)) {
        return player.removeLastRoundScore();
      }
      return player;
    }).toList();

    final previousRounds = session.rounds.sublist(0, session.rounds.length - 1);

    return GameSession(
      id: session.id,
      config: session.config,
      players: updatedPlayers,
      rounds: previousRounds,
      currentRound: session.currentRound - 1,
      starterIndex: _reverseStarterIndex(session),
      isFinished: false,
      createdAt: session.createdAt,
      finishedAt: null,
    );
  }

  List<Player> getRanking(GameSession session) {
    final sorted = List<Player>.from(session.players)
      ..sort((a, b) => a.score.compareTo(b.score));
    return sorted;
  }

  Player? getWinner(GameSession session) {
    if (!session.isFinished) return null;
    return getRanking(session).first;
  }

  Player? getLoser(GameSession session) {
    if (!session.isFinished) return null;
    final eligible = session.players
        .where((p) => p.score >= session.config.targetScore)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    if (eligible.isEmpty) return null;
    return eligible.first;
  }

  Player? getCurrentStarter(GameSession session) {
    final index = session.starterIndex;
    if (index < 0 || index >= session.players.length) return null;
    return session.players[index];
  }

  int calculateNextStarterIndex(GameSession session) {
    final n = session.players.length;
    if (n == 0) return 0;

    switch (session.config.starterMode) {
      case StarterMode.rotation:
        return (session.starterIndex + 1) % n;
      case StarterMode.random:
        return Random().nextInt(n);
      case StarterMode.manual:
        return session.starterIndex;
    }
  }

  bool isGameFinished(GameSession session) {
    return session.players
        .any((p) => p.score >= session.config.targetScore);
  }

  int _reverseStarterIndex(GameSession session) {
    final n = session.players.length;
    if (n == 0) return 0;

    switch (session.config.starterMode) {
      case StarterMode.rotation:
        return (session.starterIndex - 1 + n) % n;
      case StarterMode.random:
        return session.starterIndex;
      case StarterMode.manual:
        return session.starterIndex;
    }
  }

  bool _anyPlayerReachedTarget(List<Player> players, int targetScore) {
    return players.any((p) => p.score >= targetScore);
  }
}
