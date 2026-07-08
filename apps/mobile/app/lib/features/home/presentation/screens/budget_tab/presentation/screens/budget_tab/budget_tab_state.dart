import 'package:oxidized/oxidized.dart';

import '../../../../../../../category_views/domain/models/category_view.dart';
import '../../../../../../../frugal_month/domain/models/frugal_month.dart';

class BudgetTabState {
  BudgetTabState({
    required this.selectedBudgetName,
    required this.plannedFrugalMonth,
    required this.currentFrugalMonth,
    required this.selectedCategoryView,
    required this.isLoading,
  });

  factory BudgetTabState.initial() {
    return BudgetTabState(
      selectedBudgetName: const None(),
      plannedFrugalMonth: null,
      currentFrugalMonth: const None(),
      selectedCategoryView: const None(),
      isLoading: true,
    );
  }

  final Option<String> selectedBudgetName;
  final FrugalMonth? plannedFrugalMonth;
  final Option<FrugalMonth> currentFrugalMonth;
  final Option<CategoryView> selectedCategoryView;
  final bool isLoading;
}
