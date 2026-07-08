import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../persistence/drift/local_database.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../../category_views/domain/use_cases/insert_category_view.dart';
import '../../../../frugal_month/domain/use_cases/insert_frugal_month.dart';
import '../../../../spend_tracker/domain/use_cases/insert_spend_tracker.dart';
import '../../../../templates/domain/models/transaction_template_draft.dart';
import '../../../../templates/domain/use_cases/insert_template.dart';
import '../../../domain/use_cases/delete_all_synced_data.dart';
import '../../../domain/use_cases/watch_has_synced_data.dart';
import 'sync_screen_state.dart';

class SyncScreenCubit extends Cubit<SyncScreenState> {
  SyncScreenCubit({
    required LocalDatabase database,
    required Settings settings,
    required InsertCategoryView insertCategoryView,
    required InsertSpendTracker insertSpendTracker,
    required InsertFrugalMonth insertFrugalMonth,
    required InsertTransactionTemplate insertTransactionTemplate,
    required WatchHasSyncedData watchHasSyncedData,
    required DeleteAllSyncedData deleteAllSyncedData,
  }) : _localDatabase = database,
       _settings = settings,
       _insertCategoryView = insertCategoryView,
       _insertSpendTracker = insertSpendTracker,
       _insertFrugalMonth = insertFrugalMonth,
       _insertTransactionTemplate = insertTransactionTemplate,
       _watchHasSyncedData = watchHasSyncedData,
       _deleteAllSyncedData = deleteAllSyncedData,

       super(SyncScreenState.initial()) {
    unawaited(_observeUser());
  }

  factory SyncScreenCubit.create() {
    return SyncScreenCubit(
      database: inject(),
      settings: inject(),
      insertCategoryView: InsertCategoryView.create(),
      insertSpendTracker: InsertSpendTracker.create(),
      insertFrugalMonth: InsertFrugalMonth.create(),
      insertTransactionTemplate: InsertTransactionTemplate.create(),
      watchHasSyncedData: WatchHasSyncedData.create(),
      deleteAllSyncedData: DeleteAllSyncedData.create(),
    );
  }

  final LocalDatabase _localDatabase;
  final Settings _settings;
  final InsertCategoryView _insertCategoryView;
  final InsertSpendTracker _insertSpendTracker;
  final InsertFrugalMonth _insertFrugalMonth;
  final InsertTransactionTemplate _insertTransactionTemplate;
  final WatchHasSyncedData _watchHasSyncedData;
  final DeleteAllSyncedData _deleteAllSyncedData;
  final _subs = CompositeSubscription();

  Future<void> _observeUser() async {
    final categoryViews = await _localDatabase.fetchAllCategoryViews();
    final frugalMonths = await _localDatabase.fetchAllFrugalMonths();
    final spendTrackers = await _localDatabase.fetchAllQueriedSpendTrackers();
    final transactionTemplates = await _settings.fetchAllTransactionTemplates();

    final sub = _watchHasSyncedData()
        .map((hasSyncedData) {
          return state.copyWith(
            hasSyncedData: hasSyncedData,
            categoryViews: categoryViews,
            frugalMonths: frugalMonths,
            spendTrackers: spendTrackers,
            transactionTemplates: transactionTemplates,
          );
        })
        .listen(safeEmit);
    _subs.add(sub);
  }

  Future<void> skipSync() async {
    final result = await Result.asyncOf(() async {
      // Delete all local data
      for (final view in state.categoryViews) {
        await _localDatabase.deleteCategoryView(view.id);
      }
      for (final month in state.frugalMonths) {
        await _localDatabase.deleteFrugalMonth(month.id);
      }
      for (final tracker in state.spendTrackers) {
        await _localDatabase.deleteSpendTracker(tracker.id);
      }
      for (final template in state.transactionTemplates) {
        await _settings.deleteTransactionTemplate(template.id);
      }
    });
    final newState = result.when(
      ok: (_) {
        return state.copyWith(isComplete: true);
      },
      err: (error) {
        return state.copyWith(
          isComplete: true,
          errors: [if (error is Exception) error else Exception('Unknown error occurred')],
        );
      },
    );

    safeEmit(newState);
  }

  Future<void> startSync({required bool deleteExistingData}) async {
    if (state.isComplete) {
      return;
    }

    final result = await Result.asyncOf(() async {
      if (state.hasSyncedData && deleteExistingData) {
        await _deleteAllSyncedData();
      }

      safeEmit(state.copyWith(categoryViewsSync: SyncStatus.syncing));

      for (final view in state.categoryViews) {
        final result = await _insertCategoryView(
          name: view.name,
          budgetId: view.budgetId,
          categoryIds: view.categoryIds,
          categoryGroupIds: view.categoryGroupIds,
        );
        await result.whenAsync(
          ok: (_) async {
            await _localDatabase.deleteCategoryView(view.id);
          },
          err: (error) async {
            safeEmit(state.copyWith(categoryViewErrors: [...state.categoryViewErrors, error]));
          },
        );
      }

      safeEmit(
        state.copyWith(
          categoryViewsSync: state.categoryViewErrors.isEmpty
              ? SyncStatus.synced
              : SyncStatus.failedSync,
        ),
      );

      safeEmit(state.copyWith(frugalMonthsSync: SyncStatus.syncing));

      for (final month in state.frugalMonths) {
        final result = await _insertFrugalMonth(
          budgetId: month.budgetId,
          targetAmount: month.targetAmount,
          month: month.month,
          categoryIds: month.categoryIds,
          accountIds: month.accountIds,
        );

        await result.whenAsync(
          ok: (_) async {
            await _localDatabase.deleteFrugalMonth(month.id);
          },
          err: (error) async {
            safeEmit(state.copyWith(frugalMonthErrors: [...state.frugalMonthErrors, error]));
          },
        );
      }

      safeEmit(
        state.copyWith(
          frugalMonthsSync: state.frugalMonthErrors.isEmpty
              ? SyncStatus.synced
              : SyncStatus.failedSync,
        ),
      );

      safeEmit(state.copyWith(spendTrackersSync: SyncStatus.syncing));

      final now = DateTime.now();

      for (final tracker in state.spendTrackers) {
        final result = await _insertSpendTracker(
          name: tracker.name,
          budgetId: tracker.budgetId,
          condition: tracker.condition,
          nickName: tracker.nickName,
          // This is done to ensure that the user can still sort by creation date
          // in the app, even if the spend tracker was created before the sync.
          // This is only for migration purposes.
          createdAt: now.add(Duration(minutes: tracker.id)),
        );

        await result.whenAsync(
          ok: (_) async {
            await _localDatabase.deleteSpendTracker(tracker.id);
          },
          err: (error) async {
            safeEmit(state.copyWith(spendTrackerErrors: [...state.spendTrackerErrors, error]));
          },
        );
      }

      safeEmit(
        state.copyWith(
          spendTrackersSync: state.spendTrackerErrors.isEmpty
              ? SyncStatus.synced
              : SyncStatus.failedSync,
        ),
      );

      safeEmit(state.copyWith(transactionTemplatesSync: SyncStatus.syncing));

      for (final template in state.transactionTemplates) {
        final result = await _insertTransactionTemplate(
          budgetId: template.budgetId,
          draft: TransactionTemplateDraft(
            name: template.name,
            payeeId: template.payeeId,
            categoryId: template.categoryId,
            accountId: template.accountId,
            amount: template.amount,
            memo: template.memo,
            flag: template.flag,
            fireImmediately: template.fireImmediately,
            subTransactions: template.subTransactions,
          ),
        );

        await result.whenAsync(
          ok: (_) async {
            await _settings.deleteTransactionTemplate(template.id);
          },
          err: (error) async {
            safeEmit(
              state.copyWith(
                transactionTemplateErrors: [...state.transactionTemplateErrors, error],
              ),
            );
          },
        );
      }

      safeEmit(
        state.copyWith(
          transactionTemplatesSync: state.transactionTemplateErrors.isEmpty
              ? SyncStatus.synced
              : SyncStatus.failedSync,
        ),
      );

      safeEmit(state.copyWith(isComplete: true));
    });

    final newState = result.when(
      ok: (_) {
        return state.copyWith(isComplete: true);
      },
      err: (error) {
        return state.copyWith(
          categoryViewsSync: SyncStatus.notSynced,
          frugalMonthsSync: SyncStatus.notSynced,
          spendTrackersSync: SyncStatus.notSynced,
          transactionTemplatesSync: SyncStatus.notSynced,
          isComplete: true,
          errors: [
            ...state.categoryViewErrors,
            ...state.frugalMonthErrors,
            ...state.spendTrackerErrors,
            ...state.transactionTemplateErrors,
            if (error is Exception) error else Exception('Unknown error occurred'),
          ],
        );
      },
    );

    safeEmit(newState);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
