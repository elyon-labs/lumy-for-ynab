import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/frugal_months_repository.dart';

class DeleteFrugalMonth {
  DeleteFrugalMonth({required FrugalMonthsRepository repository}) : _repository = repository;

  factory DeleteFrugalMonth.create() {
    return DeleteFrugalMonth(repository: inject());
  }

  final FrugalMonthsRepository _repository;

  Future<Result<void, Exception>> call(String frugalMonthId) async {
    final result = await _repository.deleteFrugalMonth(frugalMonthId);
    if (result.isOk()) {
      await _repository.refresh();
    }
    return result;
  }
}
