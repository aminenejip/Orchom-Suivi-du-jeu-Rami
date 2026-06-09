import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/media_storage.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
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
  final List<Uint8List> _photoBytes = [];
  bool _isSaving = false;

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
    final granted = await _requestCameraPermission();
    if (!granted) return;
    try {
      final xFile = await _picker.pickImage(source: ImageSource.camera);
      if (xFile == null) return;
      await _savePhoto(xFile);
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Erreur appareil photo',
        type: ToastType.error,
      );
    }
  }

  Future<void> _choosePhoto() async {
    final granted = await _requestGalleryPermission();
    if (!granted) return;
    try {
      final xFile = await _picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) return;
      await _savePhoto(xFile);
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Erreur galerie',
        type: ToastType.error,
      );
    }
  }

  Future<bool> _requestGalleryPermission() async {
    var status = await Permission.photos.request();
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      final open = await OrchomDialog.confirm(
        context: context,
        title: 'Autorisation requise',
        message:
            'L\'application a besoin d\'accéder à vos photos. Ouvrez les paramètres pour autoriser.',
        confirmLabel: 'Paramètres',
        cancelLabel: 'Fermer',
      );
      if (open == true) {
        await openAppSettings();
      }
      return false;
    }

    if (!mounted) return false;
    OrchomToast.show(
      context: context,
      message: 'Autorisation d\'accès aux photos refusée',
      type: ToastType.warning,
    );
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      final open = await OrchomDialog.confirm(
        context: context,
        title: 'Autorisation requise',
        message:
            'L\'application a besoin d\'accéder à la caméra. Ouvrez les paramètres pour autoriser.',
        confirmLabel: 'Paramètres',
        cancelLabel: 'Fermer',
      );
      if (open == true) {
        await openAppSettings();
      }
      return false;
    }

    if (!mounted) return false;
    OrchomToast.show(
      context: context,
      message: 'Autorisation d\'accès à la caméra refusée',
      type: ToastType.warning,
    );
    return false;
  }

  Future<void> _savePhoto(XFile xFile) async {
    try {
      final savedPath = await _mediaStorage.saveImageFile(xFile);
      final savedFile = File(savedPath);
      final bytes = await savedFile.readAsBytes();

      try {
        final codec = await ui.instantiateImageCodec(bytes);
        codec.dispose();
      } catch (_) {
        if (!mounted) return;
        OrchomToast.show(
          context: context,
          message: 'Cette image n\'est pas compatible',
          type: ToastType.error,
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _photoPaths.add(savedPath);
        _photoBytes.add(bytes);
      });
    } catch (_) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: 'Cette image n\'est pas compatible',
        type: ToastType.error,
      );
    }
  }

  void _deletePhoto(int index) {
    setState(() {
      _photoPaths.removeAt(index);
      _photoBytes.removeAt(index);
    });
  }

  Future<void> _finishAndGoHome() async {
    setState(() => _isSaving = true);
    final comment = _commentController.text.trim();
    try {
      await widget.controller.updateFinalDetails(
        finalComment: comment.isEmpty ? null : comment,
        photoPaths: _photoPaths.isEmpty ? null : _photoPaths,
      );
      await widget.controller.finishCurrentGame();
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      OrchomToast.show(
        context: context,
        message: widget.controller.errorMessage ?? 'Erreur lors de la sauvegarde',
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.controller.currentSession;
    if (session == null) {
      return Scaffold(
        appBar: OrchomAppBar(title: 'Résultats'),
        body: const OrchomEmptyState(
          icon: Icons.emoji_events_rounded,
          title: 'Aucune partie',
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final winner = widget.controller.getWinner();
    final loser = widget.controller.getLoser();

    return Scaffold(
      appBar: OrchomAppBar(title: 'Résultats'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [AppColors.lightBg, AppColors.lightSurfaceContainer],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (winner != null) _buildWinnerSection(winner, isDark),
              if (loser != null) _buildLoserSection(loser, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildFinalScoresSection(session, winner, loser),
              const SizedBox(height: AppSpacing.lg),
              _buildRoundHistorySection(session),
              const SizedBox(height: AppSpacing.lg),
              _buildPhotoSection(isDark),
              const SizedBox(height: AppSpacing.lg),
              OrchomButton(
                label: 'Terminer et enregistrer',
                icon: Icons.save_rounded,
                loading: _isSaving,
                onPressed: _isSaving ? null : _finishAndGoHome,
                height: 56,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWinnerSection(dynamic winner, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.scoreGold.withValues(alpha: 0.15),
            AppColors.scoreGold.withValues(alpha: 0.03),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.scoreGold.withValues(alpha: 0.25),
        ),
        boxShadow: isDark ? AppShadows.glowGold : null,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.scoreGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 48,
              color: AppColors.scoreGold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gagnant',
            style: AppTextStyles.label.copyWith(
              color: AppColors.scoreGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            winner.name,
            style: AppTextStyles.displayMd.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Score: ${winner.score}',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.scoreGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoserSection(dynamic loser, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.scoreDanger.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: AppColors.scoreDanger.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.scoreDanger.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.arrow_downward_rounded,
                size: 16,
                color: AppColors.scoreDanger,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Perdant: ${loser.name} (${loser.score})',
              style: AppTextStyles.body.copyWith(
                color: AppColors.scoreDanger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalScoresSection(dynamic session, dynamic winner, dynamic loser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrchomSectionTitle(title: 'Scores finaux'),
        const SizedBox(height: AppSpacing.sm),
        ...session.players.map((p) {
          final isWinner = p.id == winner?.id;
          final isLoser = p.id == loser?.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: PlayerScoreCard(
              player: p,
              isWinner: isWinner,
              isLoser: isLoser,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRoundHistorySection(dynamic session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrchomSectionTitle(title: 'Historique des manches'),
        const SizedBox(height: AppSpacing.sm),
        ...session.rounds.map(
          (round) => RoundHistoryCard(
            round: round,
            players: session.players,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrchomSectionTitle(
          title: 'Commentaire et photos',
          subtitle: 'Ajoutez un commentaire ou une photo pour cette partie',
        ),
        const SizedBox(height: AppSpacing.sm),
        OrchomCard(
          child: OrchomTextField(
            controller: _commentController,
            label: 'Commentaire final',
            hint: 'Ajouter un commentaire...',
            maxLines: 3,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OrchomButton(
                label: 'Photo',
                icon: Icons.camera_alt_rounded,
                variant: ButtonVariant.outline,
                onPressed: _takePhoto,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OrchomButton(
                label: 'Galerie',
                icon: Icons.photo_library_rounded,
                onPressed: _choosePhoto,
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
                final bytes = index < _photoBytes.length ? _photoBytes[index] : null;
                if (bytes == null) return const SizedBox.shrink();
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: Image.memory(
                        bytes,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) {
                          return Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceHigh
                                  : AppColors.lightSurfaceHigh,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _deletePhoto(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close_rounded,
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
      ],
    );
  }
}
