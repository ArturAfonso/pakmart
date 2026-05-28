import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pakmart/src/features/apps/bloc/app_info_state.dart';
import 'package:pakmart/src/features/apps/repositories/app_info_repository.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  AppInfoCubit(this._repository) : super(const AppInfoState());

  final AppInfoRepository _repository;

  Future<void> load(String routeAppId) async {
    emit(state.copyWith(status: AppInfoStatus.loading, clearError: true));

    try {
      final detail = await _repository.loadDetail(routeAppId);
      if (detail == null) {
        emit(state.copyWith(status: AppInfoStatus.failure, errorMessage: 'Aplicativo nao encontrado no Flathub.'));
        return;
      }

      emit(state.copyWith(status: AppInfoStatus.loaded, detail: detail, clearError: true));
    } on AppInfoLoadException catch (error) {
      emit(state.copyWith(status: AppInfoStatus.failure, errorMessage: _messageFor(error.reason)));
    } catch (_) {
      emit(
        state.copyWith(
          status: AppInfoStatus.failure,
          errorMessage: 'Nao foi possivel carregar os detalhes no Flathub.',
        ),
      );
    }
  }

  String _messageFor(AppInfoLoadFailureReason reason) {
    switch (reason) {
      case AppInfoLoadFailureReason.notFound:
        return 'Aplicativo nao encontrado no Flathub.';
      case AppInfoLoadFailureReason.offline:
        return 'Sem conexao com a internet. Verifique sua rede e tente novamente.';
      case AppInfoLoadFailureReason.server:
        return 'O Flathub esta indisponivel agora. Tente novamente em instantes.';
      case AppInfoLoadFailureReason.invalidData:
        return 'O Flathub respondeu com dados invalidos para este aplicativo.';
      case AppInfoLoadFailureReason.unknown:
        return 'Nao foi possivel carregar os detalhes no Flathub.';
    }
  }
}
