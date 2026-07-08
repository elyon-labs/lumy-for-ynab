import 'dart:async';

import 'package:blackbird/blackbird.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../auth/data/api/auth_api.dart';
import '../../domain/models/spend_tracker.dart';
import '../../domain/models/transaction_conditions.dart';
import '../api/spend_trackers_api.dart';
import '../models/spend_tracker_condition_from_backend.dart';

class SpendTrackersRepository {
  SpendTrackersRepository({required SpendTrackersApi api, required AuthApi authApi})
    : _api = api,
      _authApi = authApi {
    unawaited(_fetchSpendTrackers());
    _subs.add(_authApi.onAuthenticated(refresh));
  }

  factory SpendTrackersRepository.create() {
    return SpendTrackersRepository(api: inject(), authApi: inject());
  }

  final SpendTrackersApi _api;
  final AuthApi _authApi;
  final _subject = BehaviorSubject<List<SpendTracker>>.seeded(<SpendTracker>[]);
  final _subs = CompositeSubscription();

  Stream<List<SpendTracker>> get watch => _subject.stream;

  Future<void> _fetchSpendTrackers() async {
    final spendTrackers = await _api.fetchSpendTrackers();
    _subject.add(spendTrackers.toDomain());
  }

  Future<void> refresh() async {
    await _fetchSpendTrackers();
  }

  Future<Result<String, Exception>> insertSpendTracker({
    required String budgetId,
    required TransactionCondition condition,
    required String name,
    // Below are only for migration purposes
    String? nickName,
    DateTime? createdAt,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.insertSpendTracker(
        userId: user.id,
        budgetId: budgetId,
        condition: condition,
        name: name,
        nickName: nickName,
      );
    });
  }

  Future<Result<void, Exception>> updateSpendTracker(
    String spendTrackerId, {
    required TransactionCondition condition,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.updateSpendTracker(spendTrackerId, userId: user.id, condition: condition);
    });
  }

  Future<Result<void, Exception>> deleteSpendTracker(String spendTrackerId) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.deleteSpendTracker(spendTrackerId, userId: user.id);
    });
  }

  Future<Result<void, Exception>> renameSpendTracker(
    String spendTrackerId, {
    required String name,
  }) {
    return _api.renameSpendTracker(spendTrackerId, name: name);
  }

  Future<void> dispose() async {
    await _subject.close();
    await _subs.dispose();
  }
}

extension on List<SpendTrackerConditionFromBackend> {
  List<SpendTracker> toDomain() {
    Map<String, List<SpendTrackerConditionFromBackend>> groupConditionsByTracker() {
      final grouped = <String, List<SpendTrackerConditionFromBackend>>{};
      for (final row in this) {
        grouped.putIfAbsent(row.spendTrackerId, () => []).add(row);
      }
      return grouped;
    }

    final groupedByTracker = groupConditionsByTracker();

    final trackers = <SpendTracker>[];

    for (final entry in groupedByTracker.entries) {
      final conditions = entry.value;

      final byId = {for (final c in conditions) c.conditionId: c};
      final rootId = conditions.singleWhere((c) => c.parentId == null).conditionId;
      final childrenMap = <String, List<String>>{};
      for (final condition in conditions.where((c) => c.parentId != null)) {
        childrenMap.putIfAbsent(condition.parentId!, () => []).add(condition.conditionId);
      }

      TransactionCondition buildConditionTree({
        required String rootId,
        required Map<String, SpendTrackerConditionFromBackend> byId,
        required Map<String, List<String>> childrenMap,
      }) {
        final root = byId[rootId]!;
        final type = ConditionType.values.firstWhere((e) => e.name == root.conditionType);

        if (childrenMap.containsKey(rootId)) {
          final children = childrenMap[rootId]!;
          final subConditions = children
              .map((id) => buildConditionTree(rootId: id, byId: byId, childrenMap: childrenMap))
              .toList();

          return switch (type) {
            ConditionType.and => And(subConditions),
            ConditionType.or => Or(subConditions),
            _ => throw UnimplementedError('Unsupported nested condition type: $type'),
          };
        } else {
          final testType = root.testType != null
              ? TransactionTestType.values.firstWhere((e) => e.name == root.testType!)
              : null;

          final test = switch (testType) {
            TransactionTestType.hasFlagColor => HasFlagColor(root.testValue!),
            TransactionTestType.hasPayeeId => HasPayeeId(root.testValue!),
            TransactionTestType.hasCategoryId => HasCategoryId(root.testValue!),
            TransactionTestType.hasCategoryGroupId => HasCategoryGroupId(root.testValue!),
            TransactionTestType.hasAccountId => HasAccountId(root.testValue!),
            TransactionTestType.hasMemoKeyword => HasMemoKeyword(root.testValue!),
            TransactionTestType.isIncome => const IsIncome(),
            TransactionTestType.isInflow => const IsInflow(),
            TransactionTestType.isExpense => const IsExpense(),
            TransactionTestType.isOutflow => const IsOutflow(),
            null => throw UnimplementedError('Missing testType for leaf condition'),
          };

          return switch (type) {
            ConditionType.isTrue => IsTrue(test),
            ConditionType.isNotTrue => IsNotTrue(test),
            _ => throw UnimplementedError('Unsupported leaf condition type: $type'),
          };
        }
      }

      final conditionTree = buildConditionTree(
        rootId: rootId,
        byId: byId,
        childrenMap: childrenMap,
      );

      final sampleRow = conditions.first;
      trackers.add(
        SpendTracker(
          id: sampleRow.spendTrackerId,
          budgetId: sampleRow.budgetId,
          name: sampleRow.spendTrackerName,
          createdAt: sampleRow.spendTrackerCreatedAt,
          nickname: sampleRow.spendTrackerNickname,
          condition: conditionTree,
        ),
      );
    }

    return trackers;
  }
}
