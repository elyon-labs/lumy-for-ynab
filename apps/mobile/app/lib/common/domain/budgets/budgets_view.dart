import 'package:equatable/equatable.dart';

sealed class BudgetsView extends Equatable {
  const BudgetsView();
}

class AllBudgets extends BudgetsView {
  const AllBudgets();

  @override
  List<Object> get props => [];
}
