import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/spend_trackers_repository.dart';

class DeleteSpendTracker {
  DeleteSpendTracker({required SpendTrackersRepository spendTrackersRepository})
    : _spendTrackersRepository = spendTrackersRepository;

  factory DeleteSpendTracker.create() {
    return DeleteSpendTracker(spendTrackersRepository: inject());
  }

  final SpendTrackersRepository _spendTrackersRepository;

  Future<Result<void, Exception>> call(String spendTrackerId) async {
    final result = await _spendTrackersRepository.deleteSpendTracker(spendTrackerId);

    if (result.isOk()) {
      await _spendTrackersRepository.refresh();
    }

    return result;
  }
}
