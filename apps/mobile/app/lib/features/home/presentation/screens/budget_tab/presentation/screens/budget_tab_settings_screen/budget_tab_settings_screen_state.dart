import 'package:oxidized/oxidized.dart';

class BudgetTabSettingsState {
  BudgetTabSettingsState({required this.categoryView, required this.useFrugalMonthLeftToSpend});

  factory BudgetTabSettingsState.initial() {
    return BudgetTabSettingsState(categoryView: const None(), useFrugalMonthLeftToSpend: false);
  }

  final Option<String> categoryView;
  final bool useFrugalMonthLeftToSpend;
}
