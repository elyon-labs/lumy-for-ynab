import 'package:dart_mappable/dart_mappable.dart';

import '../../../../../persistence/drift/local_database.dart';
import '../../../../category_views/domain/models/legacy_category_view.dart';
import '../../../../templates/domain/models/transaction_template.dart';

part 'sync_screen_state.mapper.dart';

@MappableClass()
class SyncScreenState with SyncScreenStateMappable {
  SyncScreenState({
    required this.hasSyncedData,
    required this.categoryViews,
    required this.categoryViewErrors,
    required this.categoryViewsSync,
    required this.frugalMonths,
    required this.frugalMonthErrors,
    required this.frugalMonthsSync,
    required this.spendTrackers,
    required this.spendTrackerErrors,
    required this.spendTrackersSync,
    required this.transactionTemplates,
    required this.transactionTemplateErrors,
    required this.transactionTemplatesSync,
    required this.isComplete,
    required this.errors,
  });

  factory SyncScreenState.initial() {
    return SyncScreenState(
      hasSyncedData: false,
      categoryViews: [],
      categoryViewErrors: [],
      categoryViewsSync: SyncStatus.notSynced,
      frugalMonths: [],
      frugalMonthErrors: [],
      frugalMonthsSync: SyncStatus.notSynced,
      spendTrackers: [],
      spendTrackerErrors: [],
      spendTrackersSync: SyncStatus.notSynced,
      transactionTemplates: [],
      transactionTemplateErrors: [],
      transactionTemplatesSync: SyncStatus.notSynced,
      isComplete: false,
      errors: [],
    );
  }

  final bool hasSyncedData;
  final List<LegacyCategoryView> categoryViews;
  final List<Exception> categoryViewErrors;
  final SyncStatus categoryViewsSync;
  final List<LegacyFrugalMonth> frugalMonths;
  final List<Exception> frugalMonthErrors;
  final SyncStatus frugalMonthsSync;
  final List<LegacySpendTracker> spendTrackers;
  final List<Exception> spendTrackerErrors;
  final SyncStatus spendTrackersSync;
  final List<TransactionTemplate> transactionTemplates;
  final List<Exception> transactionTemplateErrors;
  final SyncStatus transactionTemplatesSync;
  final bool isComplete;
  final List<Exception> errors;

  bool get isSyncing =>
      switch ((categoryViewsSync, frugalMonthsSync, spendTrackersSync, transactionTemplatesSync)) {
        (SyncStatus.syncing, _, _, _) => true,
        (_, SyncStatus.syncing, _, _) => true,
        (_, _, SyncStatus.syncing, _) => true,
        (_, _, _, SyncStatus.syncing) => true,
        _ => false,
      };
}

enum SyncStatus { notSynced, syncing, synced, failedSync }
