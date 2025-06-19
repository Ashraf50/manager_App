import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/section.dart';
import 'package:manager_app/features/add_ticketian/data/repo/ticketian_repo.dart';
part 'selectable_section_state.dart';

class SelectableSectionCubit extends Cubit<SelectableSectionState> {
  TicketianRepo repo;
  SelectableSectionCubit(this.repo) : super(SelectableSectionInitial());
  Future<void> fetchSelectableSections({
    required int serviceId,
  }) async {
    emit(FetchSelectableSectionsLoading());
    var result = await repo.fetchAllSections(serviceId: serviceId);
    result.fold(
      (failure) {
        emit(
          FetchSelectableSectionsFailure(errMessage: failure.errMessage),
        );
      },
      (sections) {
        emit(
          FetchSelectableSectionsSuccess(sections: sections),
        );
      },
    );
  }
}
