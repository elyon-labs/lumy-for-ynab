import 'package:dart_mappable/dart_mappable.dart';
import 'package:time_machine/time_machine.dart';

part 'frugal_month_from_backend.mapper.dart';

@MappableClass()
class FrugalMonthFromBackend with FrugalMonthFromBackendMappable {
  FrugalMonthFromBackend({
    required this.id,
    required this.budgetId,
    required this.month,
    required this.targetAmount,
  });

  final String id;
  final String budgetId;
  final LocalDate month;
  final int targetAmount;
}

@MappableClass()
class JoinedFrugalMonthFromBackend with JoinedFrugalMonthFromBackendMappable {
  JoinedFrugalMonthFromBackend({
    required this.id,
    required this.budgetId,
    required this.month,
    required this.targetAmount,
    required this.categoryIds,
    required this.accountIds,
  });

  final String id;
  final String budgetId;
  final LocalDate month;
  final int targetAmount;
  final List<String> categoryIds;
  final List<String> accountIds;
}
