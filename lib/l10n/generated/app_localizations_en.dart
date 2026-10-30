// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Orchom';

  @override
  String get homeSubtitle => 'Rami Tunisien Score Book';

  @override
  String get newGame => 'New Game';

  @override
  String get resumeGame => 'Resume Game';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get numberOfPlayers => 'Number of Players';

  @override
  String get numberOfPlayersSubtitle => 'Choose between 2 or 4 players';

  @override
  String playersCount(int count) {
    return '$count Players';
  }

  @override
  String get playerNames => 'Player Names';

  @override
  String get playerNamesSubtitle => 'Give a name to each player';

  @override
  String playerLabel(int number) {
    return 'Player $number';
  }

  @override
  String playerHint(int number) {
    return 'Enter player $number name';
  }

  @override
  String get nameRequired => 'Name required';

  @override
  String get targetScore => 'Target Score';

  @override
  String get targetScoreSubtitle => 'The score to reach to win';

  @override
  String get targetScoreHint => 'Between 1 and 10000';

  @override
  String get targetScoreError => 'Between 1 and 10000';

  @override
  String get startGame => 'Start Game';

  @override
  String invalidScore(String name) {
    return 'Invalid score for $name';
  }

  @override
  String get game => 'Game';

  @override
  String get noActiveGame => 'No active game';

  @override
  String get gameOver => 'Game Over';

  @override
  String roundLabel(int number) {
    return 'Round $number';
  }

  @override
  String targetLabel(int score) {
    return 'Target: $score';
  }

  @override
  String dealerLabel(String name) {
    return 'Dealer: $name';
  }

  @override
  String get ranking => 'Ranking';

  @override
  String get scoreEntry => 'Score Entry';

  @override
  String get scoreEntrySubtitle => 'Enter each player score';

  @override
  String scoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String get scoreHint => '0';

  @override
  String get viewResults => 'View Results';

  @override
  String get validateRound => 'Validate Round';

  @override
  String get undoLastRound => 'Undo Last Round';

  @override
  String roundsCount(int count) {
    return '$count round(s)';
  }

  @override
  String get cameraError => 'Camera error';

  @override
  String get galleryError => 'Gallery error';

  @override
  String get permissionRequired => 'Permission required';

  @override
  String get galleryPermissionMessage =>
      'App needs access to your photos. Open settings to allow.';

  @override
  String get cameraPermissionMessage =>
      'App needs access to the camera. Open settings to allow.';

  @override
  String get settingsButton => 'Settings';

  @override
  String get close => 'Close';

  @override
  String get photoAccessDenied => 'Photo access denied';

  @override
  String get cameraAccessDenied => 'Camera access denied';

  @override
  String get imageNotCompatible => 'This image is not compatible';

  @override
  String get saveError => 'Error saving';

  @override
  String get results => 'Results';

  @override
  String get noGame => 'No game';

  @override
  String get finishAndSave => 'Finish & Save';

  @override
  String get winner => 'Winner';

  @override
  String winnerScore(int score) {
    return 'Score: $score';
  }

  @override
  String loserLabel(String name, int score) {
    return 'Loser: $name ($score)';
  }

  @override
  String get finalScores => 'Final Scores';

  @override
  String get roundHistory => 'Round History';

  @override
  String get commentAndPhotos => 'Comment & Photos';

  @override
  String get commentAndPhotosSubtitle => 'Add a comment or photo for this game';

  @override
  String get finalComment => 'Final Comment';

  @override
  String get commentHint => 'Add a comment...';

  @override
  String get photo => 'Photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get delete => 'Delete';

  @override
  String get deleteGameConfirm => 'Delete this game from history?';

  @override
  String get gameDeleted => 'Game deleted';

  @override
  String get error => 'Error';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryMessage => 'All games will be permanently deleted.';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get noCompletedGames => 'No completed games';

  @override
  String get noCompletedGamesSubtitle => 'Finish a game to see it here';

  @override
  String playersCountLabel(int count) {
    return '$count players';
  }

  @override
  String targetScoreLabel(int score) {
    return 'Target: $score';
  }

  @override
  String winnerLabel(String name) {
    return 'Winner: $name';
  }

  @override
  String loserLabelShort(String name) {
    return 'Loser: $name';
  }

  @override
  String get buttonAdded => 'Button added';

  @override
  String get deleteButtonConfirm => 'Delete this quick button?';

  @override
  String get buttonDeleted => 'Button deleted';

  @override
  String get reset => 'Reset';

  @override
  String get resetMessage => 'All settings will return to defaults.';

  @override
  String get settingsReset => 'Settings reset';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSubtitle => 'Customize app appearance';

  @override
  String get gameSection => 'Game';

  @override
  String get gameSectionSubtitle => 'Default game configuration';

  @override
  String get defaultDealerMode => 'Default dealer mode';

  @override
  String get quickButtons => 'Quick Buttons';

  @override
  String get quickButtonsSubtitle => 'Customize quick score buttons';

  @override
  String get noButtons => 'No buttons configured';

  @override
  String get noButtonsSubtitle => 'Add your quick score buttons';

  @override
  String buttonValue(int value) {
    return 'Value: $value';
  }

  @override
  String get sound => 'Sound';

  @override
  String get preview => 'Preview';

  @override
  String get noSoundSelected => 'No sound selected';

  @override
  String get addButton => 'Add Button';

  @override
  String get addButtonSubtitle => 'Create a quick score button';

  @override
  String get buttonLabel => 'Button Label';

  @override
  String get buttonLabelHint => 'Ex: Kmalt';

  @override
  String get buttonValueField => 'Button Value';

  @override
  String get buttonValueHint => 'Ex: -10 or 50';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get rotation => 'Rotation';

  @override
  String get random => 'Random';

  @override
  String get manual => 'Manual';

  @override
  String get light => 'Light';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get dark => 'Dark';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get system => 'System';

  @override
  String get followSystem => 'Follow system';

  @override
  String get loser => 'Loser';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search...';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get nameEmptyError => 'Name cannot be empty';

  @override
  String get nameDuplicateError => 'Another player already has this name';

  @override
  String get labelEmptyError => 'Label cannot be empty';

  @override
  String labelDuplicateError(String label) {
    return 'A button with label \"$label\" already exists';
  }

  @override
  String invalidSoundError(String soundId) {
    return 'Invalid sound \"$soundId\"';
  }

  @override
  String buttonNotFoundError(String buttonId) {
    return 'Button \"$buttonId\" not found';
  }

  @override
  String get imageDecodeError =>
      'Cannot decode this image. Supported formats: JPEG, PNG, WebP, HEIC (Android/iOS).';
}
