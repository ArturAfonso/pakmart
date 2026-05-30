import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
import 'package:pakmart/src/features/categories/repositories/categories_repository.dart';

enum CategoryAppsStatus { initial, loading, success, failure }

sealed class CategoryAppsEvent {
  const CategoryAppsEvent();
}

final class CategoryAppsRequested extends CategoryAppsEvent {
  const CategoryAppsRequested();
}

final class CategoryAppsRetried extends CategoryAppsEvent {
  const CategoryAppsRetried();
}

final class CategoryAppsPageChanged extends CategoryAppsEvent {
  const CategoryAppsPageChanged(this.page);

  final int page;
}

final class CategoryAppsSortChanged extends CategoryAppsEvent {
  const CategoryAppsSortChanged(this.sortBy);

  final CategorySortBy sortBy;
}

class CategoryAppsState {
  const CategoryAppsState({
    required this.category,
    required this.presentation,
    this.status = CategoryAppsStatus.initial,
    this.page = 1,
    this.perPage = 24,
    this.totalPages = 1,
    this.totalHits = 0,
    this.sortBy = CategorySortBy.installsLastMonth,
    this.apps = const <CategoryShelfAppData>[],
    this.errorMessage,
  });

  final String category;
  final CategoryShelfData presentation;
  final CategoryAppsStatus status;
  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final CategorySortBy sortBy;
  final List<CategoryShelfAppData> apps;
  final String? errorMessage;

  bool get canGoPrevious => page > 1;
  bool get canGoNext => page < totalPages;

  CategoryAppsState copyWith({
    CategoryAppsStatus? status,
    int? page,
    int? perPage,
    int? totalPages,
    int? totalHits,
    CategorySortBy? sortBy,
    List<CategoryShelfAppData>? apps,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryAppsState(
      category: category,
      presentation: presentation,
      status: status ?? this.status,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      totalHits: totalHits ?? this.totalHits,
      sortBy: sortBy ?? this.sortBy,
      apps: apps ?? this.apps,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CategoryAppsBloc extends Bloc<CategoryAppsEvent, CategoryAppsState> {
  CategoryAppsBloc({required CategoriesRepository repository, required String category})
      : _repository = repository,
        super(CategoryAppsState(category: category, presentation: repository.resolveCategoryPresentation(category))) {
    on<CategoryAppsRequested>(_onRequested);
    on<CategoryAppsRetried>(_onRetried);
    on<CategoryAppsPageChanged>(_onPageChanged);
    on<CategoryAppsSortChanged>(_onSortChanged);
  }

  final CategoriesRepository _repository;

  Future<void> _onRequested(CategoryAppsRequested event, Emitter<CategoryAppsState> emit) async {
    await _load(emit, page: state.page, sortBy: state.sortBy, keepCurrentApps: state.apps.isNotEmpty);
  }

  Future<void> _onRetried(CategoryAppsRetried event, Emitter<CategoryAppsState> emit) async {
    await _load(emit, page: state.page, sortBy: state.sortBy, keepCurrentApps: state.apps.isNotEmpty);
  }

  Future<void> _onPageChanged(CategoryAppsPageChanged event, Emitter<CategoryAppsState> emit) async {
    final target = event.page.clamp(1, state.totalPages);
    if (target == state.page) {
      return;
    }

    await _load(emit, page: target, sortBy: state.sortBy, keepCurrentApps: true);
  }

  Future<void> _onSortChanged(CategoryAppsSortChanged event, Emitter<CategoryAppsState> emit) async {
    if (event.sortBy == state.sortBy) {
      return;
    }

    await _load(emit, page: 1, sortBy: event.sortBy, keepCurrentApps: false);
  }

  Future<void> _load(
    Emitter<CategoryAppsState> emit, {
    required int page,
    required CategorySortBy sortBy,
    required bool keepCurrentApps,
  }) async {
    emit(
      state.copyWith(
        status: CategoryAppsStatus.loading,
        page: page,
        sortBy: sortBy,
        apps: keepCurrentApps ? state.apps : const <CategoryShelfAppData>[],
        clearError: true,
      ),
    );

    final response = await _repository.fetchCategoryApps(
      category: state.category,
      page: page,
      perPage: state.perPage,
      sortBy: sortBy,
    );

    if (response == null) {
      emit(
        state.copyWith(
          status: CategoryAppsStatus.failure,
          page: page,
          sortBy: sortBy,
          errorMessage: 'Não foi possível carregar os apps dessa categoria.',
        ),
      );
      return;
    }

    if (response.apps.isEmpty) {
      emit(
        state.copyWith(
          status: CategoryAppsStatus.failure,
          page: response.page,
          totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
          totalHits: response.totalHits,
          apps: const <CategoryShelfAppData>[],
          errorMessage: 'Nenhum app encontrado nesta categoria.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CategoryAppsStatus.success,
        page: response.page,
        perPage: response.perPage,
        totalPages: response.totalPages <= 0 ? 1 : response.totalPages,
        totalHits: response.totalHits,
        apps: response.apps,
        clearError: true,
      ),
    );
  }
}
