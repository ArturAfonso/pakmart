import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_event.dart';
import 'package:pakmart/src/features/home/bloc/home_featured_state.dart';
import 'package:pakmart/src/features/home/models/home_featured_app_data.dart';
import 'package:pakmart/src/features/home/repositories/home_featured_repository.dart';

class HomeFeaturedBloc extends Bloc<HomeFeaturedEvent, HomeFeaturedState> {
  HomeFeaturedBloc(this._repository) : super(const HomeFeaturedState()) {
    on<HomeFeaturedRequested>(_onRequested);
  }

  final HomeFeaturedRepository _repository;

  Future<void> _onRequested(HomeFeaturedRequested event, Emitter<HomeFeaturedState> emit) async {
    emit(state.copyWith(status: HomeFeaturedStatus.loading, errorMessage: null));

    final appIds = await _repository.fetchAppsOfTheWeek();
    if (appIds.isEmpty) {
      emit(state.copyWith(status: HomeFeaturedStatus.failure, errorMessage: 'Nenhum app em destaque encontrado.'));
      return;
    }

    final ordered = List<HomeFeaturedAppData?>.filled(appIds.length, null);
    final futures = <Future<_IndexedFeatured>>[];

    for (final entry in appIds.asMap().entries) {
      final index = entry.key;
      final appId = entry.value;
      futures.add(_safeFetch(index, appId));
    }

    await for (final result in Stream<_IndexedFeatured>.fromFutures(futures)) {
      if (result.app != null) {
        ordered[result.index] = result.app;
        emit(
          state.copyWith(
            status: HomeFeaturedStatus.loading,
            apps: ordered.whereType<HomeFeaturedAppData>().toList(growable: false),
          ),
        );
      }
    }

    final resolved = ordered.whereType<HomeFeaturedAppData>().toList(growable: false);
    if (resolved.isEmpty) {
      emit(state.copyWith(status: HomeFeaturedStatus.failure, errorMessage: 'Falha ao carregar apps destacados.'));
      return;
    }

    emit(state.copyWith(status: HomeFeaturedStatus.success, apps: resolved));
  }

  Future<_IndexedFeatured> _safeFetch(int index, String appId) async {
    try {
      final app = await _repository.fetchFeaturedApp(appId);
      return _IndexedFeatured(index: index, app: app);
    } catch (_) {
      return _IndexedFeatured(index: index, app: null);
    }
  }
}

class _IndexedFeatured {
  const _IndexedFeatured({required this.index, required this.app});

  final int index;
  final HomeFeaturedAppData? app;
}
