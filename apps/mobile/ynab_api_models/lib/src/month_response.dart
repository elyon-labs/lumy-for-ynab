import 'package:dart_mappable/dart_mappable.dart';
import 'categories_response.dart';

part 'month_response.mapper.dart';

@MappableClass()
class MonthResponse with MonthResponseMappable {
  const MonthResponse({required this.data});

  final MonthData data;
}

@MappableClass()
class MonthData with MonthDataMappable {
  MonthData({required this.month});

  final SingleMonth month;
}

@MappableClass()
class SingleMonth with SingleMonthMappable {
  const SingleMonth({
    required this.month,
    required this.note,
    required this.income,
    required this.budgeted,
    required this.activity,
    required this.toBeBudgeted,
    required this.ageOfMoney,
    required this.isDeleted,
    required this.categories,
  });

  final String month;
  final String? note;
  final int income;
  final int budgeted;
  final int activity;
  @MappableField(key: 'to_be_budgeted')
  final int toBeBudgeted;
  @MappableField(key: 'age_of_money')
  final int? ageOfMoney;
  @MappableField(key: 'deleted')
  final bool isDeleted;
  final List<Category> categories;
}
