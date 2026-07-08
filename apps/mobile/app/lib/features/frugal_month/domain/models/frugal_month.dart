import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../common/presentation/_int.dart';

part 'frugal_month.mapper.dart';

@MappableClass()
class FrugalMonth extends Equatable with FrugalMonthMappable {
  const FrugalMonth({
    required this.id,
    required this.month,
    required this.budgetId,
    required this.targetAmount,
    required this.categoryIds,
    required this.accountIds,
  });

  final String id;
  final LocalDate month;
  final String budgetId;
  final int targetAmount;
  final List<String> categoryIds;
  final List<String> accountIds;

  @override
  List<Object?> get props => [id, month, budgetId, targetAmount, categoryIds, accountIds];
}

extension FrugalMonthX on FrugalMonth {
  String get name => 'Frugal ${month.monthOfYear.toMonthName()}';
}
