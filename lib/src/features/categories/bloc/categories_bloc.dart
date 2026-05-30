import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';
import 'package:pakmart/src/features/categories/repositories/categories_repository.dart';

enum CategoriesStatus { initial, loading, success, failure }

sealed class CategoriesEvent {
  const CategoriesEvent();
}

final class CategoriesRequested extends CategoriesEvent {
  const CategoriesRequested({this.limit});

  final int? limit;
}

final class CategoriesRetried extends CategoriesEvent {
  const CategoriesRetried();
}

class CategoriesState {
  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const <CategoryShelfData>[],
    this.errorMessage,
    this.lastLimit,
  });

  final CategoriesStatus status;
  final List<CategoryShelfData> categories;
  final String? errorMessage;
  final int? lastLimit;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryShelfData>? categories,
    String? errorMessage,
    int? lastLimit,
    bool clearError = false,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastLimit: lastLimit ?? this.lastLimit,
    );
  }
}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._repository) : super(const CategoriesState()) {
    on<CategoriesRequested>(_onRequested);
    on<CategoriesRetried>(_onRetried);
  }

  final CategoriesRepository _repository;

  Future<void> _onRequested(CategoriesRequested event, Emitter<CategoriesState> emit) async {
    await _load(emit, limit: event.limit);
  }

  Future<void> _onRetried(CategoriesRetried event, Emitter<CategoriesState> emit) async {
    await _load(emit, limit: state.lastLimit);
  }

  Future<void> _load(Emitter<CategoriesState> emit, {int? limit}) async {
    emit(state.copyWith(status: CategoriesStatus.loading, clearError: true, lastLimit: limit));

    final categories = await _repository.fetchCategories();
    if (categories.isEmpty) {
      emit(
        state.copyWith(
          status: CategoriesStatus.failure,
          categories: const <CategoryShelfData>[],
          errorMessage: 'Não foi possível carregar as categorias agora.',
        ),
      );
      return;
    }

    final effectiveLimit = limit;
    final data = (effectiveLimit == null || effectiveLimit <= 0)
        ? categories
        : categories.take(effectiveLimit).toList(growable: false);

    emit(state.copyWith(status: CategoriesStatus.success, categories: data, clearError: true));
  }
}
