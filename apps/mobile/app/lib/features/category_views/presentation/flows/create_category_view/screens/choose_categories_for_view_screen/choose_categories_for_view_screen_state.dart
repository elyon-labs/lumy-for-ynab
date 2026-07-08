import 'package:dart_foundation/dart_foundation.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

class ChooseCategoriesForViewScreenState {
  ChooseCategoriesForViewScreenState({required this.categoryGroups});

  factory ChooseCategoriesForViewScreenState.initial() {
    return ChooseCategoriesForViewScreenState(categoryGroups: const Loading());
  }

  final Async<List<CategoryGroup>> categoryGroups;
}
