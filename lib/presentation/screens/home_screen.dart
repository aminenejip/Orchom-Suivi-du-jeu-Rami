import 'package:flutter/material.dart';
import '../../application/game_controller.dart';
import '../../application/game_settings_controller.dart';
import 'setup_screen.dart';
import 'game_screen.dart';
import 'history_screen.dart';
import 'game_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final GameController controller;
  final GameSettingsController settingsController;

  const HomeScreen({
    required this.controller,
    required this.settingsController,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {
        _hasActiveSession = widget.controller.currentSession != null;
      });
    }
  }

  Future<void> _load() async {
    await widget.controller.loadActiveSession();
    if (mounted) {
      setState(() {
        _hasActiveSession = widget.controller.currentSession != null;
      });
    }
  }

  Future<void> _navigateToSetup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetupScreen(
          controller: widget.controller,
          settingsController: widget.settingsController,
        ),
      ),
    );
    await _load();
  }

  Future<void> _navigateToGame() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          controller: widget.controller,
          settingsController: widget.settingsController,
        ),
      ),
    );
    await _load();
  }

  Future<void> _navigateToHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryScreen(controller: widget.controller),
      ),
    );
    await _load();
  }

  Future<void> _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameSettingsScreen(settingsController: widget.settingsController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchom'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateToSetup,
              child: const Text('Nouvelle partie'),
            ),
            const SizedBox(height: 16),
            if (_hasActiveSession)
              ElevatedButton(
                onPressed: _navigateToGame,
                child: const Text('Reprendre partie'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToHistory,
              child: const Text('Historique'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToSettings,
              child: const Text('Réglage des parties'),
            ),
          ],
        ),
      ),
    );
  }
}
