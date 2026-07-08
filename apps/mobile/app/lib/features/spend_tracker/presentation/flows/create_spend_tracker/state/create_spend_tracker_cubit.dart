import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../app/di.dart';
import '../../../../../../persistence/settings.dart';
import '../../../../../../utils/_cubit.dart';
import '../../../../../app_review/app_review_service.dart';
import '../../../../../home/presentation/screens/reports_tab/presentation/screens/reports_choose_spend_tracker_type_screen.dart';
import '../../../../domain/models/spend_tracker_draft.dart';
import '../../../../domain/models/transaction_conditions.dart';
import '../../../../domain/use_cases/insert_spend_tracker.dart';

class CreateSpendTrackerState {
  CreateSpendTrackerState({required this.draft});

  factory CreateSpendTrackerState.initial() {
    return CreateSpendTrackerState(draft: SpendTrackerDraft());
  }

  final SpendTrackerDraft draft;
}

class CreateSpendTrackerCubit extends Cubit<CreateSpendTrackerState> {
  CreateSpendTrackerCubit({
    required Settings settings,
    required InsertSpendTracker insertSpendTracker,
    required AppReviewService appReviewService,
  }) : _appReviewService = appReviewService,
       _settings = settings,
       _insertSpendTracker = insertSpendTracker,
       super(CreateSpendTrackerState.initial());

  factory CreateSpendTrackerCubit.create() {
    return CreateSpendTrackerCubit(
      insertSpendTracker: InsertSpendTracker.create(),
      settings: inject(),
      appReviewService: inject(),
    );
  }

  final Settings _settings;
  final InsertSpendTracker _insertSpendTracker;
  final AppReviewService _appReviewService;

  void setName(String name) {
    safeEmit(CreateSpendTrackerState(draft: state.draft.setName(name)));
  }

  void setCondition(TransactionCondition condition) {
    safeEmit(CreateSpendTrackerState(draft: state.draft.setCondition(condition)));
  }

  void setType(SpendTrackerTypeChoice type) {
    safeEmit(CreateSpendTrackerState(draft: state.draft.setType(type)));
  }

  void resetDraft() {
    safeEmit(CreateSpendTrackerState(draft: SpendTrackerDraft()));
  }

  String initializeFlow() {
    resetDraft();
    return ReportsChooseSpendTrackerTypeScreen.route;
  }

  Future<Result<String, Exception>> save() async {
    final draft = state.draft;
    if (draft.name == null || draft.type == null || draft.condition == null) {
      return Err(
        Exception(
          'Name, type and condition must be set to save spend tracker. Name was '
          'set to ${draft.name}, type was set to ${draft.type}, and condition was set to ${draft.condition}.',
        ),
      );
    }

    final budgetId = await _settings.watchSelectedBudgetId().nextValue();

    final result = await _insertSpendTracker(
      condition: draft.condition!,
      name: draft.name!,
      budgetId: budgetId.unwrap(),
    );

    if (result.isOk()) {
      unawaited(_appReviewService.onEvent());
    }

    return result;
  }
}
