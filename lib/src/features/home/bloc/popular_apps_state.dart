import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';

enum PopularAppsStatus { initial, loading, success, failure }

class PopularAppsState {
  const PopularAppsState({
    this.status = PopularAppsStatus.initial,
    this.collection = HomePopularCollection.popular,
    this.page = 1,
    this.perPage = 24,
    this.totalPages = 1,
    this.totalHits = 0,
    this.apps = const <HomePopularAppData>[],
    this.errorMessage,
  });

  final PopularAppsStatus status;
  final HomePopularCollection collection;
  final int page;
  final int perPage;
  final int totalPages;
  final int totalHits;
  final List<HomePopularAppData> apps;
  final String? errorMessage;

  bool get canGoPrevious => page > 1;
  bool get canGoNext => page < totalPages;

  PopularAppsState copyWith({
    PopularAppsStatus? status,
    HomePopularCollection? collection,
    int? page,
    int? perPage,
    int? totalPages,
    int? totalHits,
    List<HomePopularAppData>? apps,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PopularAppsState(
      status: status ?? this.status,
      collection: collection ?? this.collection,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      totalHits: totalHits ?? this.totalHits,
      apps: apps ?? this.apps,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
