import 'dart:io';
import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import 'photo_preview_screen.dart';

class HistoryScreen extends StatefulWidget {
  final GameController controller;

  const HistoryScreen({required this.controller, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    widget.controller.loadHistory();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _deleteGame(String id) async {
    try {
      await widget.controller.deleteHistoryGame(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  Future<void> _clearHistory() async {
    try {
      await widget.controller.clearHistory();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  void _openPhoto(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (widget.controller.history.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Vider historique',
            ),
        ],
      ),
      body: widget.controller.history.isEmpty
          ? const Center(child: Text('Aucune partie terminée'))
          : ListView.builder(
              itemCount: widget.controller.history.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final game = widget.controller.history[index];
                final winner = widget.controller.engine.getWinner(game);
                final loser = widget.controller.engine.getLoser(game);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${game.createdAt.day}/${game.createdAt.month}/${game.createdAt.year}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _deleteGame(game.id),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${game.players.length} joueurs - Cible: ${game.config.targetScore}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.players
                              .map((p) => '${p.name}: ${p.score}')
                              .join(' | '),
                        ),
                        if (winner != null)
                          Text(
                            'Gagnant: ${winner.name}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        if (loser != null)
                          Text(
                            'Perdant: ${loser.name}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        if (game.finalComment != null &&
                            game.finalComment!.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          Text(
                            'Commentaire:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(game.finalComment!),
                        ],
                        if (game.photoPaths.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          Text(
                            'Photos:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: game.photoPaths.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final path = game.photoPaths[i];
                                return GestureDetector(
                                  onTap: () => _openPhoto(path),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(path),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          const SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
