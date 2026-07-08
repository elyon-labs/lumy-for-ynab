import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'months_response.mapper.dart';

@MappableClass()
class MonthsResponse with MonthsResponseMappable {
  const MonthsResponse({required this.data});

  final Months data;
}

@MappableClass()
class Months with MonthsMappable {
  const Months({required this.serverKnowledge, required this.months});

  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
  final List<Month> months;
}

@MappableClass()
class Month extends Equatable with MonthMappable {
  const Month({
    required this.month,
    required this.note,
    required this.income,
    required this.budgeted,
    required this.activity,
    required this.toBeBudgeted,
    required this.ageOfMoney,
    required this.isDeleted,
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

  @override
  List<Object?> get props => [
    month,
    note,
    income,
    budgeted,
    activity,
    toBeBudgeted,
    ageOfMoney,
    isDeleted,
  ];
}
