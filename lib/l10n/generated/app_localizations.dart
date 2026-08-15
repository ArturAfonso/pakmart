import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pakmart'**
  String get appTitle;

  /// No description provided for @explore.
  ///
  /// In pt, this message translates to:
  /// **'Explorar'**
  String get explore;

  /// No description provided for @categories.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get categories;

  /// No description provided for @installed.
  ///
  /// In pt, this message translates to:
  /// **'Instalados'**
  String get installed;

  /// No description provided for @preferences.
  ///
  /// In pt, this message translates to:
  /// **'Preferências'**
  String get preferences;

  /// No description provided for @searchAppsHint.
  ///
  /// In pt, this message translates to:
  /// **'Procurar aplicativos...'**
  String get searchAppsHint;

  /// No description provided for @search.
  ///
  /// In pt, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get refresh;

  /// No description provided for @previous.
  ///
  /// In pt, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próxima'**
  String get next;

  /// No description provided for @seeAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver tudo'**
  String get seeAll;

  /// No description provided for @noData.
  ///
  /// In pt, this message translates to:
  /// **'Sem dados'**
  String get noData;

  /// No description provided for @general.
  ///
  /// In pt, this message translates to:
  /// **'Geral'**
  String get general;

  /// No description provided for @unknownDeveloper.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvedor desconhecido'**
  String get unknownDeveloper;

  /// No description provided for @noSummary.
  ///
  /// In pt, this message translates to:
  /// **'Sem resumo disponível.'**
  String get noSummary;

  /// No description provided for @pageOf.
  ///
  /// In pt, this message translates to:
  /// **'Página {page} de {totalPages}'**
  String pageOf(int page, int totalPages);

  /// No description provided for @searchAppsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Buscar aplicativos'**
  String get searchAppsTitle;

  /// No description provided for @searchResultsFor.
  ///
  /// In pt, this message translates to:
  /// **'{count} resultados para \"{query}\"'**
  String searchResultsFor(int count, String query);

  /// No description provided for @searchStartHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite um termo para começar a busca.'**
  String get searchStartHint;

  /// No description provided for @searchNoResults.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum app encontrado para esse termo.'**
  String get searchNoResults;

  /// No description provided for @searchUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Busca indisponível'**
  String get searchUnavailable;

  /// No description provided for @searchFailure.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao buscar resultados.'**
  String get searchFailure;

  /// No description provided for @popularTitle.
  ///
  /// In pt, this message translates to:
  /// **'Mais populares'**
  String get popularTitle;

  /// No description provided for @popularSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Os preferidos da comunidade'**
  String get popularSubtitle;

  /// No description provided for @browseCategoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Navegar por categorias'**
  String get browseCategoriesTitle;

  /// No description provided for @browseCategoriesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Encontre por área de interesse'**
  String get browseCategoriesSubtitle;

  /// No description provided for @trendingTitle.
  ///
  /// In pt, this message translates to:
  /// **'Em destaque esta semana'**
  String get trendingTitle;

  /// No description provided for @trendingSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos em ascensão'**
  String get trendingSubtitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Mais favoritados'**
  String get favoritesTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos salvos pela comunidade'**
  String get favoritesSubtitle;

  /// No description provided for @featuredFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar os destaques agora.'**
  String get featuredFailure;

  /// No description provided for @featuredLabel.
  ///
  /// In pt, this message translates to:
  /// **'EM DESTAQUE'**
  String get featuredLabel;

  /// No description provided for @loadFailureTitle.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar este conteúdo agora.'**
  String get loadFailureTitle;

  /// No description provided for @popularFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar os apps populares agora.'**
  String get popularFailure;

  /// No description provided for @categoriesFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar as categorias agora.'**
  String get categoriesFailure;

  /// No description provided for @trendingFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar os apps em destaque agora.'**
  String get trendingFailure;

  /// No description provided for @favoritesFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar os favoritados agora.'**
  String get favoritesFailure;

  /// No description provided for @seeOnFlathub.
  ///
  /// In pt, this message translates to:
  /// **'Ver no Flathub'**
  String get seeOnFlathub;

  /// No description provided for @learnMore.
  ///
  /// In pt, this message translates to:
  /// **'Saiba mais'**
  String get learnMore;

  /// No description provided for @flatpakSandbox.
  ///
  /// In pt, this message translates to:
  /// **'SANDBOX FLATPAK'**
  String get flatpakSandbox;

  /// No description provided for @sandboxHeadline.
  ///
  /// In pt, this message translates to:
  /// **'Cada app vive em sua\nprópria sala silenciosa.'**
  String get sandboxHeadline;

  /// No description provided for @sandboxDescription.
  ///
  /// In pt, this message translates to:
  /// **'Veja e gerencie as permissões de cada aplicativo instalado — rede, arquivos, dispositivos — com clareza e tranquilidade.'**
  String get sandboxDescription;

  /// No description provided for @seeInstalled.
  ///
  /// In pt, this message translates to:
  /// **'Ver instalados'**
  String get seeInstalled;

  /// No description provided for @allPopularApps.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos populares'**
  String get allPopularApps;

  /// No description provided for @popularAppsEyebrow.
  ///
  /// In pt, this message translates to:
  /// **'DESTAQUES DA COMUNIDADE'**
  String get popularAppsEyebrow;

  /// No description provided for @popularAppsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descubra os aplicativos preferidos da comunidade Flathub.'**
  String get popularAppsDescription;

  /// No description provided for @appsFound.
  ///
  /// In pt, this message translates to:
  /// **'{count} apps encontrados'**
  String appsFound(int count);

  /// No description provided for @listLoadFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar essa lista.'**
  String get listLoadFailure;

  /// No description provided for @noInstallMetrics.
  ///
  /// In pt, this message translates to:
  /// **'Sem métricas de instalações.'**
  String get noInstallMetrics;

  /// No description provided for @lastMonthInstalls.
  ///
  /// In pt, this message translates to:
  /// **'{count} instalações no último mês'**
  String lastMonthInstalls(String count);

  /// No description provided for @noTrendingScore.
  ///
  /// In pt, this message translates to:
  /// **'Sem score de crescimento disponível.'**
  String get noTrendingScore;

  /// No description provided for @trendingScoreLabel.
  ///
  /// In pt, this message translates to:
  /// **'Score de tendência: {score}'**
  String trendingScoreLabel(String score);

  /// No description provided for @noFavoritesCount.
  ///
  /// In pt, this message translates to:
  /// **'Sem contagem de favoritos.'**
  String get noFavoritesCount;

  /// No description provided for @sortBy.
  ///
  /// In pt, this message translates to:
  /// **'Ordenar por'**
  String get sortBy;

  /// No description provided for @collectionPopular.
  ///
  /// In pt, this message translates to:
  /// **'Mais populares'**
  String get collectionPopular;

  /// No description provided for @collectionTrending.
  ///
  /// In pt, this message translates to:
  /// **'Em ascensão'**
  String get collectionTrending;

  /// No description provided for @collectionFavorites.
  ///
  /// In pt, this message translates to:
  /// **'Mais favoritados'**
  String get collectionFavorites;

  /// No description provided for @collectionPopularDescription.
  ///
  /// In pt, this message translates to:
  /// **'Ranking por instalações no último mês.'**
  String get collectionPopularDescription;

  /// No description provided for @collectionTrendingDescription.
  ///
  /// In pt, this message translates to:
  /// **'Apps com maior crescimento recente de instalações.'**
  String get collectionTrendingDescription;

  /// No description provided for @collectionFavoritesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Apps com mais marcações de favorito.'**
  String get collectionFavoritesDescription;

  /// No description provided for @monthlyInstalls.
  ///
  /// In pt, this message translates to:
  /// **'{count} instalações no mês'**
  String monthlyInstalls(String count);

  /// No description provided for @favoritesCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} favoritos'**
  String favoritesCount(String count);

  /// No description provided for @trendingScore.
  ///
  /// In pt, this message translates to:
  /// **'Tendência {score}'**
  String trendingScore(String score);

  /// No description provided for @categoriesEyebrow.
  ///
  /// In pt, this message translates to:
  /// **'ENCONTRE SEU PRÓXIMO APP'**
  String get categoriesEyebrow;

  /// No description provided for @categoriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get categoriesTitle;

  /// No description provided for @categoriesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Explore os aplicativos por área de interesse.'**
  String get categoriesDescription;

  /// No description provided for @catalog.
  ///
  /// In pt, this message translates to:
  /// **'ACERVO'**
  String get catalog;

  /// No description provided for @allCategories.
  ///
  /// In pt, this message translates to:
  /// **'Todas as categorias'**
  String get allCategories;

  /// No description provided for @shelf.
  ///
  /// In pt, this message translates to:
  /// **'PRATELEIRA'**
  String get shelf;

  /// No description provided for @categoryLoadFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar esta categoria.'**
  String get categoryLoadFailure;

  /// No description provided for @categoryGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get categoryGeneric;

  /// No description provided for @categoryGenericDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos da categoria {category}.'**
  String categoryGenericDescription(String category);

  /// No description provided for @categoryAudioVideo.
  ///
  /// In pt, this message translates to:
  /// **'Áudio e Vídeo'**
  String get categoryAudioVideo;

  /// No description provided for @categoryAudioVideoDescription.
  ///
  /// In pt, this message translates to:
  /// **'Players, editores e produção multimídia.'**
  String get categoryAudioVideoDescription;

  /// No description provided for @categoryDevelopment.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvimento'**
  String get categoryDevelopment;

  /// No description provided for @categoryDevelopmentDescription.
  ///
  /// In pt, this message translates to:
  /// **'IDEs, editores e ferramentas para devs.'**
  String get categoryDevelopmentDescription;

  /// No description provided for @categoryEducation.
  ///
  /// In pt, this message translates to:
  /// **'Educação'**
  String get categoryEducation;

  /// No description provided for @categoryEducationDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aprendizado, estudo e referência.'**
  String get categoryEducationDescription;

  /// No description provided for @categoryGames.
  ///
  /// In pt, this message translates to:
  /// **'Jogos'**
  String get categoryGames;

  /// No description provided for @categoryGamesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Jogos, emuladores e launchers.'**
  String get categoryGamesDescription;

  /// No description provided for @categoryGraphics.
  ///
  /// In pt, this message translates to:
  /// **'Gráficos'**
  String get categoryGraphics;

  /// No description provided for @categoryGraphicsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Edição de imagem, desenho e design.'**
  String get categoryGraphicsDescription;

  /// No description provided for @categoryInternet.
  ///
  /// In pt, this message translates to:
  /// **'Internet'**
  String get categoryInternet;

  /// No description provided for @categoryInternetDescription.
  ///
  /// In pt, this message translates to:
  /// **'Navegadores, comunicação e rede.'**
  String get categoryInternetDescription;

  /// No description provided for @categoryOffice.
  ///
  /// In pt, this message translates to:
  /// **'Escritório'**
  String get categoryOffice;

  /// No description provided for @categoryOfficeDescription.
  ///
  /// In pt, this message translates to:
  /// **'Produtividade, documentos e planilhas.'**
  String get categoryOfficeDescription;

  /// No description provided for @categoryScience.
  ///
  /// In pt, this message translates to:
  /// **'Ciência'**
  String get categoryScience;

  /// No description provided for @categoryScienceDescription.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisa, cálculo e visualização científica.'**
  String get categoryScienceDescription;

  /// No description provided for @categorySystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get categorySystem;

  /// No description provided for @categorySystemDescription.
  ///
  /// In pt, this message translates to:
  /// **'Utilitários e ferramentas de sistema.'**
  String get categorySystemDescription;

  /// No description provided for @categoryUtilities.
  ///
  /// In pt, this message translates to:
  /// **'Utilitários'**
  String get categoryUtilities;

  /// No description provided for @categoryUtilitiesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Apps úteis para tarefas do dia a dia.'**
  String get categoryUtilitiesDescription;

  /// No description provided for @viewApps.
  ///
  /// In pt, this message translates to:
  /// **'Ver aplicativos'**
  String get viewApps;

  /// No description provided for @categoryApps.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos de {category}'**
  String categoryApps(String category);

  /// No description provided for @categoryAppsFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os apps da categoria.'**
  String get categoryAppsFailure;

  /// No description provided for @appsCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} apps'**
  String appsCount(int count);

  /// No description provided for @sortMostDownloaded.
  ///
  /// In pt, this message translates to:
  /// **'Mais baixados (mês)'**
  String get sortMostDownloaded;

  /// No description provided for @sortTrending.
  ///
  /// In pt, this message translates to:
  /// **'Em ascensão'**
  String get sortTrending;

  /// No description provided for @installedEyebrow.
  ///
  /// In pt, this message translates to:
  /// **'SUA BIBLIOTECA PESSOAL'**
  String get installedEyebrow;

  /// No description provided for @installedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativos instalados'**
  String get installedTitle;

  /// No description provided for @installedDescription.
  ///
  /// In pt, this message translates to:
  /// **'Abra, gerencie permissões ou remova os apps que vivem no seu sistema.'**
  String get installedDescription;

  /// No description provided for @installedLoadFailure.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao carregar os aplicativos instalados.'**
  String get installedLoadFailure;

  /// No description provided for @uninstallAppQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Desinstalar app?'**
  String get uninstallAppQuestion;

  /// No description provided for @uninstallConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Deseja remover {appName} do sistema?'**
  String uninstallConfirmation(String appName);

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @uninstall.
  ///
  /// In pt, this message translates to:
  /// **'Desinstalar'**
  String get uninstall;

  /// No description provided for @uninstallFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível desinstalar {appName}.'**
  String uninstallFailure(String appName);

  /// No description provided for @uninstallSuccess.
  ///
  /// In pt, this message translates to:
  /// **'{appName} foi desinstalado com sucesso.'**
  String uninstallSuccess(String appName);

  /// No description provided for @openApp.
  ///
  /// In pt, this message translates to:
  /// **'Abrir aplicativo'**
  String get openApp;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @version.
  ///
  /// In pt, this message translates to:
  /// **'Versão'**
  String get version;

  /// No description provided for @size.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho'**
  String get size;

  /// No description provided for @license.
  ///
  /// In pt, this message translates to:
  /// **'Licença'**
  String get license;

  /// No description provided for @category.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get category;

  /// No description provided for @permissions.
  ///
  /// In pt, this message translates to:
  /// **'Permissões'**
  String get permissions;

  /// No description provided for @permissionsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Controle o que {appName} pode acessar no seu sistema'**
  String permissionsDescription(String appName);

  /// No description provided for @permissionSaveFailure.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao salvar permissão: {error}'**
  String permissionSaveFailure(String error);

  /// No description provided for @userInstallation.
  ///
  /// In pt, this message translates to:
  /// **'USUÁRIO'**
  String get userInstallation;

  /// No description provided for @systemInstallation.
  ///
  /// In pt, this message translates to:
  /// **'SISTEMA'**
  String get systemInstallation;

  /// No description provided for @permissionSectionSharing.
  ///
  /// In pt, this message translates to:
  /// **'COMPARTILHAMENTO'**
  String get permissionSectionSharing;

  /// No description provided for @permissionSectionSockets.
  ///
  /// In pt, this message translates to:
  /// **'SOCKETS'**
  String get permissionSectionSockets;

  /// No description provided for @permissionSectionDevices.
  ///
  /// In pt, this message translates to:
  /// **'DISPOSITIVOS'**
  String get permissionSectionDevices;

  /// No description provided for @permissionSectionAllow.
  ///
  /// In pt, this message translates to:
  /// **'PERMITIR'**
  String get permissionSectionAllow;

  /// No description provided for @permissionSectionFilesystem.
  ///
  /// In pt, this message translates to:
  /// **'SISTEMA DE ARQUIVOS'**
  String get permissionSectionFilesystem;

  /// No description provided for @permissionSectionPortals.
  ///
  /// In pt, this message translates to:
  /// **'PORTAIS DINÂMICOS'**
  String get permissionSectionPortals;

  /// No description provided for @permissionNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Acesso à rede'**
  String get permissionNetwork;

  /// No description provided for @permissionSharedIpc.
  ///
  /// In pt, this message translates to:
  /// **'Namespace IPC compartilhado'**
  String get permissionSharedIpc;

  /// No description provided for @permissionX11.
  ///
  /// In pt, this message translates to:
  /// **'Janela X11'**
  String get permissionX11;

  /// No description provided for @permissionWayland.
  ///
  /// In pt, this message translates to:
  /// **'Janela Wayland'**
  String get permissionWayland;

  /// No description provided for @permissionFallbackX11.
  ///
  /// In pt, this message translates to:
  /// **'Fallback para X11'**
  String get permissionFallbackX11;

  /// No description provided for @permissionPulseAudio.
  ///
  /// In pt, this message translates to:
  /// **'Servidor PulseAudio'**
  String get permissionPulseAudio;

  /// No description provided for @permissionSessionDbus.
  ///
  /// In pt, this message translates to:
  /// **'Barramento D-Bus (sessão)'**
  String get permissionSessionDbus;

  /// No description provided for @permissionSystemDbus.
  ///
  /// In pt, this message translates to:
  /// **'Barramento D-Bus (sistema)'**
  String get permissionSystemDbus;

  /// No description provided for @permissionSshAuth.
  ///
  /// In pt, this message translates to:
  /// **'Autenticação SSH'**
  String get permissionSshAuth;

  /// No description provided for @permissionSmartCards.
  ///
  /// In pt, this message translates to:
  /// **'Smart cards'**
  String get permissionSmartCards;

  /// No description provided for @permissionPrinting.
  ///
  /// In pt, this message translates to:
  /// **'Sistema de impressão'**
  String get permissionPrinting;

  /// No description provided for @permissionGpgAgent.
  ///
  /// In pt, this message translates to:
  /// **'Diretórios GPG-Agent'**
  String get permissionGpgAgent;

  /// No description provided for @permissionInheritedWayland.
  ///
  /// In pt, this message translates to:
  /// **'Socket Wayland herdado'**
  String get permissionInheritedWayland;

  /// No description provided for @permissionGpu.
  ///
  /// In pt, this message translates to:
  /// **'Aceleração GPU'**
  String get permissionGpu;

  /// No description provided for @permissionInputDevices.
  ///
  /// In pt, this message translates to:
  /// **'Dispositivos de entrada'**
  String get permissionInputDevices;

  /// No description provided for @permissionVirtualization.
  ///
  /// In pt, this message translates to:
  /// **'Virtualização'**
  String get permissionVirtualization;

  /// No description provided for @permissionSharedMemory.
  ///
  /// In pt, this message translates to:
  /// **'Memória compartilhada'**
  String get permissionSharedMemory;

  /// No description provided for @permissionUsb.
  ///
  /// In pt, this message translates to:
  /// **'Dispositivos USB'**
  String get permissionUsb;

  /// No description provided for @permissionAllDevices.
  ///
  /// In pt, this message translates to:
  /// **'Todos os dispositivos'**
  String get permissionAllDevices;

  /// No description provided for @permissionDevelopment.
  ///
  /// In pt, this message translates to:
  /// **'Syscalls de desenvolvimento'**
  String get permissionDevelopment;

  /// No description provided for @permissionMultiarch.
  ///
  /// In pt, this message translates to:
  /// **'Programas de outras arquiteturas'**
  String get permissionMultiarch;

  /// No description provided for @permissionBluetooth.
  ///
  /// In pt, this message translates to:
  /// **'Bluetooth'**
  String get permissionBluetooth;

  /// No description provided for @permissionCanBus.
  ///
  /// In pt, this message translates to:
  /// **'Barramento CAN'**
  String get permissionCanBus;

  /// No description provided for @permissionPerAppSharedMemory.
  ///
  /// In pt, this message translates to:
  /// **'Memória compartilhada por app'**
  String get permissionPerAppSharedMemory;

  /// No description provided for @permissionHostFiles.
  ///
  /// In pt, this message translates to:
  /// **'Todos os arquivos do sistema'**
  String get permissionHostFiles;

  /// No description provided for @permissionHostOsFiles.
  ///
  /// In pt, this message translates to:
  /// **'Bibliotecas, executáveis e dados estáticos do sistema'**
  String get permissionHostOsFiles;

  /// No description provided for @permissionSystemConfig.
  ///
  /// In pt, this message translates to:
  /// **'Configurações do sistema (/etc)'**
  String get permissionSystemConfig;

  /// No description provided for @permissionHomeFiles.
  ///
  /// In pt, this message translates to:
  /// **'Todos os arquivos do usuário'**
  String get permissionHomeFiles;

  /// No description provided for @permissionBackground.
  ///
  /// In pt, this message translates to:
  /// **'Executar em segundo plano'**
  String get permissionBackground;

  /// No description provided for @permissionNotifications.
  ///
  /// In pt, this message translates to:
  /// **'Enviar notificações'**
  String get permissionNotifications;

  /// No description provided for @permissionMicrophone.
  ///
  /// In pt, this message translates to:
  /// **'Acessar microfone'**
  String get permissionMicrophone;

  /// No description provided for @permissionSpeakers.
  ///
  /// In pt, this message translates to:
  /// **'Reproduzir áudio'**
  String get permissionSpeakers;

  /// No description provided for @permissionCamera.
  ///
  /// In pt, this message translates to:
  /// **'Usar câmera'**
  String get permissionCamera;

  /// No description provided for @permissionLocation.
  ///
  /// In pt, this message translates to:
  /// **'Acessar localização'**
  String get permissionLocation;

  /// No description provided for @permissionBase.
  ///
  /// In pt, this message translates to:
  /// **'Base:'**
  String get permissionBase;

  /// No description provided for @permissionGlobal.
  ///
  /// In pt, this message translates to:
  /// **'Global:'**
  String get permissionGlobal;

  /// No description provided for @permissionApp.
  ///
  /// In pt, this message translates to:
  /// **'App:'**
  String get permissionApp;

  /// No description provided for @permissionEffective.
  ///
  /// In pt, this message translates to:
  /// **'Efetiva:'**
  String get permissionEffective;

  /// No description provided for @permissionDynamicState.
  ///
  /// In pt, this message translates to:
  /// **'Estado dinâmico:'**
  String get permissionDynamicState;

  /// No description provided for @permissionAllowed.
  ///
  /// In pt, this message translates to:
  /// **'permitido'**
  String get permissionAllowed;

  /// No description provided for @permissionDenied.
  ///
  /// In pt, this message translates to:
  /// **'negado'**
  String get permissionDenied;

  /// No description provided for @permissionBlocked.
  ///
  /// In pt, this message translates to:
  /// **'bloqueado'**
  String get permissionBlocked;

  /// No description provided for @permissionUnset.
  ///
  /// In pt, this message translates to:
  /// **'não definido'**
  String get permissionUnset;

  /// No description provided for @permissionUnsupported.
  ///
  /// In pt, this message translates to:
  /// **'não suportado'**
  String get permissionUnsupported;

  /// No description provided for @appNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativo não encontrado.'**
  String get appNotFound;

  /// No description provided for @availableForDownload.
  ///
  /// In pt, this message translates to:
  /// **'Disponível para download.'**
  String get availableForDownload;

  /// No description provided for @appInstalled.
  ///
  /// In pt, this message translates to:
  /// **'Aplicativo instalado.'**
  String get appInstalled;

  /// No description provided for @installingApp.
  ///
  /// In pt, this message translates to:
  /// **'Instalando aplicativo...'**
  String get installingApp;

  /// No description provided for @uninstallingApp.
  ///
  /// In pt, this message translates to:
  /// **'Desinstalando aplicativo...'**
  String get uninstallingApp;

  /// No description provided for @install.
  ///
  /// In pt, this message translates to:
  /// **'Instalar'**
  String get install;

  /// No description provided for @installing.
  ///
  /// In pt, this message translates to:
  /// **'Instalando...'**
  String get installing;

  /// No description provided for @uninstalling.
  ///
  /// In pt, this message translates to:
  /// **'Desinstalando...'**
  String get uninstalling;

  /// No description provided for @openAppShort.
  ///
  /// In pt, this message translates to:
  /// **'Abrir app'**
  String get openAppShort;

  /// No description provided for @developer.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvedor'**
  String get developer;

  /// No description provided for @download.
  ///
  /// In pt, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @installedSize.
  ///
  /// In pt, this message translates to:
  /// **'Instalado'**
  String get installedSize;

  /// No description provided for @runtime.
  ///
  /// In pt, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// No description provided for @flatpakId.
  ///
  /// In pt, this message translates to:
  /// **'Flatpak ID'**
  String get flatpakId;

  /// No description provided for @installSuccess.
  ///
  /// In pt, this message translates to:
  /// **'{appName} foi instalado com sucesso.'**
  String installSuccess(String appName);

  /// No description provided for @installFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível instalar {appName}.'**
  String installFailure(String appName);

  /// No description provided for @openFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir {appName}.'**
  String openFailure(String appName);

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @compatibility.
  ///
  /// In pt, this message translates to:
  /// **'Compatibilidade'**
  String get compatibility;

  /// No description provided for @monthly.
  ///
  /// In pt, this message translates to:
  /// **'Mensal'**
  String get monthly;

  /// No description provided for @desktopAndMobile.
  ///
  /// In pt, this message translates to:
  /// **'Desktop + Mobile'**
  String get desktopAndMobile;

  /// No description provided for @mobile.
  ///
  /// In pt, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @desktop.
  ///
  /// In pt, this message translates to:
  /// **'Desktop'**
  String get desktop;

  /// No description provided for @packageSize.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho do pacote'**
  String get packageSize;

  /// No description provided for @installedSizeCaption.
  ///
  /// In pt, this message translates to:
  /// **'Instalado: {size}'**
  String installedSizeCaption(String size);

  /// No description provided for @primarySupport.
  ///
  /// In pt, this message translates to:
  /// **'Suporte principal'**
  String get primarySupport;

  /// No description provided for @lastMonthDownloads.
  ///
  /// In pt, this message translates to:
  /// **'Downloads no último mês'**
  String get lastMonthDownloads;

  /// No description provided for @totalDownloads.
  ///
  /// In pt, this message translates to:
  /// **'{count} no total'**
  String totalDownloads(String count);

  /// No description provided for @recentRelease.
  ///
  /// In pt, this message translates to:
  /// **'Release recente'**
  String get recentRelease;

  /// No description provided for @releaseVersion.
  ///
  /// In pt, this message translates to:
  /// **'Release {version}'**
  String releaseVersion(String version);

  /// No description provided for @usefulLinks.
  ///
  /// In pt, this message translates to:
  /// **'Links úteis'**
  String get usefulLinks;

  /// No description provided for @officialWebsite.
  ///
  /// In pt, this message translates to:
  /// **'Site oficial'**
  String get officialWebsite;

  /// No description provided for @help.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda'**
  String get help;

  /// No description provided for @reportIssue.
  ///
  /// In pt, this message translates to:
  /// **'Relatar problema'**
  String get reportIssue;

  /// No description provided for @sourceCode.
  ///
  /// In pt, this message translates to:
  /// **'Código-fonte'**
  String get sourceCode;

  /// No description provided for @translate.
  ///
  /// In pt, this message translates to:
  /// **'Traduzir'**
  String get translate;

  /// No description provided for @supportProject.
  ///
  /// In pt, this message translates to:
  /// **'Apoiar projeto'**
  String get supportProject;

  /// No description provided for @contribute.
  ///
  /// In pt, this message translates to:
  /// **'Contribuir'**
  String get contribute;

  /// No description provided for @contact.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get contact;

  /// No description provided for @linkOpenFailure.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir {linkLabel}.'**
  String linkOpenFailure(String linkLabel);

  /// No description provided for @verified.
  ///
  /// In pt, this message translates to:
  /// **'VERIFICADO'**
  String get verified;

  /// No description provided for @screenshots.
  ///
  /// In pt, this message translates to:
  /// **'Capturas de tela'**
  String get screenshots;

  /// No description provided for @screenshotsHint.
  ///
  /// In pt, this message translates to:
  /// **'Clique para ampliar e navegar em tela cheia.'**
  String get screenshotsHint;

  /// No description provided for @screenNumber.
  ///
  /// In pt, this message translates to:
  /// **'Tela {number}'**
  String screenNumber(int number);

  /// No description provided for @screenshotNumber.
  ///
  /// In pt, this message translates to:
  /// **'Captura {number}'**
  String screenshotNumber(int number);

  /// No description provided for @personalSettings.
  ///
  /// In pt, this message translates to:
  /// **'AJUSTES PESSOAIS'**
  String get personalSettings;

  /// No description provided for @preferencesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Preferências'**
  String get preferencesTitle;

  /// No description provided for @trust.
  ///
  /// In pt, this message translates to:
  /// **'Confiança'**
  String get trust;

  /// No description provided for @trustDescription.
  ///
  /// In pt, this message translates to:
  /// **'Controle a visibilidade de aplicativos que não foram verificados pelo Flathub.'**
  String get trustDescription;

  /// No description provided for @showUnverifiedApps.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar apps não verificados'**
  String get showUnverifiedApps;

  /// No description provided for @showUnverifiedAppsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Desative para exibir somente aplicativos verificados.'**
  String get showUnverifiedAppsDescription;

  /// No description provided for @unverifiedApp.
  ///
  /// In pt, this message translates to:
  /// **'APP NÃO VERIFICADO'**
  String get unverifiedApp;

  /// No description provided for @appLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma do app'**
  String get appLanguage;

  /// No description provided for @languageDescription.
  ///
  /// In pt, this message translates to:
  /// **'O idioma do sistema é usado inicialmente. Quando você escolhe um idioma, sua escolha passa a prevalecer.'**
  String get languageDescription;

  /// No description provided for @useSystemLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Usar idioma do sistema'**
  String get useSystemLanguage;

  /// No description provided for @currentLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Atual: {localeCode}'**
  String currentLanguage(String localeCode);

  /// No description provided for @portugueseBrazil.
  ///
  /// In pt, this message translates to:
  /// **'Português (Brasil)'**
  String get portugueseBrazil;

  /// No description provided for @portugueseBrazilDescription.
  ///
  /// In pt, this message translates to:
  /// **'Interface em português brasileiro'**
  String get portugueseBrazilDescription;

  /// No description provided for @englishUnitedStates.
  ///
  /// In pt, this message translates to:
  /// **'Inglês (Estados Unidos)'**
  String get englishUnitedStates;

  /// No description provided for @englishUnitedStatesDescription.
  ///
  /// In pt, this message translates to:
  /// **'Interface em inglês'**
  String get englishUnitedStatesDescription;

  /// No description provided for @appearance.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get appearance;

  /// No description provided for @appearanceDescription.
  ///
  /// In pt, this message translates to:
  /// **'Tema visual da loja.'**
  String get appearanceDescription;

  /// No description provided for @light.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get light;

  /// No description provided for @lightDescription.
  ///
  /// In pt, this message translates to:
  /// **'Papel quente, padrão'**
  String get lightDescription;

  /// No description provided for @dark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get dark;

  /// No description provided for @darkDescription.
  ///
  /// In pt, this message translates to:
  /// **'Tinta noturna'**
  String get darkDescription;

  /// No description provided for @themeToggleTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Alternar tema'**
  String get themeToggleTooltip;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
