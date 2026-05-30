import 'package:pakmart/src/features/search/data/search_api.dart';
import 'package:pakmart/src/features/search/models/search_app_data.dart';

class SearchRepository {
  SearchRepository(this._api);

  final SearchApi _api;
  final Map<String, SearchPageData> _cache = <String, SearchPageData>{};

  Future<SearchPageData?> search({required String query, required int page, int perPage = 24}) async {
    final normalizedQuery = query.trim().toLowerCase();
    final key = '$normalizedQuery|$page|$perPage';
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final data = await _api.search(query: query, page: page, perPage: perPage);
    if (data != null) {
      _cache[key] = data;
    }

    return data;
  }
}
