import 'package:dart_mappable/dart_mappable.dart';
import 'package:time_machine/time_machine.dart';

part 'insert_frugal_month_request.mapper.dart';

@MappableClass()
class InsertFrugalMonthRequest with InsertFrugalMonthRequestMappable {
  InsertFrugalMonthRequest({
    required this.userId,
    required this.budgetId,
    required this.month,
    required this.targetAmount,
    required this.categoryIds,
    required this.accountIds,
  });

  final String userId;
  final String budgetId;
  final LocalDate month;
  final int targetAmount;
  final List<String> categoryIds;
  final List<String> accountIds;
}
