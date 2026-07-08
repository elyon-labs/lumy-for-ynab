import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lumy/features/frugal_month/data/repositories/frugal_months_repository.dart';
import 'package:lumy/features/frugal_month/domain/models/frugal_month.dart';
import 'package:oxidized/src/result.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_machine/src/localdate.dart';

class FakeFrugalMonthsRepository implements FrugalMonthsRepository {
  FakeFrugalMonthsRepository({this.onInsert});

  final VoidCallback? onInsert;
  final BehaviorSubject<List<FrugalMonth>> _subject = BehaviorSubject<List<FrugalMonth>>.seeded(
    <FrugalMonth>[],
  );

  @override
  Future<Result<void, Exception>> deleteFrugalMonth(String frugalMonthId) {
    _subject.add(_subject.value.where((fm) => fm.id != frugalMonthId).toList());
    return Future.value(const Ok(null));
  }

  @override
  Future<Result<String, Exception>> insertFrugalMonth({
    required String budgetId,
    required LocalDate month,
    required int targetAmount,
    required List<String> categoryIds,
    required List<String> accountIds,
  }) {
    onInsert?.call();
    final frugalMonth = FrugalMonth(
      id: 'fake-frugal-month-id',
      budgetId: budgetId,
      month: month,
      targetAmount: targetAmount,
      categoryIds: categoryIds,
      accountIds: accountIds,
    );
    _subject.add([..._subject.value, frugalMonth]);
    return Future.value(const Ok('fake-frugal-month-id'));
  }

  @override
  Future<void> refresh() {
    return Future.value();
  }

  @override
  Stream<List<FrugalMonth>> get watch => _subject.stream;

  @override
  Future<void> dispose() async {
    await _subject.close();
    return Future.value();
  }
}
