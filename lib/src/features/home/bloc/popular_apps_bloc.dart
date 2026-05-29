import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_event.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_state.dart';
import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';
import 'package:pakmart/src/features/home/repositories/home_featured_repository.dart';

class PopularAppsBloc extends Bloc<PopularAppsEvent, PopularAppsState> {
  PopularAppsBloc(this._repository) : super(const PopularAppsState()) {
    on<PopularAppsRequested>(_onRequested);
    on<PopularAppsRetried>(_onRetried);
    on<PopularAppsPageChanged>(_onPageChanged);
    on<PopularAppsCollectionChanged>(_onCollectionChanged);
  }

  final HomeFeaturedRepository _repository;

  Future<void> _onRequested(PopularAppsRequested event, Emitter<PopularAppsState> emit) async {
    await _loadPage(
      emit,
      collection: state.collection,
      page: state.page,
      keepCurrentApps: state.apps.isNotEmpty,
    );
  }

  Future<void> _onRetried(PopularAppsRetried event, Emitter<PopularAppsState> emit) async {
    await _loadPage(
      emit,
      collection: state.collection,
      page: state.page,
      keepCurrentApps: state.apps.isNotEmpty,
    );
  }

  Future<void> _onPageChanged(PopularAppsPageChanged event, Emitter<PopularAppsState> emit) async {
    final targetPage = event.page.clamp(1, state.totalPages);
    if (targetPage == state.page) {
      return;
    }

    await _loadPage(emit, collection: state.collection, page: targetPage, keepCurrentApps: true);
  }

  Future<void> _onCollectionChanged(PopularAppsCollectionChanged event, Emitter<PopularAppsState> emit) async {
    if (event.collection == state.collection) {
      return;
    }

    await _loadPage(emit, collection: event.collection, page: 1, keepCurrentApps: false);
  }

  Future<void> _loadPage(
    Emitter<PopularAppsState> emit, {
    required HomePopularCollection collection,
    required int page,
    required bool keepCurrentApps,
  }) async {
    emit(
      state.copyWith(
        status: PopularAppsStatus.loading,
        collection: collection,
        page: page,
        apps: keepCurrentApps ? state.apps : const <HomePopularAppData>[],
        clearErrorMessage: true,
      ),
    );

    final response = await _repository.fetchCollectionPage(collection: collection, page: page, perPage: state.perPage);
    if (response == null) {
      emit(
        state.copyWith(
          status: PopularAppsStatus.failure,
          collection: collection,
          page: page,
          errorMessage: 'Não foi possível carregar os apps agora. Tente novamente.',
        ),
      );
      return;
    }

    if (response.apps.isEmpty) {
      emit(
        state.copyWith(
          status: PopularAppsStatus.failure,
          collection: collection,
          page: response.page,
          totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
          totalHits: response.totalHits,
          apps: const <HomePopularAppData>[],
          errorMessage: 'Nenhum app encontrado para esta coleção.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PopularAppsStatus.success,
        collection: collection,
        page: response.page,
        perPage: response.perPage,
        totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
        totalHits: response.totalHits,
        apps: response.apps,
        clearErrorMessage: true,
      ),
    );
  }
}
