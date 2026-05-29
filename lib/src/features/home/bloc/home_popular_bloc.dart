import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/home/bloc/popular_apps_state.dart';
import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';
import 'package:pakmart/src/features/home/repositories/home_featured_repository.dart';

sealed class HomePopularEvent {
  const HomePopularEvent();
}

final class HomePopularRequested extends HomePopularEvent {
  const HomePopularRequested();
}

final class HomePopularRetried extends HomePopularEvent {
  const HomePopularRetried();
}

class HomePopularBloc extends Bloc<HomePopularEvent, PopularAppsState> {
  HomePopularBloc(this._repository) : super(const PopularAppsState(perPage: 4)) {
    on<HomePopularRequested>(_onRequested);
    on<HomePopularRetried>(_onRetried);
  }

  final HomeFeaturedRepository _repository;

  Future<void> _onRequested(HomePopularRequested event, Emitter<PopularAppsState> emit) async {
    await _load(emit);
  }

  Future<void> _onRetried(HomePopularRetried event, Emitter<PopularAppsState> emit) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<PopularAppsState> emit) async {
    emit(state.copyWith(status: PopularAppsStatus.loading, clearErrorMessage: true));

    final response = await _repository.fetchCollectionPage(
      collection: HomePopularCollection.popular,
      page: 1,
      perPage: 4,
    );

    if (response == null || response.apps.isEmpty) {
      emit(
        state.copyWith(
          status: PopularAppsStatus.failure,
          errorMessage: 'Não conseguimos carregar os apps populares agora.',
          apps: const <HomePopularAppData>[],
          totalHits: 0,
          totalPages: 1,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PopularAppsStatus.success,
        apps: response.apps,
        page: response.page,
        perPage: response.perPage,
        totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
        totalHits: response.totalHits,
        collection: response.collection,
        clearErrorMessage: true,
      ),
    );
  }
}
