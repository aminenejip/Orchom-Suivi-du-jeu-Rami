import 'package:flutter/material.dart';
import 'application/game_controller.dart';
import 'application/game_settings_controller.dart';
import 'data/local/app_database.dart';
import 'data/local/database_init.dart';
import 'data/repositories/game_repository_impl.dart';
import 'data/repositories/game_settings_repository_impl.dart';
import 'domain/services/game_engine.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabaseFactory();
  final database = AppDatabase();
  final gameRepository = GameRepositoryImpl(database);
  final engine = GameEngine();
  final gameController = GameController(engine: engine, repository: gameRepository);
  final settingsRepository = GameSettingsRepositoryImpl(database);
  final settingsController = GameSettingsController(repository: settingsRepository);
  await settingsController.loadSettings();
  runApp(MyApp(
    controller: gameController,
    settingsController: settingsController,
  ));
}

class MyApp extends StatelessWidget {
  final GameController controller;
  final GameSettingsController settingsController;

  const MyApp({
    required this.controller,
    required this.settingsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orchom',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        controller: controller,
        settingsController: settingsController,
      ),
    );
  }
}
