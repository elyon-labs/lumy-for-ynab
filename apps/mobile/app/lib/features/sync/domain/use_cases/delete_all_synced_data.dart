import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../category_views/data/repositories/category_views_repository.dart';
import '../../../frugal_month/data/repositories/frugal_months_repository.dart';
import '../../../spend_tracker/data/repositories/spend_trackers_repository.dart';
import '../../../templates/data/repositories/transaction_templates_repository.dart';

class DeleteAllSyncedData {
  DeleteAllSyncedData({
    required TransactionTemplatesRepository transactionTemplatesRepository,
    required SpendTrackersRepository spendTrackersRepository,
    required CategoryViewsRepository categoryViewsRepository,
    required FrugalMonthsRepository frugalMonthsRepository,
  }) : _transactionTemplatesRepository = transactionTemplatesRepository,
       _spendTrackersRepository = spendTrackersRepository,
       _categoryViewsRepository = categoryViewsRepository,
       _frugalMonthsRepository = frugalMonthsRepository;

  factory DeleteAllSyncedData.create() {
    return DeleteAllSyncedData(
      transactionTemplatesRepository: inject(),
      spendTrackersRepository: inject(),
      categoryViewsRepository: inject(),
      frugalMonthsRepository: inject(),
    );
  }

  final TransactionTemplatesRepository _transactionTemplatesRepository;
  final SpendTrackersRepository _spendTrackersRepository;
  final CategoryViewsRepository _categoryViewsRepository;
  final FrugalMonthsRepository _frugalMonthsRepository;

  Future<Result<void, Exception>> call() {
    return Result.asyncOf(() async {
      final templates = await _transactionTemplatesRepository.watch.first;
      final spendTrackers = await _spendTrackersRepository.watch.first;
      final categoryViews = await _categoryViewsRepository.watch.first;
      final frugalMonths = await _frugalMonthsRepository.watch.first;
      await Future.wait([
        ...templates.map((t) => _transactionTemplatesRepository.deleteTemplate(t.id)),
        ...spendTrackers.map((s) => _spendTrackersRepository.deleteSpendTracker(s.id)),
        ...categoryViews.map((c) => _categoryViewsRepository.deleteCategoryView(c.id)),
        ...frugalMonths.map((f) => _frugalMonthsRepository.deleteFrugalMonth(f.id)),
      ]);
    });
  }
}
