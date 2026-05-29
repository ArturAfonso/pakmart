import 'package:pakmart/src/features/home/models/home_popular_app_data.dart';

abstract class PopularAppsEvent {
  const PopularAppsEvent();
}

class PopularAppsRequested extends PopularAppsEvent {
  const PopularAppsRequested();
}

class PopularAppsRetried extends PopularAppsEvent {
  const PopularAppsRetried();
}

class PopularAppsPageChanged extends PopularAppsEvent {
  const PopularAppsPageChanged(this.page);

  final int page;
}

class PopularAppsCollectionChanged extends PopularAppsEvent {
  const PopularAppsCollectionChanged(this.collection);

  final HomePopularCollection collection;
}
