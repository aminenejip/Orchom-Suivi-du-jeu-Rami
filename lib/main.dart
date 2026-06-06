import 'package:flutter/material.dart';
import 'application/game_controller.dart';
import 'application/game_settings_controller.dart';
import 'application/theme_controller.dart';
import 'data/local/app_database.dart';
import 'data/local/database_init.dart';
import 'data/local/quick_button_audio_service.dart';
import 'data/repositories/game_repository_impl.dart';
import 'data/repositories/game_settings_repository_impl.dart';
import 'domain/enums/app_theme_mode.dart';
import 'domain/services/game_engine.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OrchomApp());
}

class OrchomApp extends StatelessWidget {
  const OrchomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AppWithDependencies();
  }
}

class _AppWithDependencies extends StatefulWidget {
  const _AppWithDependencies();

  @override
  State<_AppWithDependencies> createState() => _AppWithDependenciesState();
}

class _AppWithDependenciesState extends State<_AppWithDependencies> {
  late final AppDatabase _database;
  late final GameController _gameController;
  late final GameSettingsController _settingsController;
  late final ThemeController _themeController;
  late final QuickButtonAudioService _audioService;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initializeDatabaseFactory();
    _database = AppDatabase();
    final gameRepository = GameRepositoryImpl(_database);
    final engine = GameEngine();
    _gameController = GameController(engine: engine, repository: gameRepository);
    final settingsRepository = GameSettingsRepositoryImpl(_database);
    _settingsController =
        GameSettingsController(repository: settingsRepository);
    await _settingsController.loadSettings();
    _audioService = QuickButtonAudioService();
    _themeController = ThemeController();
    _settingsController.addListener(_onSettingsChanged);
    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _settingsController.removeListener(_onSettingsChanged);
    _database.close();
    _gameController.dispose();
    _settingsController.dispose();
    _themeController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  ThemeMode _resolveThemeMode() {
    switch (_settingsController.settings.appThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Orchom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _resolveThemeMode(),
      home: HomeScreen(
        controller: _gameController,
        settingsController: _settingsController,
        themeController: _themeController,
        audioService: _audioService,
      ),
    );
  }
}
