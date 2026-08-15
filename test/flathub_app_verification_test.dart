import 'package:flutter_test/flutter_test.dart';
import 'package:pakmart/src/core/models/flathub_app_info_model.dart';
import 'package:pakmart/src/core/models/flathub_app_verification.dart';

void main() {
  test(
    'does not treat verification metadata with a null value as verified',
    () {
      final app = _appWithVerification(null);

      expect(isFlathubAppVerified(app), isFalse);
    },
  );

  test('recognizes explicit verification values', () {
    expect(isFlathubAppVerified(_appWithVerification(true)), isTrue);
    expect(isFlathubAppVerified(_appWithVerification('yes')), isTrue);
    expect(isFlathubAppVerified(_appWithVerification(false)), isFalse);
  });
}

FlathubAppInfo _appWithVerification(Object? value) {
  return FlathubAppInfo(
    type: 'desktop-application',
    id: 'com.example.App',
    name: 'Example',
    metadata: {'flathub::verification::verified': value},
  );
}
