import 'package:equatable/equatable.dart';

sealed class CategoryGroupsView extends Equatable {
  const CategoryGroupsView();
}

class AllCategoryGroups extends CategoryGroupsView {
  const AllCategoryGroups();

  @override
  List<Object?> get props => [];
}

class WithoutHiddenAndSpecialGroups extends CategoryGroupsView {
  const WithoutHiddenAndSpecialGroups({
    this.includeCreditCardPayments = false,
    this.includeInternalMaster = false,
  });

  final bool includeCreditCardPayments;
  final bool includeInternalMaster;

  @override
  List<Object?> get props => [includeCreditCardPayments, includeInternalMaster];
}

class OnlyHiddenAndSpecialGroups extends CategoryGroupsView {
  const OnlyHiddenAndSpecialGroups();

  @override
  List<Object?> get props => [];
}
