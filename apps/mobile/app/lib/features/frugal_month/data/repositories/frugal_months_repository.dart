import 'dart:async';

import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import '../../../auth/data/api/auth_api.dart';
import '../../domain/models/frugal_month.dart';
import '../api/frugal_months_api.dart';
import '../api/models/frugal_month_from_backend.dart';

class FrugalMonthsRepository {
  FrugalMonthsRepository({required FrugalMonthsApi api, required AuthApi authApi})
    : _api = api,
      _authApi = authApi {
    unawaited(_fetchFrugalMonths());
    _subs.add(_authApi.onAuthenticated(refresh));
  }

  factory FrugalMonthsRepository.create() {
    return FrugalMonthsRepository(api: inject(), authApi: inject());
  }

  final FrugalMonthsApi _api;
  final AuthApi _authApi;

  final _subject = BehaviorSubject<List<FrugalMonth>>.seeded(<FrugalMonth>[]);
  final _subs = CompositeSubscription();

  Future<void> _fetchFrugalMonths() async {
    final frugalMonths = await _api.fetchFrugalMonths();
    _subject.add(frugalMonths.map((fm) => fm.toDomain()).toList());
  }

  Stream<List<FrugalMonth>> get watch => _subject.stream;

  Future<void> refresh() async {
    await _fetchFrugalMonths();
  }

  Future<Result<String, Exception>> insertFrugalMonth({
    required String budgetId,
    required LocalDate month,
    required int targetAmount,
    required List<String> categoryIds,
    required List<String> accountIds,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.insertFrugalMonth(
        userId: user.id,
        budgetId: budgetId,
        month: month,
        targetAmount: targetAmount,
        categoryIds: categoryIds,
        accountIds: accountIds,
      );
    });
  }

  Future<Result<void, Exception>> deleteFrugalMonth(String frugalMonthId) async {
    return _api.deleteFrugalMonth(frugalMonthId);
  }

  Future<void> dispose() async {
    await _subs.dispose();
  }
}

extension on JoinedFrugalMonthFromBackend {
  FrugalMonth toDomain() {
    return FrugalMonth(
      id: id,
      budgetId: budgetId,
      month: month,
      targetAmount: targetAmount,
      categoryIds: categoryIds,
      accountIds: accountIds,
    );
  }
}
