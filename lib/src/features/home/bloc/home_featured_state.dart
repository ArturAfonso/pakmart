import 'package:pakmart/src/features/home/models/home_featured_app_data.dart';

enum HomeFeaturedStatus { initial, loading, success, failure }

class HomeFeaturedState {
  const HomeFeaturedState({
    this.status = HomeFeaturedStatus.initial,
    this.apps = const <HomeFeaturedAppData>[],
    this.errorMessage,
  });

  final HomeFeaturedStatus status;
  final List<HomeFeaturedAppData> apps;
  final String? errorMessage;

  HomeFeaturedState copyWith({HomeFeaturedStatus? status, List<HomeFeaturedAppData>? apps, String? errorMessage}) {
    return HomeFeaturedState(status: status ?? this.status, apps: apps ?? this.apps, errorMessage: errorMessage);
  }
}
