import 'package:dart_mappable/dart_mappable.dart';

part 'spend_tracker_condition_from_backend.mapper.dart';

@MappableClass()
class SpendTrackerConditionFromBackend with SpendTrackerConditionFromBackendMappable {
  SpendTrackerConditionFromBackend({
    required this.spendTrackerId,
    required this.spendTrackerName,
    required this.spendTrackerCreatedAt,
    this.spendTrackerNickname,
    required this.budgetId,
    required this.userId,
    required this.conditionId,
    this.parentId,
    required this.conditionType,
    this.testId,
    this.testType,
    this.testValue,
    required this.depth,
  });

  final String spendTrackerId;
  final String spendTrackerName;
  final DateTime spendTrackerCreatedAt;
  final String? spendTrackerNickname;

  final String budgetId;
  final String userId;

  final String conditionId;
  final String? parentId;
  final String conditionType;

  final String? testId;
  final String? testType;
  final String? testValue;

  final int depth;
}
