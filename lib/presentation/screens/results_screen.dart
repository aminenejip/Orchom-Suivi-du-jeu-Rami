import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final List<Uint8List> _photoBytes = [];

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur appareil photo: $e')),
      );
    }
  }

  Future<void> _choosePhoto() async {
    debugPrint('[DIAG] _choosePhoto CALLED');
    final granted = await _requestGalleryPermission();
    debugPrint('[DIAG] Permission granted: $granted');
    if (!granted) return;
    try {
      final xFile = await _picker.pickImage(source: ImageSource.gallery);
      debugPrint('[DIAG] Picked file is null: ${xFile == null}');
      debugPrint('[DIAG] Picked file path: ${xFile?.path}');
      debugPrint('[DIAG] Picked file name: ${xFile?.name}');
      if (xFile == null) return;
      await _savePhoto(xFile);
    } catch (e) {
      debugPrint('[DIAG] _choosePhoto exception: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur galerie: $e')),
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
      final open = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Autorisation requise'),
          content: const Text(
            'L\'application a besoin d\'accéder à vos photos. '
            'Ouvrez les paramètres pour autoriser.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Fermer'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Paramètres'),
            ),
          ],
        ),
      );
      if (open == true) {
        await openAppSettings();
      }
      return false;
    }

    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Autorisation d\'accès aux photos refusée'),
      ),
    );
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      final open = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Autorisation requise'),
          content: const Text(
            'L\'application a besoin d\'accéder à la caméra. '
            'Ouvrez les paramètres pour autoriser.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Fermer'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Paramètres'),
            ),
          ],
        ),
      );
      if (open == true) {
        await openAppSettings();
      }
      return false;
    }

    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Autorisation d\'accès à la caméra refusée'),
      ),
    );
    return false;
  }

  Future<void> _savePhoto(XFile xFile) async {
    try {
      debugPrint('[DIAG] _savePhoto CALLED');
      debugPrint('[DIAG] XFile path: ${xFile.path}');
      debugPrint('[DIAG] XFile name: ${xFile.name}');

      final rawBytes = await xFile.readAsBytes();
      debugPrint('[DIAG] Raw bytes length: ${rawBytes.length}');

      // Magic bytes diagnostic
      final hexBytes = rawBytes
          .take(16)
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join(' ');
      debugPrint('[DIAG] Magic bytes (first 16): $hexBytes');

      // Detect format from magic bytes
      String detectedFormat = 'Unknown';
      if (rawBytes.length >= 3 &&
          rawBytes[0] == 0xFF &&
          rawBytes[1] == 0xD8 &&
          rawBytes[2] == 0xFF) {
        detectedFormat = 'JPEG';
      } else if (rawBytes.length >= 8 &&
          rawBytes[0] == 0x89 &&
          rawBytes[1] == 0x50 &&
          rawBytes[2] == 0x4E &&
          rawBytes[3] == 0x47) {
        detectedFormat = 'PNG';
      } else if (rawBytes.length >= 12 &&
          rawBytes[0] == 0x52 &&
          rawBytes[1] == 0x49 &&
          rawBytes[2] == 0x46 &&
          rawBytes[3] == 0x46) {
        final webpSignature = String.fromCharCodes(rawBytes.skip(8).take(4));
        detectedFormat = 'WEBP ($webpSignature)';
      } else if (rawBytes.length >= 12) {
        final ftyp = String.fromCharCodes(rawBytes.skip(4).take(12));
        if (ftyp.startsWith('ftyp')) {
          detectedFormat = 'HEIC/HEIF/AVIF ($ftyp)';
        }
      }
      debugPrint('[DIAG] Detected format: $detectedFormat');

      // Save (and convert to JPEG internally)
      final savedPath = await _mediaStorage.saveImageFile(xFile);
      debugPrint('[DIAG] Saved path: $savedPath');

      final savedFile = File(savedPath);
      final exists = await savedFile.exists();
      final length = await savedFile.length();
      debugPrint('[DIAG] Saved file exists: $exists');
      debugPrint('[DIAG] Saved file length: $length');

      final bytes = await savedFile.readAsBytes();
      debugPrint('[DIAG] Saved bytes length: ${bytes.length}');

      // Verify the saved file decodes correctly before adding to state
      try {
        final codec = await ui.instantiateImageCodec(bytes);
        debugPrint('[DIAG] Flutter codec OK: ${codec.frameCount} frames');
        codec.dispose();
      } catch (decodeError) {
        debugPrint('[DIAG] Saved bytes also fail to decode: $decodeError');
        debugPrint('[DIAG] image path: ${xFile.path}');
        debugPrint('[DIAG] image name: ${xFile.name}');
        debugPrint('[DIAG] extension: ${xFile.name.split('.').last}');
        debugPrint('[DIAG] magic bytes: $hexBytes');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Cette image n\'est pas compatible. Choisis une autre image.'),
          ),
        );
        return;
      }

      debugPrint('[DIAG] _photoPaths length before setState: ${_photoPaths.length}');
      debugPrint('[DIAG] _photoBytes length before setState: ${_photoBytes.length}');
      debugPrint('[DIAG] mounted: $mounted');

      if (!mounted) return;
      setState(() {
        _photoPaths.add(savedPath);
        _photoBytes.add(bytes);
      });

      debugPrint('[DIAG] _photoPaths length after setState: ${_photoPaths.length}');
      debugPrint('[DIAG] _photoBytes length after setState: ${_photoBytes.length}');
    } catch (e) {
      debugPrint('[DIAG] _savePhoto error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Cette image n\'est pas compatible. Choisis une autre image.'),
        ),
      );
    }
  }

  Future<void> _deletePhoto(int index) async {
    setState(() {
      _photoPaths.removeAt(index);
      _photoBytes.removeAt(index);
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
                    debugPrint('[DIAG] Rendering image index: $index');
                    debugPrint('[DIAG] _photoPaths length: ${_photoPaths.length}, _photoBytes length: ${_photoBytes.length}');
                    final bytes = index < _photoBytes.length ? _photoBytes[index] : null;
                    debugPrint('[DIAG] Bytes is null: ${bytes == null}');
                    if (bytes != null) debugPrint('[DIAG] Bytes length: ${bytes.length}');
                    if (bytes == null) return const SizedBox.shrink();
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            bytes,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) {
                              debugPrint('[DIAG] Image.memory error: $error');
                              return Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.broken_image),
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
