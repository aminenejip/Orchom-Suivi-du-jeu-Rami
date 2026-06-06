import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:orchom/application/game_controller.dart';
import 'package:orchom/application/game_settings_controller.dart';
import 'package:orchom/data/local/app_database.dart';
import 'package:orchom/data/repositories/game_repository_impl.dart';
import 'package:orchom/data/repositories/game_settings_repository_impl.dart';
import 'package:orchom/domain/services/game_engine.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('App controllers can be created and communicate with database', () async {
    final database = AppDatabase();
    final gameRepository = GameRepositoryImpl(database);
    final engine = GameEngine();
    final gameController =
        GameController(engine: engine, repository: gameRepository);
    final settingsRepository = GameSettingsRepositoryImpl(database);
    final settingsController =
        GameSettingsController(repository: settingsRepository);
    await settingsController.loadSettings();

    expect(gameController, isNotNull);
    expect(settingsController, isNotNull);
    expect(settingsController.settings.quickScoreButtons, hasLength(4));
    expect(settingsController.settings.defaultGhaltaPenalty, 50);
    expect(settingsController.settings.defaultStarterMode, isNotNull);

    await database.close();
  });
}
