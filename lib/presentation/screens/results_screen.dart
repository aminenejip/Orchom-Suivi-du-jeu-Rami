import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/media_storage.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/player_score_card.dart';
import '../widgets/round_history_card.dart';

class ResultsScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;

  const ResultsScreen({
    required this.controller,
    required this.settingsController,
    super.key,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _commentController = TextEditingController();
  final _picker = ImagePicker();
  final _mediaStorage = MediaStorage();
  final List<String> _photoPaths = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _commentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _takePhoto() async {
    final xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile == null) return;
    await _savePhoto(xFile.path);
  }

  Future<void> _choosePhoto() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    await _savePhoto(xFile.path);
  }

  Future<void> _savePhoto(String sourcePath) async {
    try {
      final savedPath = await _mediaStorage.saveImageFile(sourcePath);
      if (!mounted) return;
      setState(() {
        _photoPaths.add(savedPath);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur lors de l\'enregistrement de la photo: $e')),
      );
    }
  }

  Future<void> _deletePhoto(int index) async {
    setState(() {
      _photoPaths.removeAt(index);
    });
  }

  Future<void> _finishAndGoHome() async {
    final comment = _commentController.text.trim();
    try {
      await widget.controller.updateFinalDetails(
        finalComment: comment.isEmpty ? null : comment,
        photoPaths: _photoPaths.isEmpty ? null : _photoPaths,
      );
      await widget.controller.finishCurrentGame();
      if (!mounted) return;
      widget.controller.loadActiveSession();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.controller.currentSession;
    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Résultats')),
        body: const Center(child: Text('Aucune partie')),
      );
    }

    final winner = widget.controller.getWinner();
    final loser = widget.controller.getLoser();

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (winner != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 48,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Gagnant',
                      style: AppTextStyles.labelMd.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      winner.name,
                      style: AppTextStyles.scoreDisplay.copyWith(
                        fontSize: 36,
                        height: 36 / 36,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Score: ${winner.score}',
                      style: AppTextStyles.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            if (loser != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_downward,
                        size: 20, color: AppColors.error),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Perdant: ${loser.name} (${loser.score})',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Scores finaux',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 20,
                height: 28 / 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...session.players.map((p) {
              final isWinner = p.id == winner?.id;
              final isLoser = p.id == loser?.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child:
                    PlayerScoreCard(player: p, isWinner: isWinner, isLoser: isLoser),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Historique des manches',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 20,
                height: 28 / 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...session.rounds.map(
              (round) =>
                  RoundHistoryCard(round: round, players: session.players),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Commentaire et photos',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 20,
                height: 28 / 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Commentaire final',
                hintText: 'Ajouter un commentaire...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt, size: 20),
                    label: const Text('Photo'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _choosePhoto,
                    icon: const Icon(Icons.photo_library, size: 20),
                    label: const Text('Galerie'),
                  ),
                ),
              ],
            ),
            if (_photoPaths.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photoPaths.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final path = _photoPaths[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _deletePhoto(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _finishAndGoHome,
                icon: const Icon(Icons.save),
                label:
                    const Text('Terminer et enregistrer dans historique'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
