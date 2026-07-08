import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../category_views/data/repositories/category_views_repository.dart';
import '../../../frugal_month/data/repositories/frugal_months_repository.dart';
import '../../../spend_tracker/data/repositories/spend_trackers_repository.dart';
import '../../../templates/data/repositories/transaction_templates_repository.dart';

class WatchHasSyncedData {
  WatchHasSyncedData({
    required TransactionTemplatesRepository transactionTemplatesRepository,
    required SpendTrackersRepository spendTrackersRepository,
    required CategoryViewsRepository categoryViewsRepository,
    required FrugalMonthsRepository frugalMonthsRepository,
  }) : _transactionTemplatesRepository = transactionTemplatesRepository,
       _spendTrackersRepository = spendTrackersRepository,
       _categoryViewsRepository = categoryViewsRepository,
       _frugalMonthsRepository = frugalMonthsRepository;

  factory WatchHasSyncedData.create() {
    return WatchHasSyncedData(
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

  Stream<bool> call() {
    return Rx.combineLatest4(
      _transactionTemplatesRepository.watch,
      _spendTrackersRepository.watch,
      _categoryViewsRepository.watch,
      _frugalMonthsRepository.watch,
      (templates, spendTrackers, categoryViews, frugalMonths) =>
          templates.isNotEmpty ||
          spendTrackers.isNotEmpty ||
          categoryViews.isNotEmpty ||
          frugalMonths.isNotEmpty,
    );
  }
}
