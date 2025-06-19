import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_app/features/settings/data/setting_repo.dart';

class SettingsState {
  final bool automaticAssignment;
  final bool isLoading;

  SettingsState({required this.automaticAssignment, this.isLoading = false});

  SettingsState copyWith({bool? automaticAssignment, bool? isLoading}) {
    return SettingsState(
      automaticAssignment: automaticAssignment ?? this.automaticAssignment,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingRepo settingRepo;

  SettingsCubit(this.settingRepo)
      : super(SettingsState(automaticAssignment: false));

  Future<void> fetchSettings() async {
    emit(state.copyWith(isLoading: true));
    final result = await settingRepo.fetchAutomaticAssignment();
    emit(state.copyWith(automaticAssignment: result, isLoading: false));
  }

  Future<void> toggleAssignment(bool value) async {
    emit(state.copyWith(automaticAssignment: value));
    await settingRepo.updateAutomaticAssignment(value);
  }
}
