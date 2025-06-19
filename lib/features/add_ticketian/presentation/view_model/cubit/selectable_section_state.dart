part of 'selectable_section_cubit.dart';

sealed class SelectableSectionState {}

final class SelectableSectionInitial extends SelectableSectionState {}

final class FetchSelectableSectionsLoading extends SelectableSectionState {}

final class FetchSelectableSectionsSuccess extends SelectableSectionState {
  final List<SectionModel> sections;
  FetchSelectableSectionsSuccess({required this.sections});
}

final class FetchSelectableSectionsFailure extends SelectableSectionState {
  final String errMessage;
  FetchSelectableSectionsFailure({required this.errMessage});
}
