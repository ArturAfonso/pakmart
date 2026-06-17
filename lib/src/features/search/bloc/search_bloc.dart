import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/search/bloc/search_event.dart';
import 'package:pakmart/src/features/search/bloc/search_state.dart';
import 'package:pakmart/src/features/search/models/search_app_data.dart';
import 'package:pakmart/src/features/search/repositories/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const int _autoSearchMinLength = 4;

  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<SearchPageChanged>(_onPageChanged);
    on<SearchRetried>(_onRetried);
  }

  final SearchRepository _repository;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();

    _debounce?.cancel();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.idle,
          query: '',
          page: 1,
          totalPages: 1,
          totalHits: 0,
          results: const <SearchAppData>[],
          clearErrorMessage: true,
        ),
      );
      return;
    }

    if (query.length < _autoSearchMinLength) {
      emit(
        state.copyWith(
          query: query,
          page: 1,
          totalPages: 1,
          totalHits: 0,
          results: const <SearchAppData>[],
          status: SearchStatus.idle,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(state.copyWith(query: query, page: 1, status: SearchStatus.loading, clearErrorMessage: true));

    _debounce = Timer(const Duration(milliseconds: 420), () {
      add(const SearchSubmitted());
    });
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    final query = state.query.trim();
    if (query.isEmpty) {
      return;
    }

    _debounce?.cancel();
    await _loadPage(emit, query: query, page: 1, keepCurrentResults: false);
  }

  Future<void> _onRetried(SearchRetried event, Emitter<SearchState> emit) async {
    if (!state.hasQuery) {
      return;
    }

    await _loadPage(emit, query: state.query, page: state.page, keepCurrentResults: state.results.isNotEmpty);
  }

  Future<void> _onPageChanged(SearchPageChanged event, Emitter<SearchState> emit) async {
    if (!state.hasQuery) {
      return;
    }

    final targetPage = event.page.clamp(1, state.totalPages);
    if (targetPage == state.page) {
      return;
    }

    await _loadPage(emit, query: state.query, page: targetPage, keepCurrentResults: true);
  }

  Future<void> _loadPage(
    Emitter<SearchState> emit, {
    required String query,
    required int page,
    required bool keepCurrentResults,
  }) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        page: page,
        results: keepCurrentResults ? state.results : const <SearchAppData>[],
        clearErrorMessage: true,
      ),
    );

    final response = await _repository.search(query: query, page: page, perPage: state.perPage);
    if (response == null) {
      emit(state.copyWith(status: SearchStatus.failure, errorMessage: 'Falha ao buscar apps. Tente novamente.'));
      return;
    }

    if (response.apps.isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.success,
          query: response.query,
          page: response.page,
          perPage: response.perPage,
          totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
          totalHits: response.totalHits,
          results: const <SearchAppData>[],
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SearchStatus.success,
        query: response.query,
        page: response.page,
        perPage: response.perPage,
        totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
        totalHits: response.totalHits,
        results: response.apps,
        clearErrorMessage: true,
      ),
    );
  }
}
