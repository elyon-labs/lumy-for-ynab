import 'package:blackbird/blackbird.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../domain/models/transaction_conditions.dart';

part 'insert_spend_tracker_request.mapper.dart';

@MappableClass(ignoreNull: true, includeCustomMappers: [TransactionConditionSimpleMapper()])
class InsertSpendTrackerRequest with InsertSpendTrackerRequestMappable {
  InsertSpendTrackerRequest({
    required this.userId,
    required this.budgetId,
    required this.condition,
    required this.name,
    this.nickName,
    this.createdAt,
  });

  final String userId;
  final String budgetId;
  final TransactionCondition condition;
  final String name;
  final String? nickName;
  final DateTime? createdAt;
}
