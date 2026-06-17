import 'package:pakmart/src/features/search/models/search_app_data.dart';

enum SearchStatus { idle, loading, success, failure }

class SearchState {
  const SearchState({
    this.status = SearchStatus.idle,
    this.query = '',
    this.page = 1,
    this.perPage = 24,
    this.totalPages = 1,
    this.totalHits = 0,
    this.results = const <SearchAppData>[],
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final List<SearchAppData> results;
  final String? errorMessage;

  bool get hasQuery => query.trim().isNotEmpty;
  bool get canGoNext => page < totalPages;
  bool get canGoPrevious => page > 1;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    int? page,
    int? perPage,
    int? totalPages,
    int? totalHits,
    List<SearchAppData>? results,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      totalHits: totalHits ?? this.totalHits,
      results: results ?? this.results,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
