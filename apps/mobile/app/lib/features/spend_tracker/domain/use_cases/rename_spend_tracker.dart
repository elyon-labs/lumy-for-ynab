import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/spend_trackers_repository.dart';

class RenameSpendTracker {
  RenameSpendTracker({required SpendTrackersRepository spendTrackersRepository})
    : _spendTrackersRepository = spendTrackersRepository;

  factory RenameSpendTracker.create() {
    return RenameSpendTracker(spendTrackersRepository: inject());
  }

  final SpendTrackersRepository _spendTrackersRepository;

  Future<Result<void, Exception>> call(String spendTrackerId, {required String name}) async {
    final result = await _spendTrackersRepository.renameSpendTracker(spendTrackerId, name: name);

    if (result.isOk()) {
      await _spendTrackersRepository.refresh();
    }

    return result;
  }
}
