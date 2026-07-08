import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/spend_trackers_repository.dart';
import '../models/transaction_conditions.dart';

class UpdateSpendTracker {
  UpdateSpendTracker({required SpendTrackersRepository spendTrackersRepository})
    : _spendTrackersRepository = spendTrackersRepository;

  factory UpdateSpendTracker.create() {
    return UpdateSpendTracker(spendTrackersRepository: inject());
  }

  final SpendTrackersRepository _spendTrackersRepository;

  Future<Result<void, Exception>> call(
    String spendTrackerId, {
    required TransactionCondition condition,
  }) async {
    final result = await _spendTrackersRepository.updateSpendTracker(
      spendTrackerId,
      condition: condition,
    );

    if (result.isOk()) {
      await _spendTrackersRepository.refresh();
    }

    return result;
  }
}
