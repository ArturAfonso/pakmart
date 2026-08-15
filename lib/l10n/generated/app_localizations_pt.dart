// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pakmart';

  @override
  String get explore => 'Explorar';

  @override
  String get categories => 'Categorias';

  @override
  String get installed => 'Instalados';

  @override
  String get preferences => 'Preferências';

  @override
  String get searchAppsHint => 'Procurar aplicativos...';

  @override
  String get search => 'Buscar';

  @override
  String get clear => 'Limpar';

  @override
  String get back => 'Voltar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get refresh => 'Atualizar';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Próxima';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get noData => 'Sem dados';

  @override
  String get general => 'Geral';

  @override
  String get unknownDeveloper => 'Desenvolvedor desconhecido';

  @override
  String get noSummary => 'Sem resumo disponível.';

  @override
  String pageOf(int page, int totalPages) {
    return 'Página $page de $totalPages';
  }

  @override
  String get searchAppsTitle => 'Buscar aplicativos';

  @override
  String searchResultsFor(int count, String query) {
    return '$count resultados para \"$query\"';
  }

  @override
  String get searchStartHint => 'Digite um termo para começar a busca.';

  @override
  String get searchNoResults => 'Nenhum app encontrado para esse termo.';

  @override
  String get searchUnavailable => 'Busca indisponível';

  @override
  String get searchFailure => 'Falha ao buscar resultados.';

  @override
  String get popularTitle => 'Mais populares';

  @override
  String get popularSubtitle => 'Os preferidos da comunidade';

  @override
  String get browseCategoriesTitle => 'Navegar por categorias';

  @override
  String get browseCategoriesSubtitle => 'Encontre por área de interesse';

  @override
  String get trendingTitle => 'Em destaque esta semana';

  @override
  String get trendingSubtitle => 'Aplicativos em ascensão';

  @override
  String get favoritesTitle => 'Mais favoritados';

  @override
  String get favoritesSubtitle => 'Aplicativos salvos pela comunidade';

  @override
  String get featuredFailure => 'Não conseguimos carregar os destaques agora.';

  @override
  String get featuredLabel => 'EM DESTAQUE';

  @override
  String get loadFailureTitle =>
      'Não conseguimos carregar este conteúdo agora.';

  @override
  String get popularFailure =>
      'Não conseguimos carregar os apps populares agora.';

  @override
  String get categoriesFailure =>
      'Não conseguimos carregar as categorias agora.';

  @override
  String get trendingFailure =>
      'Não conseguimos carregar os apps em destaque agora.';

  @override
  String get favoritesFailure =>
      'Não conseguimos carregar os favoritados agora.';

  @override
  String get seeOnFlathub => 'Ver no Flathub';

  @override
  String get learnMore => 'Saiba mais';

  @override
  String get flatpakSandbox => 'SANDBOX FLATPAK';

  @override
  String get sandboxHeadline =>
      'Cada app vive em sua\nprópria sala silenciosa.';

  @override
  String get sandboxDescription =>
      'Veja e gerencie as permissões de cada aplicativo instalado — rede, arquivos, dispositivos — com clareza e tranquilidade.';

  @override
  String get seeInstalled => 'Ver instalados';

  @override
  String get allPopularApps => 'Aplicativos populares';

  @override
  String get popularAppsEyebrow => 'DESTAQUES DA COMUNIDADE';

  @override
  String get popularAppsDescription =>
      'Descubra os aplicativos preferidos da comunidade Flathub.';

  @override
  String appsFound(int count) {
    return '$count apps encontrados';
  }

  @override
  String get listLoadFailure => 'Não conseguimos carregar essa lista.';

  @override
  String get noInstallMetrics => 'Sem métricas de instalações.';

  @override
  String lastMonthInstalls(String count) {
    return '$count instalações no último mês';
  }

  @override
  String get noTrendingScore => 'Sem score de crescimento disponível.';

  @override
  String trendingScoreLabel(String score) {
    return 'Score de tendência: $score';
  }

  @override
  String get noFavoritesCount => 'Sem contagem de favoritos.';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get collectionPopular => 'Mais populares';

  @override
  String get collectionTrending => 'Em ascensão';

  @override
  String get collectionFavorites => 'Mais favoritados';

  @override
  String get collectionPopularDescription =>
      'Ranking por instalações no último mês.';

  @override
  String get collectionTrendingDescription =>
      'Apps com maior crescimento recente de instalações.';

  @override
  String get collectionFavoritesDescription =>
      'Apps com mais marcações de favorito.';

  @override
  String monthlyInstalls(String count) {
    return '$count instalações no mês';
  }

  @override
  String favoritesCount(String count) {
    return '$count favoritos';
  }

  @override
  String trendingScore(String score) {
    return 'Tendência $score';
  }

  @override
  String get categoriesEyebrow => 'ENCONTRE SEU PRÓXIMO APP';

  @override
  String get categoriesTitle => 'Categorias';

  @override
  String get categoriesDescription =>
      'Explore os aplicativos por área de interesse.';

  @override
  String get catalog => 'ACERVO';

  @override
  String get allCategories => 'Todas as categorias';

  @override
  String get shelf => 'PRATELEIRA';

  @override
  String get categoryLoadFailure => 'Não conseguimos carregar esta categoria.';

  @override
  String get categoryGeneric => 'Categoria';

  @override
  String categoryGenericDescription(String category) {
    return 'Aplicativos da categoria $category.';
  }

  @override
  String get categoryAudioVideo => 'Áudio e Vídeo';

  @override
  String get categoryAudioVideoDescription =>
      'Players, editores e produção multimídia.';

  @override
  String get categoryDevelopment => 'Desenvolvimento';

  @override
  String get categoryDevelopmentDescription =>
      'IDEs, editores e ferramentas para devs.';

  @override
  String get categoryEducation => 'Educação';

  @override
  String get categoryEducationDescription =>
      'Aprendizado, estudo e referência.';

  @override
  String get categoryGames => 'Jogos';

  @override
  String get categoryGamesDescription => 'Jogos, emuladores e launchers.';

  @override
  String get categoryGraphics => 'Gráficos';

  @override
  String get categoryGraphicsDescription =>
      'Edição de imagem, desenho e design.';

  @override
  String get categoryInternet => 'Internet';

  @override
  String get categoryInternetDescription => 'Navegadores, comunicação e rede.';

  @override
  String get categoryOffice => 'Escritório';

  @override
  String get categoryOfficeDescription =>
      'Produtividade, documentos e planilhas.';

  @override
  String get categoryScience => 'Ciência';

  @override
  String get categoryScienceDescription =>
      'Pesquisa, cálculo e visualização científica.';

  @override
  String get categorySystem => 'Sistema';

  @override
  String get categorySystemDescription =>
      'Utilitários e ferramentas de sistema.';

  @override
  String get categoryUtilities => 'Utilitários';

  @override
  String get categoryUtilitiesDescription =>
      'Apps úteis para tarefas do dia a dia.';

  @override
  String get viewApps => 'Ver aplicativos';

  @override
  String categoryApps(String category) {
    return 'Aplicativos de $category';
  }

  @override
  String get categoryAppsFailure =>
      'Não foi possível carregar os apps da categoria.';

  @override
  String appsCount(int count) {
    return '$count apps';
  }

  @override
  String get sortMostDownloaded => 'Mais baixados (mês)';

  @override
  String get sortTrending => 'Em ascensão';

  @override
  String get installedEyebrow => 'SUA BIBLIOTECA PESSOAL';

  @override
  String get installedTitle => 'Aplicativos instalados';

  @override
  String get installedDescription =>
      'Abra, gerencie permissões ou remova os apps que vivem no seu sistema.';

  @override
  String get installedLoadFailure =>
      'Falha ao carregar os aplicativos instalados.';

  @override
  String get uninstallAppQuestion => 'Desinstalar app?';

  @override
  String uninstallConfirmation(String appName) {
    return 'Deseja remover $appName do sistema?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstallFailure(String appName) {
    return 'Não foi possível desinstalar $appName.';
  }

  @override
  String uninstallSuccess(String appName) {
    return '$appName foi desinstalado com sucesso.';
  }

  @override
  String get openApp => 'Abrir aplicativo';

  @override
  String get remove => 'Remover';

  @override
  String get version => 'Versão';

  @override
  String get size => 'Tamanho';

  @override
  String get license => 'Licença';

  @override
  String get category => 'Categoria';

  @override
  String get permissions => 'Permissões';

  @override
  String permissionsDescription(String appName) {
    return 'Controle o que $appName pode acessar no seu sistema';
  }

  @override
  String permissionSaveFailure(String error) {
    return 'Falha ao salvar permissão: $error';
  }

  @override
  String get userInstallation => 'USUÁRIO';

  @override
  String get systemInstallation => 'SISTEMA';

  @override
  String get permissionSectionSharing => 'COMPARTILHAMENTO';

  @override
  String get permissionSectionSockets => 'SOCKETS';

  @override
  String get permissionSectionDevices => 'DISPOSITIVOS';

  @override
  String get permissionSectionAllow => 'PERMITIR';

  @override
  String get permissionSectionFilesystem => 'SISTEMA DE ARQUIVOS';

  @override
  String get permissionSectionPortals => 'PORTAIS DINÂMICOS';

  @override
  String get permissionNetwork => 'Acesso à rede';

  @override
  String get permissionSharedIpc => 'Namespace IPC compartilhado';

  @override
  String get permissionX11 => 'Janela X11';

  @override
  String get permissionWayland => 'Janela Wayland';

  @override
  String get permissionFallbackX11 => 'Fallback para X11';

  @override
  String get permissionPulseAudio => 'Servidor PulseAudio';

  @override
  String get permissionSessionDbus => 'Barramento D-Bus (sessão)';

  @override
  String get permissionSystemDbus => 'Barramento D-Bus (sistema)';

  @override
  String get permissionSshAuth => 'Autenticação SSH';

  @override
  String get permissionSmartCards => 'Smart cards';

  @override
  String get permissionPrinting => 'Sistema de impressão';

  @override
  String get permissionGpgAgent => 'Diretórios GPG-Agent';

  @override
  String get permissionInheritedWayland => 'Socket Wayland herdado';

  @override
  String get permissionGpu => 'Aceleração GPU';

  @override
  String get permissionInputDevices => 'Dispositivos de entrada';

  @override
  String get permissionVirtualization => 'Virtualização';

  @override
  String get permissionSharedMemory => 'Memória compartilhada';

  @override
  String get permissionUsb => 'Dispositivos USB';

  @override
  String get permissionAllDevices => 'Todos os dispositivos';

  @override
  String get permissionDevelopment => 'Syscalls de desenvolvimento';

  @override
  String get permissionMultiarch => 'Programas de outras arquiteturas';

  @override
  String get permissionBluetooth => 'Bluetooth';

  @override
  String get permissionCanBus => 'Barramento CAN';

  @override
  String get permissionPerAppSharedMemory => 'Memória compartilhada por app';

  @override
  String get permissionHostFiles => 'Todos os arquivos do sistema';

  @override
  String get permissionHostOsFiles =>
      'Bibliotecas, executáveis e dados estáticos do sistema';

  @override
  String get permissionSystemConfig => 'Configurações do sistema (/etc)';

  @override
  String get permissionHomeFiles => 'Todos os arquivos do usuário';

  @override
  String get permissionBackground => 'Executar em segundo plano';

  @override
  String get permissionNotifications => 'Enviar notificações';

  @override
  String get permissionMicrophone => 'Acessar microfone';

  @override
  String get permissionSpeakers => 'Reproduzir áudio';

  @override
  String get permissionCamera => 'Usar câmera';

  @override
  String get permissionLocation => 'Acessar localização';

  @override
  String get permissionBase => 'Base:';

  @override
  String get permissionGlobal => 'Global:';

  @override
  String get permissionApp => 'App:';

  @override
  String get permissionEffective => 'Efetiva:';

  @override
  String get permissionDynamicState => 'Estado dinâmico:';

  @override
  String get permissionAllowed => 'permitido';

  @override
  String get permissionDenied => 'negado';

  @override
  String get permissionBlocked => 'bloqueado';

  @override
  String get permissionUnset => 'não definido';

  @override
  String get permissionUnsupported => 'não suportado';

  @override
  String get appNotFound => 'Aplicativo não encontrado.';

  @override
  String get availableForDownload => 'Disponível para download.';

  @override
  String get appInstalled => 'Aplicativo instalado.';

  @override
  String get installingApp => 'Instalando aplicativo...';

  @override
  String get uninstallingApp => 'Desinstalando aplicativo...';

  @override
  String get install => 'Instalar';

  @override
  String get installing => 'Instalando...';

  @override
  String get uninstalling => 'Desinstalando...';

  @override
  String get openAppShort => 'Abrir app';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get download => 'Download';

  @override
  String get installedSize => 'Instalado';

  @override
  String get runtime => 'Runtime';

  @override
  String get flatpakId => 'Flatpak ID';

  @override
  String installSuccess(String appName) {
    return '$appName foi instalado com sucesso.';
  }

  @override
  String installFailure(String appName) {
    return 'Não foi possível instalar $appName.';
  }

  @override
  String openFailure(String appName) {
    return 'Não foi possível abrir $appName.';
  }

  @override
  String get about => 'Sobre';

  @override
  String get compatibility => 'Compatibilidade';

  @override
  String get monthly => 'Mensal';

  @override
  String get desktopAndMobile => 'Desktop + Mobile';

  @override
  String get mobile => 'Mobile';

  @override
  String get desktop => 'Desktop';

  @override
  String get packageSize => 'Tamanho do pacote';

  @override
  String installedSizeCaption(String size) {
    return 'Instalado: $size';
  }

  @override
  String get primarySupport => 'Suporte principal';

  @override
  String get lastMonthDownloads => 'Downloads no último mês';

  @override
  String totalDownloads(String count) {
    return '$count no total';
  }

  @override
  String get recentRelease => 'Release recente';

  @override
  String releaseVersion(String version) {
    return 'Release $version';
  }

  @override
  String get usefulLinks => 'Links úteis';

  @override
  String get officialWebsite => 'Site oficial';

  @override
  String get help => 'Ajuda';

  @override
  String get reportIssue => 'Relatar problema';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get translate => 'Traduzir';

  @override
  String get supportProject => 'Apoiar projeto';

  @override
  String get contribute => 'Contribuir';

  @override
  String get contact => 'Contato';

  @override
  String linkOpenFailure(String linkLabel) {
    return 'Não foi possível abrir $linkLabel.';
  }

  @override
  String get verified => 'VERIFICADO';

  @override
  String get screenshots => 'Capturas de tela';

  @override
  String get screenshotsHint => 'Clique para ampliar e navegar em tela cheia.';

  @override
  String screenNumber(int number) {
    return 'Tela $number';
  }

  @override
  String screenshotNumber(int number) {
    return 'Captura $number';
  }

  @override
  String get personalSettings => 'AJUSTES PESSOAIS';

  @override
  String get preferencesTitle => 'Preferências';

  @override
  String get trust => 'Confiança';

  @override
  String get trustDescription =>
      'Controle a visibilidade de aplicativos que não foram verificados pelo Flathub.';

  @override
  String get showUnverifiedApps => 'Mostrar apps não verificados';

  @override
  String get showUnverifiedAppsDescription =>
      'Desative para exibir somente aplicativos verificados.';

  @override
  String get unverifiedApp => 'APP NÃO VERIFICADO';

  @override
  String get appLanguage => 'Idioma do app';

  @override
  String get languageDescription =>
      'O idioma do sistema é usado inicialmente. Quando você escolhe um idioma, sua escolha passa a prevalecer.';

  @override
  String get useSystemLanguage => 'Usar idioma do sistema';

  @override
  String currentLanguage(String localeCode) {
    return 'Atual: $localeCode';
  }

  @override
  String get portugueseBrazil => 'Português (Brasil)';

  @override
  String get portugueseBrazilDescription => 'Interface em português brasileiro';

  @override
  String get englishUnitedStates => 'Inglês (Estados Unidos)';

  @override
  String get englishUnitedStatesDescription => 'Interface em inglês';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearanceDescription => 'Tema visual da loja.';

  @override
  String get light => 'Claro';

  @override
  String get lightDescription => 'Papel quente, padrão';

  @override
  String get dark => 'Escuro';

  @override
  String get darkDescription => 'Tinta noturna';

  @override
  String get themeToggleTooltip => 'Alternar tema';
}
