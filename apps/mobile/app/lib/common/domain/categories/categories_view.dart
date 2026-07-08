import 'package:equatable/equatable.dart';

sealed class CategoriesView extends Equatable {
  const CategoriesView();
}

class AllCategories extends CategoriesView {
  const AllCategories();

  @override
  List<Object?> get props => [];
}

class CategoriesInSelectedView extends CategoriesView {
  const CategoriesInSelectedView();

  @override
  List<Object?> get props => [];
}

class CategoriesInView extends CategoriesView {
  const CategoriesInView(this.viewId);

  final String viewId;

  @override
  List<Object?> get props => [viewId];
}

class CategoriesWithIds extends CategoriesView {
  const CategoriesWithIds(this.categoryIds);

  final List<String> categoryIds;

  @override
  List<Object?> get props => [categoryIds];
}

class ExpenseCategories extends CategoriesView {
  const ExpenseCategories();

  @override
  List<Object?> get props => [];
}

class ExpensesInSelectedView extends CategoriesView {
  const ExpensesInSelectedView();

  @override
  List<Object?> get props => [];
}
