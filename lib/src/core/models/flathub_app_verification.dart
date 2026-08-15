import 'package:pakmart/src/core/models/flathub_app_info_model.dart';

bool isFlathubAppVerified(FlathubAppInfo info) {
  final metadata = info.metadata;
  if (metadata == null || metadata.isEmpty) {
    return false;
  }

  final direct = metadata['flathub::verification::verified'];
  if (direct is bool) {
    return direct;
  }
  if (direct is String) {
    final value = direct.toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }
  if (direct is num) {
    return direct == 1;
  }

  return false;
}
