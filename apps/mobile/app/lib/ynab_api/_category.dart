import 'package:collection/collection.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../common/domain/transactions/filters.dart';
import '../common/domain/worker/_base_transactions_async.dart';
import '../utils/_date_time.dart';
import '../utils/_local_date.dart';

extension IterableCategoryX on Iterable<Category> {
  Iterable<Category> whereNotDeleted() {
    return whereNot((c) => c.isDeleted);
  }

  Iterable<Category> whereForCategoryGroup(String groupId) {
    return where((c) => c.categoryGroupId == groupId);
  }

  Iterable<Category> select(Iterable<String> ids) {
    return where((c) => ids.contains(c.id));
  }

  Category byId(String id) => firstWhere((c) => c.id == id);

  List<String> get ids => map((c) => c.id).toList();

  Map<String, Category> toMap() {
    return Map.fromEntries(map((e) => MapEntry(e.id, e)));
  }
}

extension CategoryX on Category {
  bool get isReadyToAssign => name == 'Inflow: Ready to Assign';

  int get initialBalance {
    final initial = balance - activity;
    // In cases where the current balance is greater than our initial balance,
    // inflow must have occurred. Use the current balance as the initial balance.
    return balance > initial ? balance : initial;
  }

  double get remainingPercent {
    if (budgeted == 0 && activity == 0) {
      return 1;
    }
    if (balance <= 0 || initialBalance <= 0) {
      return 0;
    }
    return balance / initialBalance;
  }

  bool get isOverspent => balance.isNegative;

  /// `0` indicates no cadence, and anything greater means either weekly,
  /// monthly, yearly, or every 2 years.
  bool get hasRecurringTarget => targetType != null && targetCadence != null && targetCadence! > 0;

  LocalDate? get targetMonthDate {
    if (targetMonth == null) return null;
    final parsed = cachedDateTimes.putIfAbsent(id, () => DateTime.parse(targetMonth!).toLocal());
    return parsed.toLocalDate();
  }

  LocalDate? get targetCreationMonthDate {
    if (targetCreationMonth == null) return null;
    final parsed = cachedDateTimes.putIfAbsent(
      id,
      () => DateTime.parse(targetCreationMonth!).toLocal(),
    );
    return parsed.toLocalDate();
  }

  /// Returns the number of months in the target cadence, if this [Category] has
  /// a target set with a non-null cadence.
  int? get monthsInTargetCadence {
    int? forTargetBalanceByDate() {
      if (targetCreationMonthDate == null || targetMonthDate == null) {
        return null;
      }
      final days = targetMonthDate!.subtractInternal(targetCreationMonthDate!).inDays;
      // Convert to months and round up.
      return (days / 30.44).ceil();
    }

    int? forMonthlyFunding() {
      return targetBalance == null ? null : 1;
    }

    int? forNeeded() {
      if (targetCadence == null || targetBalance == null) return null;

      if (targetCadence! == 1) {
        // Monthly
        return targetCadenceFrequency ?? 1;
      }

      if (targetCadence! == 2) {
        // Weekly
        if (targetCadenceFrequency == null) {
          return null;
        }
        // Due every `targetCadenceFrequency` weeks.
        final amount = ((1 / 4.35) * targetCadenceFrequency!).ceil();
        return amount <= 1 ? null : amount;
      }

      if (targetCadence! == 13) {
        // Yearly
        return (targetCadenceFrequency ?? 1) * 12;
      }

      if (targetCadence! == 14) {
        // Every 2 years
        return (targetCadenceFrequency ?? 1) * 24;
      }

      return null;
    }

    return switch (targetType) {
      TargetType.TBD => forTargetBalanceByDate(),
      TargetType.MF => forMonthlyFunding(),
      TargetType.NEED => forNeeded(),
      // DEBT seems to act like `NEED` but is not documented by the API.
      TargetType.DEBT => forNeeded(),
      // TB (Target Balance) doesn't make sense in the context of a monthly
      // funding amount as there is no target date.
      TargetType.TB => null,
      null => null,
    };
  }

  int? get monthlyNeededForTarget {
    int? forTargetBalanceByDate() {
      if (targetCreationMonthDate == null || targetMonthDate == null) {
        return null;
      }
      final days = targetMonthDate!.subtractInternal(targetCreationMonthDate!).inDays;
      // Convert to months and round up.
      final months = (days / 30.44).ceil();
      return targetBalance! ~/ months;
    }

    int? forMonthlyFunding() {
      // The category is funded monthly, so the `targetBalance` is the amount
      // needed to fund the category for the month.
      return targetBalance ?? 0;
    }

    int? forNeeded() {
      if (targetCadence == null || targetBalance == null) return null;
      if (targetCadence! >= 3 && targetCadence! <= 12) {
        // No frequency, repeats every `targetCadence` months.
        return targetBalance! ~/ targetCadence!;
      }

      if (targetCadence! == 1) {
        // Monthly
        if (targetCadenceFrequency == null) {
          return targetBalance;
        }
        // Due every `targetCadenceFrequency` months.
        return targetBalance! ~/ targetCadenceFrequency!;
      }

      if (targetCadence! == 2) {
        // Weekly
        if (targetCadenceFrequency == null) {
          return (targetBalance! * 4.35).ceil();
        }
        // Due every `targetCadenceFrequency` weeks.
        return ((targetBalance! ~/ targetCadenceFrequency!) * 4.35).ceil();
      }

      if (targetCadence! == 13) {
        // Yearly
        if (targetCadenceFrequency == null) {
          return targetBalance! ~/ 12;
        }
        // Due every `targetCadenceFrequency` years.
        return (targetBalance! ~/ targetCadenceFrequency!) ~/ 12;
      }

      if (targetCadence! == 14) {
        // Every 2 years
        if (targetCadenceFrequency == null) {
          return targetBalance! ~/ 24;
        }
        // Due every `targetCadenceFrequency` * 2 years.
        final amountPerYear = targetBalance! ~/ (targetCadenceFrequency! * 2);
        return amountPerYear ~/ 12;
      }

      return null;
    }

    return switch (targetType) {
      TargetType.TBD => forTargetBalanceByDate(),
      TargetType.MF => forMonthlyFunding(),
      TargetType.NEED => forNeeded(),
      // DEBT seems to act like `NEED` but is not documented by the API.
      TargetType.DEBT => forNeeded(),
      // TB (Target Balance) doesn't make sense in the context of a monthly
      // funding amount as there is no target date.
      TargetType.TB => null,
      null => null,
    };
  }
}

extension MapCategoryX on Map<Category, Iterable<PastTransaction>> {
  Future<Map<Category, int>> spendByCategory() async {
    final out = <Category, int>{};
    for (final entry in entries) {
      final sum = await entry.value.sumAmountFiltered(isExpenseInCategory(entry.key));
      out[entry.key] = sum;
    }
    return out;
  }
}
