import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Orchom'**
  String get appTitle;

  /// Subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Rami Tunisien Score Book'**
  String get homeSubtitle;

  /// Button to start a new game
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// Button to resume an active game
  ///
  /// In en, this message translates to:
  /// **'Resume Game'**
  String get resumeGame;

  /// Button/section label for history
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Button/section label for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Section title for player count selection
  ///
  /// In en, this message translates to:
  /// **'Number of Players'**
  String get numberOfPlayers;

  /// Subtitle for player count selection
  ///
  /// In en, this message translates to:
  /// **'Choose between 2 or 4 players'**
  String get numberOfPlayersSubtitle;

  /// Player count option
  ///
  /// In en, this message translates to:
  /// **'{count} Players'**
  String playersCount(int count);

  /// Section title for entering player names
  ///
  /// In en, this message translates to:
  /// **'Player Names'**
  String get playerNames;

  /// Subtitle for player names
  ///
  /// In en, this message translates to:
  /// **'Give a name to each player'**
  String get playerNamesSubtitle;

  /// Label for player text field
  ///
  /// In en, this message translates to:
  /// **'Player {number}'**
  String playerLabel(int number);

  /// Hint for player name input
  ///
  /// In en, this message translates to:
  /// **'Enter player {number} name'**
  String playerHint(int number);

  /// Validation error for empty name
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get nameRequired;

  /// Section and field label for target score
  ///
  /// In en, this message translates to:
  /// **'Target Score'**
  String get targetScore;

  /// Subtitle for target score
  ///
  /// In en, this message translates to:
  /// **'The score to reach to win'**
  String get targetScoreSubtitle;

  /// Hint for target score input
  ///
  /// In en, this message translates to:
  /// **'Between 1 and 10000'**
  String get targetScoreHint;

  /// Validation error for target score
  ///
  /// In en, this message translates to:
  /// **'Between 1 and 10000'**
  String get targetScoreError;

  /// Button to start the game
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// Error message for invalid player score
  ///
  /// In en, this message translates to:
  /// **'Invalid score for {name}'**
  String invalidScore(String name);

  /// Generic game label
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// Empty state when no game is active
  ///
  /// In en, this message translates to:
  /// **'No active game'**
  String get noActiveGame;

  /// Label when game is finished
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Round number label
  ///
  /// In en, this message translates to:
  /// **'Round {number}'**
  String roundLabel(int number);

  /// Target score badge
  ///
  /// In en, this message translates to:
  /// **'Target: {score}'**
  String targetLabel(int score);

  /// Current dealer/ starter label
  ///
  /// In en, this message translates to:
  /// **'Dealer: {name}'**
  String dealerLabel(String name);

  /// Section title for player ranking
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// Section title for score input
  ///
  /// In en, this message translates to:
  /// **'Score Entry'**
  String get scoreEntry;

  /// Subtitle for score input
  ///
  /// In en, this message translates to:
  /// **'Enter each player score'**
  String get scoreEntrySubtitle;

  /// Player current score label
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreLabel(int score);

  /// Hint text for score input field
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get scoreHint;

  /// Button to view game results
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get viewResults;

  /// Button to submit current round scores
  ///
  /// In en, this message translates to:
  /// **'Validate Round'**
  String get validateRound;

  /// Button to undo the last round
  ///
  /// In en, this message translates to:
  /// **'Undo Last Round'**
  String get undoLastRound;

  /// Number of rounds played
  ///
  /// In en, this message translates to:
  /// **'{count} round(s)'**
  String roundsCount(int count);

  /// Error message when camera fails
  ///
  /// In en, this message translates to:
  /// **'Camera error'**
  String get cameraError;

  /// Error message when gallery fails
  ///
  /// In en, this message translates to:
  /// **'Gallery error'**
  String get galleryError;

  /// Dialog title for permission request
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionRequired;

  /// Message for gallery permission dialog
  ///
  /// In en, this message translates to:
  /// **'App needs access to your photos. Open settings to allow.'**
  String get galleryPermissionMessage;

  /// Message for camera permission dialog
  ///
  /// In en, this message translates to:
  /// **'App needs access to the camera. Open settings to allow.'**
  String get cameraPermissionMessage;

  /// Button to open system settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// Button to close dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Warning when photo permission denied
  ///
  /// In en, this message translates to:
  /// **'Photo access denied'**
  String get photoAccessDenied;

  /// Warning when camera permission denied
  ///
  /// In en, this message translates to:
  /// **'Camera access denied'**
  String get cameraAccessDenied;

  /// Error when image format is not supported
  ///
  /// In en, this message translates to:
  /// **'This image is not compatible'**
  String get imageNotCompatible;

  /// Generic error message when saving fails
  ///
  /// In en, this message translates to:
  /// **'Error saving'**
  String get saveError;

  /// AppBar title for results screen
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// Empty state when no game data
  ///
  /// In en, this message translates to:
  /// **'No game'**
  String get noGame;

  /// Button to finish game and save
  ///
  /// In en, this message translates to:
  /// **'Finish & Save'**
  String get finishAndSave;

  /// Label for the winner
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winner;

  /// Winner score display
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String winnerScore(int score);

  /// Loser information
  ///
  /// In en, this message translates to:
  /// **'Loser: {name} ({score})'**
  String loserLabel(String name, int score);

  /// Section title for final scores
  ///
  /// In en, this message translates to:
  /// **'Final Scores'**
  String get finalScores;

  /// Section title for round history
  ///
  /// In en, this message translates to:
  /// **'Round History'**
  String get roundHistory;

  /// Section title for comment and photos
  ///
  /// In en, this message translates to:
  /// **'Comment & Photos'**
  String get commentAndPhotos;

  /// Subtitle for comment and photos section
  ///
  /// In en, this message translates to:
  /// **'Add a comment or photo for this game'**
  String get commentAndPhotosSubtitle;

  /// TextField label for final comment
  ///
  /// In en, this message translates to:
  /// **'Final Comment'**
  String get finalComment;

  /// Hint for comment text field
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get commentHint;

  /// Button to take a photo
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// Button to choose from gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Button/dialog title for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation message for deleting a game
  ///
  /// In en, this message translates to:
  /// **'Delete this game from history?'**
  String get deleteGameConfirm;

  /// Success message after deleting game
  ///
  /// In en, this message translates to:
  /// **'Game deleted'**
  String get gameDeleted;

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Dialog title for clearing all history
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// Warning message for clearing history
  ///
  /// In en, this message translates to:
  /// **'All games will be permanently deleted.'**
  String get clearHistoryMessage;

  /// Button to confirm deleting all
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// Success message after clearing history
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// Empty state when no games in history
  ///
  /// In en, this message translates to:
  /// **'No completed games'**
  String get noCompletedGames;

  /// Subtitle for empty history
  ///
  /// In en, this message translates to:
  /// **'Finish a game to see it here'**
  String get noCompletedGamesSubtitle;

  /// Number of players in a game
  ///
  /// In en, this message translates to:
  /// **'{count} players'**
  String playersCountLabel(int count);

  /// Target score display in history card
  ///
  /// In en, this message translates to:
  /// **'Target: {score}'**
  String targetScoreLabel(int score);

  /// Winner display in history card
  ///
  /// In en, this message translates to:
  /// **'Winner: {name}'**
  String winnerLabel(String name);

  /// Loser display in history card
  ///
  /// In en, this message translates to:
  /// **'Loser: {name}'**
  String loserLabelShort(String name);

  /// Success message after adding quick button
  ///
  /// In en, this message translates to:
  /// **'Button added'**
  String get buttonAdded;

  /// Confirmation message for deleting a button
  ///
  /// In en, this message translates to:
  /// **'Delete this quick button?'**
  String get deleteButtonConfirm;

  /// Success message after deleting button
  ///
  /// In en, this message translates to:
  /// **'Button deleted'**
  String get buttonDeleted;

  /// Button/dialog title for reset action
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Message for reset confirmation
  ///
  /// In en, this message translates to:
  /// **'All settings will return to defaults.'**
  String get resetMessage;

  /// Success message after resetting settings
  ///
  /// In en, this message translates to:
  /// **'Settings reset'**
  String get settingsReset;

  /// Section title for appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Subtitle for appearance section
  ///
  /// In en, this message translates to:
  /// **'Customize app appearance'**
  String get appearanceSubtitle;

  /// Section title for game settings
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameSection;

  /// Subtitle for game settings section
  ///
  /// In en, this message translates to:
  /// **'Default game configuration'**
  String get gameSectionSubtitle;

  /// Label for dealer mode setting
  ///
  /// In en, this message translates to:
  /// **'Default dealer mode'**
  String get defaultDealerMode;

  /// Section title for quick buttons
  ///
  /// In en, this message translates to:
  /// **'Quick Buttons'**
  String get quickButtons;

  /// Subtitle for quick buttons section
  ///
  /// In en, this message translates to:
  /// **'Customize quick score buttons'**
  String get quickButtonsSubtitle;

  /// Empty state for quick buttons
  ///
  /// In en, this message translates to:
  /// **'No buttons configured'**
  String get noButtons;

  /// Subtitle for empty buttons state
  ///
  /// In en, this message translates to:
  /// **'Add your quick score buttons'**
  String get noButtonsSubtitle;

  /// Quick button value display
  ///
  /// In en, this message translates to:
  /// **'Value: {value}'**
  String buttonValue(int value);

  /// Dropdown label for sound selection
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Tooltip for sound preview button
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Warning when no sound is selected
  ///
  /// In en, this message translates to:
  /// **'No sound selected'**
  String get noSoundSelected;

  /// Section title and button label for adding a button
  ///
  /// In en, this message translates to:
  /// **'Add Button'**
  String get addButton;

  /// Subtitle for add button section
  ///
  /// In en, this message translates to:
  /// **'Create a quick score button'**
  String get addButtonSubtitle;

  /// TextField label for button label
  ///
  /// In en, this message translates to:
  /// **'Button Label'**
  String get buttonLabel;

  /// Hint for button label input
  ///
  /// In en, this message translates to:
  /// **'Ex: Kmalt'**
  String get buttonLabelHint;

  /// TextField label for button value
  ///
  /// In en, this message translates to:
  /// **'Button Value'**
  String get buttonValueField;

  /// Hint for button value input
  ///
  /// In en, this message translates to:
  /// **'Ex: -10 or 50'**
  String get buttonValueHint;

  /// Button to reset all settings
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// Rotation starter mode
  ///
  /// In en, this message translates to:
  /// **'Rotation'**
  String get rotation;

  /// Random starter mode
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// Manual starter mode
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// Light theme option title
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Light theme option subtitle
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// Dark theme option title
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Dark theme option subtitle
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// System theme option title
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// System theme option subtitle
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// Loser badge label
  ///
  /// In en, this message translates to:
  /// **'Loser'**
  String get loser;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Search bar hint text
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// Default confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Default cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Error when player name is empty
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameEmptyError;

  /// Error when player name is duplicate
  ///
  /// In en, this message translates to:
  /// **'Another player already has this name'**
  String get nameDuplicateError;

  /// Error when button label is empty
  ///
  /// In en, this message translates to:
  /// **'Label cannot be empty'**
  String get labelEmptyError;

  /// Error when button label is duplicate
  ///
  /// In en, this message translates to:
  /// **'A button with label \"{label}\" already exists'**
  String labelDuplicateError(String label);

  /// Error when sound ID is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid sound \"{soundId}\"'**
  String invalidSoundError(String soundId);

  /// Error when button is not found
  ///
  /// In en, this message translates to:
  /// **'Button \"{buttonId}\" not found'**
  String buttonNotFoundError(String buttonId);

  /// Error when image cannot be decoded
  ///
  /// In en, this message translates to:
  /// **'Cannot decode this image. Supported formats: JPEG, PNG, WebP, HEIC (Android/iOS).'**
  String get imageDecodeError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
