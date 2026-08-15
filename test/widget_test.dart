import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pakmart/l10n/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations', () {
    test('loads the Portuguese interface', () async {
      final l10n = await AppLocalizations.delegate.load(
        const Locale('pt', 'BR'),
      );

      expect(l10n.explore, 'Explorar');
      expect(l10n.install, 'Instalar');
      expect(l10n.searchResultsFor(2, 'editor'), '2 resultados para "editor"');
    });

    test('loads the English interface', () async {
      final l10n = await AppLocalizations.delegate.load(
        const Locale('en', 'US'),
      );

      expect(l10n.explore, 'Explore');
      expect(l10n.install, 'Install');
      expect(l10n.searchResultsFor(2, 'editor'), '2 results for "editor"');
    });

    test('localizes category and permission presentation', () async {
      final l10n = await AppLocalizations.delegate.load(
        const Locale('en', 'US'),
      );

      expect(l10n.categoryTitle('game', 'Jogos'), 'Games');
      expect(l10n.permissionTitle('camera', 'Usar câmera'), 'Use the camera');
      expect(l10n.permissionSectionTitle('DISPOSITIVOS'), 'DEVICES');
    });
  });
}
