import 'package:blackbird/blackbird.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../domain/models/transaction_conditions.dart';

part 'update_spend_tracker_request.mapper.dart';

@MappableClass(includeCustomMappers: [TransactionConditionSimpleMapper()])
class UpdateSpendTrackerRequest with UpdateSpendTrackerRequestMappable {
  UpdateSpendTrackerRequest({
    required this.spendTrackerId,
    required this.userId,
    required this.condition,
  });

  final String spendTrackerId;
  final String userId;
  final TransactionCondition condition;
}
