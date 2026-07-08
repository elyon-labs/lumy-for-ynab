import 'package:oxidized/oxidized.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import '../../data/repositories/frugal_months_repository.dart';

class InsertFrugalMonth {
  InsertFrugalMonth({required FrugalMonthsRepository frugalMonthsRepository})
    : _frugalMonthsRepository = frugalMonthsRepository;

  factory InsertFrugalMonth.create() {
    return InsertFrugalMonth(frugalMonthsRepository: inject());
  }

  final FrugalMonthsRepository _frugalMonthsRepository;

  Future<Result<String, Exception>> call({
    required String budgetId,
    required LocalDate month,
    required int targetAmount,
    required List<String> categoryIds,
    required List<String> accountIds,
  }) async {
    final result = await _frugalMonthsRepository.insertFrugalMonth(
      budgetId: budgetId,
      month: month,
      targetAmount: targetAmount,
      categoryIds: categoryIds,
      accountIds: accountIds,
    );

    if (result.isOk()) {
      await _frugalMonthsRepository.refresh();
    }

    return result;
  }
}
