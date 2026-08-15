import 'package:pakmart/src/core/preferences/app_preferences_repository.dart';
import 'package:pakmart/src/features/search/data/search_api.dart';
import 'package:pakmart/src/features/search/models/search_app_data.dart';

class SearchRepository {
  SearchRepository(this._api, this._preferences);

  final SearchApi _api;
  final AppPreferencesRepository _preferences;
  final Map<String, SearchPageData> _cache = <String, SearchPageData>{};

  Future<SearchPageData?> search({
    required String query,
    required int page,
    int perPage = 24,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    final showUnverifiedApps = _preferences.showUnverifiedApps;
    final key = '$normalizedQuery|$page|$perPage|$showUnverifiedApps';
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final data = await _api.search(
      query: query,
      page: page,
      perPage: perPage,
      showUnverifiedApps: showUnverifiedApps,
    );
    if (data != null) {
      _cache[key] = data;
    }

    return data;
  }
}
