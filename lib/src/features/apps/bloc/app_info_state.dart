import 'package:pakmart/src/features/apps/models/app_detail_data.dart';

enum AppInfoStatus { initial, loading, loaded, failure }

class AppInfoState {
  const AppInfoState({this.status = AppInfoStatus.initial, this.detail, this.errorMessage});

  final AppInfoStatus status;
  final AppDetailData? detail;
  final String? errorMessage;

  AppInfoState copyWith({AppInfoStatus? status, AppDetailData? detail, String? errorMessage, bool clearError = false}) {
    return AppInfoState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
