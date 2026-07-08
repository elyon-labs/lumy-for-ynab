import 'package:collection/collection.dart';
import 'package:ynab_api_models/ynab_api_models.dart';
import '_category.dart';

extension IterableCategoryGroupX on Iterable<CategoryGroup> {
  Iterable<CategoryGroup> whereSpecial() {
    return where((c) => c.isSpecial);
  }

  Iterable<CategoryGroup> whereNotSpecial() {
    return whereNot((c) => c.isSpecial);
  }

  Iterable<CategoryGroup> whereNotDeleted() {
    return whereNot((c) => c.isDeleted);
  }

  Iterable<CategoryGroup> whereHidden() {
    return where((c) => c.isHidden);
  }

  Iterable<CategoryGroup> whereNotHidden() {
    return whereNot((c) => c.isHidden);
  }

  Iterable<CategoryGroup> whereHiddenOrSpecial() {
    return where((c) => c.isHidden || c.isSpecial);
  }

  Iterable<CategoryGroup> whereHasCategories() {
    return whereNot((c) => c.categories.isEmpty);
  }

  Iterable<Category> get categories {
    return expand((cg) => cg.categories);
  }

  CategoryGroup? matchingCategoryGroup(Category category) {
    return firstWhereOrNull((cg) => cg.categories.contains(category));
  }

  List<String> get ids => map((c) => c.id).toList();
}

extension CategoryGroupX on CategoryGroup {
  bool get isCreditCardPayments {
    return name == 'Credit Card Payments';
  }

  bool get isInternalMasterCategory {
    return name == 'Internal Master Category';
  }

  bool get isSpecial => isCreditCardPayments || isInternalMasterCategory;

  List<String> get categoryIds => categories.map((c) => c.id).toList();

  double get remainingPercent {
    if (categories.isEmpty) return 0;
    if (initialBalance == 0) return 0;
    if (remainingBalance == 0) return 0;
    return remainingBalance / initialBalance;
  }

  int get remainingBalance {
    if (categories.isEmpty) return 0;
    return categories.map((e) => e.balance).sum;
  }

  int get initialBalance {
    if (categories.isEmpty) return 0;
    return categories.map((e) => e.initialBalance).sum;
  }
}
