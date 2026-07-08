/// A function that watches a budget's data given a [budgetId].
typedef BudgetDataWatcher<T> = Stream<T> Function(String budgetId);
