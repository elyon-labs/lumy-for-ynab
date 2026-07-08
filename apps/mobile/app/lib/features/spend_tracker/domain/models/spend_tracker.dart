import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'transaction_conditions.dart';

part 'spend_tracker.mapper.dart';

enum SpendTrackerType { category, categoryGroup, memo, payee, flag }

@MappableClass(includeCustomMappers: [TransactionConditionSimpleMapper()])
class SpendTracker with EquatableMixin, SpendTrackerMappable {
  SpendTracker({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.condition,
    required this.createdAt,
    this.nickname,
  });

  final String id;
  final String budgetId;
  final String name;
  final DateTime createdAt;
  final String? nickname;

  final TransactionCondition condition;

  @override
  List<Object?> get props => [id, budgetId, name, nickname, condition];
}

extension SpendTrackerTypeX on SpendTracker {
  /// If a user has given a nickname to a tracker, use that instead of the name
  String get preferredName => nickname ?? name;

  bool get isAdvanced => condition is NestedCondition;
}

extension ListSpendTrackerX on List<SpendTracker> {
  Iterable<SpendTracker> orderByPreference(List<String> ids) sync* {
    for (final id in ids) {
      // Previously sorted trackers are yielded first
      final tracker = singleWhereOrNull((c) => c.id == id);
      if (tracker != null) yield tracker;
    }
    for (final tracker in this) {
      // Trackers not yet sorted are added last
      if (!ids.contains(tracker.id)) yield tracker;
    }
  }

  Iterable<SpendTracker> orderAlphabetically() {
    return sortedByCompare((t) => t.preferredName, (a, b) {
      // Strip any non-alphanumeric characters from the name
      final regex = RegExp('[^a-zA-Z0-9]');
      final aName = a.replaceAll(regex, '').toLowerCase();
      final bName = b.replaceAll(regex, '').toLowerCase();
      return aName.compareTo(bName);
    });
  }

  Iterable<String> get ids => map((e) => e.id);
}
