// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Orchom';

  @override
  String get homeSubtitle => 'كورني السكور ديال الرامي';

  @override
  String get newGame => 'إبدا اللعب';

  @override
  String get resumeGame => 'واصل اللعب';

  @override
  String get history => 'التاريخ';

  @override
  String get settings => 'الإعدادات';

  @override
  String get numberOfPlayers => 'عدد اللاعبين';

  @override
  String get numberOfPlayersSubtitle => 'خيّر بين 2 ولا 4 لاعبين';

  @override
  String playersCount(int count) {
    return '$count لاعبين';
  }

  @override
  String get playerNames => 'أسماء اللاعبين';

  @override
  String get playerNamesSubtitle => 'أعطي إسم لكل لاعب';

  @override
  String playerLabel(int number) {
    return 'اللاعب $number';
  }

  @override
  String playerHint(int number) {
    return 'دخل إسم اللاعب $number';
  }

  @override
  String get nameRequired => 'الإسم مطلوب';

  @override
  String get targetScore => 'السكور المطلوب';

  @override
  String get targetScoreSubtitle => 'السكور اللي لازم توصل باش تربح';

  @override
  String get targetScoreHint => 'بين 1 و 10000';

  @override
  String get targetScoreError => 'بين 1 و 10000';

  @override
  String get startGame => 'ابدأ اللعب';

  @override
  String invalidScore(String name) {
    return 'السكور متاع $name مش صحيح';
  }

  @override
  String get game => 'اللعبة';

  @override
  String get noActiveGame => 'ما فماش لعبة';

  @override
  String get gameOver => 'وفات اللعبة';

  @override
  String roundLabel(int number) {
    return 'المانش $number';
  }

  @override
  String targetLabel(int score) {
    return 'الهدف: $score';
  }

  @override
  String dealerLabel(String name) {
    return 'الدونور: $name';
  }

  @override
  String get ranking => 'الترتيب';

  @override
  String get scoreEntry => 'دخول السكور';

  @override
  String get scoreEntrySubtitle => 'دخل سكور كل لاعب';

  @override
  String scoreLabel(int score) {
    return 'السكور: $score';
  }

  @override
  String get scoreHint => '0';

  @override
  String get viewResults => 'شوف النتيجة';

  @override
  String get validateRound => 'صادق على المانش';

  @override
  String get undoLastRound => 'الغي اخر مانش';

  @override
  String roundsCount(int count) {
    return '$count مانش(ات)';
  }

  @override
  String get cameraError => 'مشكل في الكاميرا';

  @override
  String get galleryError => 'مشكل في الكاليري';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get galleryPermissionMessage =>
      'الآب يحتاج للوصول للفوتوات. افتح الإعدادات باش تسمح.';

  @override
  String get cameraPermissionMessage =>
      'الآب يحتاج للوصول للكاميرا. افتح الإعدادات باش تسمح.';

  @override
  String get settingsButton => 'الإعدادات';

  @override
  String get close => 'أقفل';

  @override
  String get photoAccessDenied => 'الوصول للفوتوات مرفوض';

  @override
  String get cameraAccessDenied => 'الوصول للكاميرا مرفوض';

  @override
  String get imageNotCompatible => 'هذه الصورة مش متوافقة';

  @override
  String get saveError => 'مشكل في الحفظ';

  @override
  String get results => 'النتيجة';

  @override
  String get noGame => 'ما فماش لعبة';

  @override
  String get finishAndSave => 'خلص وسجل';

  @override
  String get winner => 'الرابح';

  @override
  String winnerScore(int score) {
    return 'السكور: $score';
  }

  @override
  String loserLabel(String name, int score) {
    return 'الخاسر: $name ($score)';
  }

  @override
  String get finalScores => 'السكور النهائي';

  @override
  String get roundHistory => 'تاريخ المانشات';

  @override
  String get commentAndPhotos => 'تعليق وفوتوات';

  @override
  String get commentAndPhotosSubtitle => 'زيد تعليق ولا فوتو لهذه اللعبة';

  @override
  String get finalComment => 'التعليق الأخير';

  @override
  String get commentHint => 'زيد تعليق...';

  @override
  String get photo => 'فوتو';

  @override
  String get gallery => 'كاليري';

  @override
  String get delete => 'احذف';

  @override
  String get deleteGameConfirm => 'تحذف هذه اللعبة من التاريخ؟';

  @override
  String get gameDeleted => 'اللعبة محذوفة';

  @override
  String get error => 'مشكل';

  @override
  String get clearHistory => 'فاضي التاريخ';

  @override
  String get clearHistoryMessage => 'كل اللعابات يحذفو نهائيا.';

  @override
  String get deleteAll => 'احذف الكل';

  @override
  String get historyCleared => 'التاريخ مفروغ';

  @override
  String get noCompletedGames => 'ما فماش لعابات مكملة';

  @override
  String get noCompletedGamesSubtitle => 'كمل لعبة باش تشوفها هنا';

  @override
  String playersCountLabel(int count) {
    return '$count لاعبين';
  }

  @override
  String targetScoreLabel(int score) {
    return 'الهدف: $score';
  }

  @override
  String winnerLabel(String name) {
    return 'الرابح: $name';
  }

  @override
  String loserLabelShort(String name) {
    return 'الخاسر: $name';
  }

  @override
  String get buttonAdded => 'البوتون مضاف';

  @override
  String get deleteButtonConfirm => 'تحذف هذا البوتون السريع؟';

  @override
  String get buttonDeleted => 'البوتون محذوف';

  @override
  String get reset => 'رجع للوضعية الأولى';

  @override
  String get resetMessage => 'كل الإعدادات ترجع للوضعية الأولى.';

  @override
  String get settingsReset => 'الإعدادات رجعت للوضعية الأولى';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceSubtitle => 'غيّر مظهر التطبيق';

  @override
  String get gameSection => 'اللعبة';

  @override
  String get gameSectionSubtitle => 'الإعدادات الافتراضية للعبة';

  @override
  String get defaultDealerMode => 'طريقة الدونور الافتراضية';

  @override
  String get quickButtons => 'البوتونات السريعة';

  @override
  String get quickButtonsSubtitle => 'غيّر بوتونات السكور السريعة';

  @override
  String get noButtons => 'ما فماش بوتونات';

  @override
  String get noButtonsSubtitle => 'زيد بوتونات السكور السريعة متاعك';

  @override
  String buttonValue(int value) {
    return 'القيمة: $value';
  }

  @override
  String get sound => 'الصوت';

  @override
  String get preview => 'اسمع';

  @override
  String get noSoundSelected => 'ما اخترتش صوت';

  @override
  String get addButton => 'زيد بوتون';

  @override
  String get addButtonSubtitle => 'أعمل بوتون سريع';

  @override
  String get buttonLabel => 'إسم البوتون';

  @override
  String get buttonLabelHint => 'مثال: كمّلت';

  @override
  String get buttonValueField => 'قيمة البوتون';

  @override
  String get buttonValueHint => 'مثال: 10- ولا 50';

  @override
  String get resetSettings => 'رجع الإعدادات';

  @override
  String get rotation => 'دوران';

  @override
  String get random => 'عشوائي';

  @override
  String get manual => 'يدوي';

  @override
  String get light => 'فاتح';

  @override
  String get lightTheme => 'مظهر فاتح';

  @override
  String get dark => 'غالق';

  @override
  String get darkTheme => 'مظهر غالق';

  @override
  String get system => 'النظام';

  @override
  String get followSystem => 'على حساب النظام';

  @override
  String get loser => 'الخاسر';

  @override
  String get retry => 'عاود';

  @override
  String get search => 'بحث...';

  @override
  String get confirm => 'أكد';

  @override
  String get cancel => 'الغي';

  @override
  String get nameEmptyError => 'الإسم ما يجيش يكون فارغ';

  @override
  String get nameDuplicateError => 'لاعب آخر عنده هذا الإسم';

  @override
  String get labelEmptyError => 'التسمية ما تجيش تكون فارغة';

  @override
  String labelDuplicateError(String label) {
    return 'بوتون بهذه التسمية \"$label\" موجود';
  }

  @override
  String invalidSoundError(String soundId) {
    return 'الصوت \"$soundId\" مش صحيح';
  }

  @override
  String buttonNotFoundError(String buttonId) {
    return 'البوتون \"$buttonId\" ما لقيتوش';
  }

  @override
  String get imageDecodeError =>
      'ما قدرناش نفهمو هذه الصورة. الصيغ المدعومة: JPEG, PNG, WebP, HEIC (Android/iOS).';
}
