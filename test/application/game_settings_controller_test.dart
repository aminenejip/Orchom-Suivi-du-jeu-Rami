import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/application/game_settings_controller.dart';
import 'package:orchom/data/local/app_database.dart';
import 'package:orchom/data/repositories/game_settings_repository_impl.dart';
import 'package:orchom/domain/enums/starter_mode.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDatabase;
  late GameSettingsController controller;

  setUp(() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    appDatabase = AppDatabase(databaseName: 'test_contr_$timestamp.db');
    final repository = GameSettingsRepositoryImpl(appDatabase);
    controller = GameSettingsController(repository: repository);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  group('GameSettingsController', () {
    test('loadSettings returns defaults initially', () async {
      await controller.loadSettings();

      expect(controller.settings.quickScoreButtons, hasLength(4));
      expect(controller.settings.defaultGhaltaPenalty, 50);
      expect(controller.settings.defaultStarterMode, StarterMode.rotation);
      expect(controller.errorMessage, isNull);
    });

    test('addQuickScoreButton adds a button and preserves other settings', () async {
      await controller.loadSettings();
      final initialCount = controller.settings.quickScoreButtons.length;

      await controller.addQuickScoreButton('Custom', 99);

      expect(controller.settings.quickScoreButtons, hasLength(initialCount + 1));
      expect(
        controller.settings.quickScoreButtons.last.label,
        'Custom',
      );
      expect(controller.settings.defaultGhaltaPenalty, 50);
    });

    test('addQuickScoreButton refuses empty label', () async {
      await controller.loadSettings();

      expect(
        () => controller.addQuickScoreButton('  ', 10),
        throwsArgumentError,
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('addQuickScoreButton refuses duplicate label', () async {
      await controller.loadSettings();

      await controller.addQuickScoreButton('Custom', 10);

      expect(
        () => controller.addQuickScoreButton('Custom', 20),
        throwsArgumentError,
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('deleteQuickScoreButton removes a button', () async {
      await controller.loadSettings();
      await controller.addQuickScoreButton('MyButton', 5);
      final addedId = controller.settings.quickScoreButtons.last.id;

      await controller.deleteQuickScoreButton(addedId);

      expect(
        controller.settings.quickScoreButtons.any((b) => b.id == addedId),
        isFalse,
      );
    });

    test('resetSettings resets to defaults', () async {
      await controller.loadSettings();
      await controller.addQuickScoreButton('Extra', 1);

      await controller.resetSettings();

      expect(controller.settings.quickScoreButtons, hasLength(4));
      expect(controller.settings.quickScoreButtons[0].label, '-10');
      expect(controller.settings.defaultGhaltaPenalty, 50);
      expect(controller.settings.defaultStarterMode, StarterMode.rotation);
    });

    test('updateDefaultGhaltaPenalty updates the penalty', () async {
      await controller.loadSettings();

      await controller.updateDefaultGhaltaPenalty(200);

      expect(controller.settings.defaultGhaltaPenalty, 200);
    });

    test('updateDefaultGhaltaPenalty refuses value <= 0', () async {
      await controller.loadSettings();

      expect(
        () => controller.updateDefaultGhaltaPenalty(0),
        throwsArgumentError,
      );
      expect(controller.errorMessage, isNotNull);
    });

    test('updateDefaultStarterMode updates the starter mode', () async {
      await controller.loadSettings();

      await controller.updateDefaultStarterMode(StarterMode.random);

      expect(controller.settings.defaultStarterMode, StarterMode.random);
    });
  });
}
