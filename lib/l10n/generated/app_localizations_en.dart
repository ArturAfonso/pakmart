// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pakmart';

  @override
  String get explore => 'Explore';

  @override
  String get categories => 'Categories';

  @override
  String get installed => 'Installed';

  @override
  String get preferences => 'Preferences';

  @override
  String get searchAppsHint => 'Search applications...';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Try again';

  @override
  String get refresh => 'Refresh';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get seeAll => 'See all';

  @override
  String get noData => 'No data';

  @override
  String get general => 'General';

  @override
  String get unknownDeveloper => 'Unknown developer';

  @override
  String get noSummary => 'No summary available.';

  @override
  String pageOf(int page, int totalPages) {
    return 'Page $page of $totalPages';
  }

  @override
  String get searchAppsTitle => 'Search applications';

  @override
  String searchResultsFor(int count, String query) {
    return '$count results for \"$query\"';
  }

  @override
  String get searchStartHint => 'Enter a term to start searching.';

  @override
  String get searchNoResults => 'No apps were found for this term.';

  @override
  String get searchUnavailable => 'Search unavailable';

  @override
  String get searchFailure => 'Failed to fetch search results.';

  @override
  String get popularTitle => 'Most popular';

  @override
  String get popularSubtitle => 'Community favorites';

  @override
  String get browseCategoriesTitle => 'Browse categories';

  @override
  String get browseCategoriesSubtitle => 'Find apps by area of interest';

  @override
  String get trendingTitle => 'Featured this week';

  @override
  String get trendingSubtitle => 'Apps on the rise';

  @override
  String get favoritesTitle => 'Most favorited';

  @override
  String get favoritesSubtitle => 'Apps saved by the community';

  @override
  String get featuredFailure => 'We couldn\'t load featured apps right now.';

  @override
  String get featuredLabel => 'FEATURED';

  @override
  String get loadFailureTitle => 'We couldn\'t load this content right now.';

  @override
  String get popularFailure => 'We couldn\'t load popular apps right now.';

  @override
  String get categoriesFailure => 'We couldn\'t load categories right now.';

  @override
  String get trendingFailure => 'We couldn\'t load trending apps right now.';

  @override
  String get favoritesFailure => 'We couldn\'t load favorites right now.';

  @override
  String get seeOnFlathub => 'View on Flathub';

  @override
  String get learnMore => 'Learn more';

  @override
  String get flatpakSandbox => 'FLATPAK SANDBOX';

  @override
  String get sandboxHeadline => 'Every app lives in its\nown quiet room.';

  @override
  String get sandboxDescription =>
      'View and manage each installed application\'s permissions — network, files, and devices — clearly and confidently.';

  @override
  String get seeInstalled => 'View installed apps';

  @override
  String get allPopularApps => 'Popular applications';

  @override
  String get popularAppsEyebrow => 'COMMUNITY HIGHLIGHTS';

  @override
  String get popularAppsDescription =>
      'Discover the Flathub community\'s favorite applications.';

  @override
  String appsFound(int count) {
    return '$count apps found';
  }

  @override
  String get listLoadFailure => 'We couldn\'t load this list.';

  @override
  String get noInstallMetrics => 'No installation metrics available.';

  @override
  String lastMonthInstalls(String count) {
    return '$count installs in the last month';
  }

  @override
  String get noTrendingScore => 'No growth score available.';

  @override
  String trendingScoreLabel(String score) {
    return 'Trending score: $score';
  }

  @override
  String get noFavoritesCount => 'No favorites count available.';

  @override
  String get sortBy => 'Sort by';

  @override
  String get collectionPopular => 'Most popular';

  @override
  String get collectionTrending => 'Trending';

  @override
  String get collectionFavorites => 'Most favorited';

  @override
  String get collectionPopularDescription =>
      'Ranked by installations over the last month.';

  @override
  String get collectionTrendingDescription =>
      'Apps with the strongest recent installation growth.';

  @override
  String get collectionFavoritesDescription => 'Apps with the most favorites.';

  @override
  String monthlyInstalls(String count) {
    return '$count installs this month';
  }

  @override
  String favoritesCount(String count) {
    return '$count favorites';
  }

  @override
  String trendingScore(String score) {
    return 'Trending $score';
  }

  @override
  String get categoriesEyebrow => 'FIND YOUR NEXT APP';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesDescription =>
      'Explore applications by area of interest.';

  @override
  String get catalog => 'CATALOG';

  @override
  String get allCategories => 'All categories';

  @override
  String get shelf => 'SHELF';

  @override
  String get categoryLoadFailure => 'We couldn\'t load this category.';

  @override
  String get categoryGeneric => 'Category';

  @override
  String categoryGenericDescription(String category) {
    return 'Applications in the $category category.';
  }

  @override
  String get categoryAudioVideo => 'Audio & Video';

  @override
  String get categoryAudioVideoDescription =>
      'Players, editors, and multimedia production.';

  @override
  String get categoryDevelopment => 'Development';

  @override
  String get categoryDevelopmentDescription =>
      'IDEs, editors, and developer tools.';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryEducationDescription => 'Learning, study, and reference.';

  @override
  String get categoryGames => 'Games';

  @override
  String get categoryGamesDescription => 'Games, emulators, and launchers.';

  @override
  String get categoryGraphics => 'Graphics';

  @override
  String get categoryGraphicsDescription =>
      'Image editing, drawing, and design.';

  @override
  String get categoryInternet => 'Internet';

  @override
  String get categoryInternetDescription =>
      'Browsers, communication, and networking.';

  @override
  String get categoryOffice => 'Office';

  @override
  String get categoryOfficeDescription =>
      'Productivity, documents, and spreadsheets.';

  @override
  String get categoryScience => 'Science';

  @override
  String get categoryScienceDescription =>
      'Research, calculations, and scientific visualization.';

  @override
  String get categorySystem => 'System';

  @override
  String get categorySystemDescription => 'Utilities and system tools.';

  @override
  String get categoryUtilities => 'Utilities';

  @override
  String get categoryUtilitiesDescription => 'Useful apps for everyday tasks.';

  @override
  String get viewApps => 'View applications';

  @override
  String categoryApps(String category) {
    return '$category applications';
  }

  @override
  String get categoryAppsFailure =>
      'Couldn\'t load applications in this category.';

  @override
  String appsCount(int count) {
    return '$count apps';
  }

  @override
  String get sortMostDownloaded => 'Most downloaded (month)';

  @override
  String get sortTrending => 'Trending';

  @override
  String get installedEyebrow => 'YOUR PERSONAL LIBRARY';

  @override
  String get installedTitle => 'Installed applications';

  @override
  String get installedDescription =>
      'Open, manage permissions, or remove the applications on your system.';

  @override
  String get installedLoadFailure => 'Failed to load installed applications.';

  @override
  String get uninstallAppQuestion => 'Uninstall app?';

  @override
  String uninstallConfirmation(String appName) {
    return 'Do you want to remove $appName from the system?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get uninstall => 'Uninstall';

  @override
  String uninstallFailure(String appName) {
    return 'Couldn\'t uninstall $appName.';
  }

  @override
  String uninstallSuccess(String appName) {
    return '$appName was successfully uninstalled.';
  }

  @override
  String get openApp => 'Open application';

  @override
  String get remove => 'Remove';

  @override
  String get version => 'Version';

  @override
  String get size => 'Size';

  @override
  String get license => 'License';

  @override
  String get category => 'Category';

  @override
  String get permissions => 'Permissions';

  @override
  String permissionsDescription(String appName) {
    return 'Control what $appName can access on your system';
  }

  @override
  String permissionSaveFailure(String error) {
    return 'Failed to save permission: $error';
  }

  @override
  String get userInstallation => 'USER';

  @override
  String get systemInstallation => 'SYSTEM';

  @override
  String get permissionSectionSharing => 'SHARING';

  @override
  String get permissionSectionSockets => 'SOCKETS';

  @override
  String get permissionSectionDevices => 'DEVICES';

  @override
  String get permissionSectionAllow => 'ALLOW';

  @override
  String get permissionSectionFilesystem => 'FILESYSTEM';

  @override
  String get permissionSectionPortals => 'DYNAMIC PORTALS';

  @override
  String get permissionNetwork => 'Network access';

  @override
  String get permissionSharedIpc => 'Shared IPC namespace';

  @override
  String get permissionX11 => 'X11 windowing system';

  @override
  String get permissionWayland => 'Wayland windowing system';

  @override
  String get permissionFallbackX11 => 'Fallback to X11';

  @override
  String get permissionPulseAudio => 'PulseAudio server';

  @override
  String get permissionSessionDbus => 'D-Bus session bus';

  @override
  String get permissionSystemDbus => 'D-Bus system bus';

  @override
  String get permissionSshAuth => 'SSH authentication';

  @override
  String get permissionSmartCards => 'Smart cards';

  @override
  String get permissionPrinting => 'Printing system';

  @override
  String get permissionGpgAgent => 'GPG-Agent directories';

  @override
  String get permissionInheritedWayland => 'Inherited Wayland socket';

  @override
  String get permissionGpu => 'GPU acceleration';

  @override
  String get permissionInputDevices => 'Input devices';

  @override
  String get permissionVirtualization => 'Virtualization';

  @override
  String get permissionSharedMemory => 'Shared memory';

  @override
  String get permissionUsb => 'USB devices';

  @override
  String get permissionAllDevices => 'All devices';

  @override
  String get permissionDevelopment => 'Development syscalls';

  @override
  String get permissionMultiarch => 'Programs for other architectures';

  @override
  String get permissionBluetooth => 'Bluetooth';

  @override
  String get permissionCanBus => 'CAN bus';

  @override
  String get permissionPerAppSharedMemory => 'Per-app shared memory';

  @override
  String get permissionHostFiles => 'All system files';

  @override
  String get permissionHostOsFiles =>
      'System libraries, executables, and static data';

  @override
  String get permissionSystemConfig => 'System settings (/etc)';

  @override
  String get permissionHomeFiles => 'All user files';

  @override
  String get permissionBackground => 'Run in the background';

  @override
  String get permissionNotifications => 'Send notifications';

  @override
  String get permissionMicrophone => 'Access the microphone';

  @override
  String get permissionSpeakers => 'Play audio';

  @override
  String get permissionCamera => 'Use the camera';

  @override
  String get permissionLocation => 'Access location';

  @override
  String get permissionBase => 'Base:';

  @override
  String get permissionGlobal => 'Global:';

  @override
  String get permissionApp => 'App:';

  @override
  String get permissionEffective => 'Effective:';

  @override
  String get permissionDynamicState => 'Dynamic state:';

  @override
  String get permissionAllowed => 'allowed';

  @override
  String get permissionDenied => 'denied';

  @override
  String get permissionBlocked => 'blocked';

  @override
  String get permissionUnset => 'not set';

  @override
  String get permissionUnsupported => 'unsupported';

  @override
  String get appNotFound => 'Application not found.';

  @override
  String get availableForDownload => 'Available for download.';

  @override
  String get appInstalled => 'Application installed.';

  @override
  String get installingApp => 'Installing application...';

  @override
  String get uninstallingApp => 'Uninstalling application...';

  @override
  String get install => 'Install';

  @override
  String get installing => 'Installing...';

  @override
  String get uninstalling => 'Uninstalling...';

  @override
  String get openAppShort => 'Open app';

  @override
  String get developer => 'Developer';

  @override
  String get download => 'Download';

  @override
  String get installedSize => 'Installed';

  @override
  String get runtime => 'Runtime';

  @override
  String get flatpakId => 'Flatpak ID';

  @override
  String installSuccess(String appName) {
    return '$appName was successfully installed.';
  }

  @override
  String installFailure(String appName) {
    return 'Couldn\'t install $appName.';
  }

  @override
  String openFailure(String appName) {
    return 'Couldn\'t open $appName.';
  }

  @override
  String get about => 'About';

  @override
  String get compatibility => 'Compatibility';

  @override
  String get monthly => 'Monthly';

  @override
  String get desktopAndMobile => 'Desktop + Mobile';

  @override
  String get mobile => 'Mobile';

  @override
  String get desktop => 'Desktop';

  @override
  String get packageSize => 'Package size';

  @override
  String installedSizeCaption(String size) {
    return 'Installed: $size';
  }

  @override
  String get primarySupport => 'Primary support';

  @override
  String get lastMonthDownloads => 'Downloads last month';

  @override
  String totalDownloads(String count) {
    return '$count total';
  }

  @override
  String get recentRelease => 'Recent release';

  @override
  String releaseVersion(String version) {
    return 'Release $version';
  }

  @override
  String get usefulLinks => 'Useful links';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get help => 'Help';

  @override
  String get reportIssue => 'Report an issue';

  @override
  String get sourceCode => 'Source code';

  @override
  String get translate => 'Translate';

  @override
  String get supportProject => 'Support the project';

  @override
  String get contribute => 'Contribute';

  @override
  String get contact => 'Contact';

  @override
  String linkOpenFailure(String linkLabel) {
    return 'Couldn\'t open $linkLabel.';
  }

  @override
  String get verified => 'VERIFIED';

  @override
  String get screenshots => 'Screenshots';

  @override
  String get screenshotsHint => 'Click to enlarge and browse in full screen.';

  @override
  String screenNumber(int number) {
    return 'Screen $number';
  }

  @override
  String screenshotNumber(int number) {
    return 'Screenshot $number';
  }

  @override
  String get personalSettings => 'PERSONAL SETTINGS';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get trust => 'Trust';

  @override
  String get trustDescription =>
      'Control the visibility of applications that have not been verified by Flathub.';

  @override
  String get showUnverifiedApps => 'Show unverified apps';

  @override
  String get showUnverifiedAppsDescription =>
      'Turn this off to display verified applications only.';

  @override
  String get unverifiedApp => 'UNVERIFIED APP';

  @override
  String get appLanguage => 'App language';

  @override
  String get languageDescription =>
      'The system language is used initially. Once you choose a language, your selection takes precedence.';

  @override
  String get useSystemLanguage => 'Use system language';

  @override
  String currentLanguage(String localeCode) {
    return 'Current: $localeCode';
  }

  @override
  String get portugueseBrazil => 'Portuguese (Brazil)';

  @override
  String get portugueseBrazilDescription => 'Interface in Brazilian Portuguese';

  @override
  String get englishUnitedStates => 'English (United States)';

  @override
  String get englishUnitedStatesDescription => 'Interface in English';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription => 'The store\'s visual theme.';

  @override
  String get light => 'Light';

  @override
  String get lightDescription => 'Warm paper, default';

  @override
  String get dark => 'Dark';

  @override
  String get darkDescription => 'Night ink';

  @override
  String get themeToggleTooltip => 'Toggle theme';
}
