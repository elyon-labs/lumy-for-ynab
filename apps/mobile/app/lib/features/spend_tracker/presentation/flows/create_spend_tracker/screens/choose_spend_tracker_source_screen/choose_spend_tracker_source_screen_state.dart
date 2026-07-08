import 'package:ynab_api_models/ynab_api_models.dart';

class ChooseSpendTrackerSourceScreenState {
  ChooseSpendTrackerSourceScreenState({required this.categoryGroups, required this.payees});

  factory ChooseSpendTrackerSourceScreenState.initial() {
    return ChooseSpendTrackerSourceScreenState(categoryGroups: [], payees: []);
  }

  final List<CategoryGroup> categoryGroups;
  final List<Payee> payees;
}
