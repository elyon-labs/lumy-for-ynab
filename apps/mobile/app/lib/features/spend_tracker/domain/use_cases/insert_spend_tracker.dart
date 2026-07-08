import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/spend_trackers_repository.dart';
import '../models/transaction_conditions.dart';

class InsertSpendTracker {
  InsertSpendTracker({required SpendTrackersRepository spendTrackersRepository})
    : _spendTrackersRepository = spendTrackersRepository;

  factory InsertSpendTracker.create() {
    return InsertSpendTracker(spendTrackersRepository: inject());
  }

  final SpendTrackersRepository _spendTrackersRepository;

  Future<Result<String, Exception>> call({
    required String budgetId,
    required TransactionCondition condition,
    required String name,
    // Below are only for migration purposes
    String? nickName,
    DateTime? createdAt,
  }) async {
    final result = await _spendTrackersRepository.insertSpendTracker(
      budgetId: budgetId,
      condition: condition,
      name: name,
      nickName: nickName,
    );

    if (result.isOk()) {
      await _spendTrackersRepository.refresh();
    }

    return result;
  }
}
