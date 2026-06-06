import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import '../../data/local/media_storage.dart';
import '../../domain/entities/player.dart';
import 'home_screen.dart';

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
        SnackBar(content: Text('Erreur lors de l\'enregistrement de la photo: $e')),
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            controller: widget.controller,
            settingsController: widget.settingsController,
          ),
        ),
        (route) => false,
      );
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
      appBar: AppBar(
        title: const Text('Résultats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gagnant: ${winner?.name ?? '-'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Perdant: ${loser?.name ?? '-'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Scores finaux:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...session.players.map((p) => Text('${p.name}: ${p.score}')),
            const SizedBox(height: 16),
            Text(
              'Historique complet des manches:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...session.rounds.map((round) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manche ${round.roundNumber}:'),
                    ...round.scoresByPlayerId.entries.map((entry) {
                      final player = session.players.firstWhere(
                        (p) => p.id == entry.key,
                        orElse: () => Player(id: entry.key, name: '?'),
                      );
                      return Text('  ${player.name}: ${entry.value}');
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Commentaire et photos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Commentaire final',
                border: OutlineInputBorder(),
                hintText: 'Ajouter un commentaire...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Prendre une photo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _choosePhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choisir une photo'),
                  ),
                ),
              ],
            ),
            if (_photoPaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._photoPaths.asMap().entries.map((entry) {
                final index = entry.key;
                final path = entry.value;
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(path),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    title: Text(
                      path.split('\\').last.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePhoto(index),
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finishAndGoHome,
                child: const Text('Terminer et enregistrer dans historique'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
