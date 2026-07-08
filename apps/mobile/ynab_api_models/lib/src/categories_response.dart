import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'categories_response.mapper.dart';

@MappableClass()
class CategoriesResponse with CategoriesResponseMappable {
  const CategoriesResponse({required this.data});

  final Categories data;
}

@MappableClass()
class Categories with CategoriesMappable {
  const Categories({required this.categoryGroups, required this.serverKnowledge});

  @MappableField(key: 'category_groups')
  final List<CategoryGroup> categoryGroups;
  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
}

@MappableClass()
class CategoryGroup extends Equatable with Searchable, CategoryGroupMappable {
  const CategoryGroup({
    required this.name,
    required this.id,
    required this.isHidden,
    required this.isDeleted,
    required this.categories,
  });

  final String name;
  final String id;
  @MappableField(key: 'hidden')
  final bool isHidden;
  @MappableField(key: 'deleted')
  final bool isDeleted;
  final List<Category> categories;

  @override
  List<Object?> get props => [name, id, isHidden, isDeleted, categories];

  @override
  String get searchKey => name;
}

@MappableClass()
class Category extends Equatable with Searchable, CategoryMappable {
  const Category({
    required this.id,
    required this.name,
    required this.categoryGroupId,
    required this.isHidden,
    required this.isDeleted,
    required this.activity,
    required this.budgeted,
    required this.balance,
    required this.targetType,
    required this.targetNeedsWholeAmount,
    required this.targetDay,
    required this.targetCadence,
    required this.targetCadenceFrequency,
    required this.targetCreationMonth,
    required this.targetBalance,
    required this.targetMonth,
    required this.targetPercentageComplete,
    required this.targetMonthsToBudget,
    required this.targetUnderFunded,
    required this.targetOverallFunded,
    required this.targetOverallLeft,
  });

  final String id;
  final String name;
  @MappableField(key: 'category_group_id')
  final String categoryGroupId;
  @MappableField(key: 'hidden')
  final bool isHidden;
  @MappableField(key: 'deleted')
  final bool isDeleted;

  // Current month props
  final int activity;
  final int budgeted;
  final int balance;

  // Target props
  @MappableField(key: 'goal_type')
  final TargetType? targetType;
  @MappableField(key: 'goal_needs_whole_amount')
  final bool? targetNeedsWholeAmount;
  @MappableField(key: 'goal_day')
  final int? targetDay;
  @MappableField(key: 'goal_cadence')
  final int? targetCadence;
  @MappableField(key: 'goal_cadence_frequency')
  final int? targetCadenceFrequency;
  @MappableField(key: 'goal_creation_month')
  final String? targetCreationMonth;
  @MappableField(key: 'goal_target')
  final int? targetBalance;
  @MappableField(key: 'goal_target_month')
  final String? targetMonth;
  @MappableField(key: 'goal_percentage_complete')
  final int? targetPercentageComplete;
  @MappableField(key: 'goal_months_to_budget')
  final int? targetMonthsToBudget;
  @MappableField(key: 'goal_under_funded')
  final int? targetUnderFunded;
  @MappableField(key: 'goal_overall_funded')
  final int? targetOverallFunded;
  @MappableField(key: 'goal_overall_left')
  final int? targetOverallLeft;

  @override
  List<Object?> get props => [
    id,
    name,
    categoryGroupId,
    isHidden,
    isDeleted,
    activity,
    budgeted,
    balance,
  ];

  @override
  String get searchKey => name;
}

@MappableEnum()
enum TargetType {
  // ignore: constant_identifier_names
  TB, // Target Category Balance
  // ignore: constant_identifier_names
  TBD, // Target Category Balance by Date
  // ignore: constant_identifier_names
  MF, // Monthly Funding
  // ignore: constant_identifier_names
  NEED, // Plan for Spending
  // ignore: constant_identifier_names
  DEBT, // Not documented by API
}
