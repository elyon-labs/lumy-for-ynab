import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import '../../../../external/flow.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../app_review/app_review_service.dart';
import '../../../notifications/notifications.dart';
import '../../domain/models/frugal_month.dart';
import '../../domain/models/frugal_month_draft.dart';
import '../../domain/use_cases/insert_frugal_month.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';
import '../notifications/frugal_month_notifications.dart';
import '../screens/available_months_loading_screen.dart';
import '../screens/choose_frugal_month_accounts_screen.dart';
import '../screens/choose_frugal_month_categories_screen.dart';
import '../screens/choose_frugal_month_screen.dart';
import '../screens/frugal_month_details_screen.dart';
import '../screens/frugal_month_error_screen.dart';
import '../screens/request_frugal_month_notifications_screen.dart';
import '../screens/set_frugal_month_limit_screen.dart';

part 'create_frugal_month_flow.mapper.dart';

@MappableClass()
class CreateFrugalMonthState extends FlowState with CreateFrugalMonthStateMappable {
  CreateFrugalMonthState({
    required this.draft,
    required super.route,
    required this.availableMonths,
    required this.frugalMonthId,
    required this.isFrugalMonthNotificationsEnabled,
  });

  factory CreateFrugalMonthState.initial() {
    return CreateFrugalMonthState(
      draft: FrugalMonthDraft(),
      route: AvailableMonthsLoadingScreen.route,
      availableMonths: const Loading(),
      frugalMonthId: const Loading(),
      isFrugalMonthNotificationsEnabled: false,
    );
  }

  final FrugalMonthDraft draft;
  final Async<List<LocalDate>> availableMonths;
  final Async<String> frugalMonthId;
  final bool isFrugalMonthNotificationsEnabled;
}

class CreateFrugalMonthFlow extends FlowManager<CreateFrugalMonthState, CreateFrugalMonthStep> {
  CreateFrugalMonthFlow({
    required Settings settings,
    required InsertFrugalMonth insertFrugalMonth,
    required WatchFrugalMonthData watchFrugalMonthData,
    required FrugalMonthNotificationsHandler frugalMonthNotificationHandler,
    required Future<bool> Function() hasNotificationPermissions,
    required AppReviewService appReviewService,
  }) : _appReviewService = appReviewService,
       _hasNotificationPermissions = hasNotificationPermissions,
       _frugalMonthNotificationHandler = frugalMonthNotificationHandler,
       _settings = settings,
       _insertFrugalMonth = insertFrugalMonth,
       _watchFrugalMonthData = watchFrugalMonthData,
       super(CreateFrugalMonthState.initial()) {
    _init();
  }

  factory CreateFrugalMonthFlow.create() {
    return CreateFrugalMonthFlow(
      settings: inject(),
      insertFrugalMonth: InsertFrugalMonth.create(),
      watchFrugalMonthData: WatchFrugalMonthData.create(),
      frugalMonthNotificationHandler: inject(),
      hasNotificationPermissions: inject<FlutterLocalNotificationsPlugin>().hasPermission,
      appReviewService: inject(),
    );
  }

  final Settings _settings;
  final InsertFrugalMonth _insertFrugalMonth;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final FrugalMonthNotificationsHandler _frugalMonthNotificationHandler;
  final HasNotificationPermissions _hasNotificationPermissions;
  final AppReviewService _appReviewService;
  final subs = CompositeSubscription();

  void _init() {
    final sub = _settings.watchFrugalMonthNotificationsEnabled().listen((enabled) {
      safeEmit(state.copyWith(isFrugalMonthNotificationsEnabled: enabled));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }

  bool get _hasMonthChoice => state.availableMonths.valueOr([]).length > 1;

  @override
  Future<void> stepComplete(CreateFrugalMonthStep step) async {
    switch (step) {
      case FetchAvailableMonthsStep(:final availableMonths):
        final route = switch (availableMonths.length) {
          <= 1 => ChooseFrugalMonthCategoriesScreen.buildRoute(false),
          _ => ChooseFrugalMonthScreen.route,
        };
        final draft = switch (availableMonths.length) {
          <= 1 => state.draft.setMonth(availableMonths.single),
          _ => state.draft,
        };
        safeEmit(
          state.copyWith(route: route, availableMonths: Loaded(availableMonths), draft: draft),
        );
      case ChooseMonthStep(:final selectedMonth):
        safeEmit(
          state.copyWith(
            route: ChooseFrugalMonthCategoriesScreen.buildRoute(_hasMonthChoice),
            draft: state.draft.setMonth(selectedMonth),
          ),
        );
      case ChooseCategoriesStep(:final selectedCategories):
        safeEmit(
          state.copyWith(
            route: ChooseFrugalMonthAccountsScreen.buildRoute(_hasMonthChoice),
            draft: state.draft.setCategoryIds(selectedCategories),
          ),
        );
      case ChooseAccountsStep(:final selectedAccounts):
        safeEmit(
          state.copyWith(
            route: SetFrugalMonthLimitScreen.buildRoute(afterMonthChoice: _hasMonthChoice),
            draft: state.draft.setAccountIds(selectedAccounts),
          ),
        );
      case SetLimitStep(:final limit):
        final draft = state.draft.setLimit(limit);
        if (!draft.isValid) {
          safeEmit(state.copyWith(route: FrugalMonthErrorScreen.route));
        } else {
          final budgetId = await _settings.watchSelectedBudgetId().nextValue();
          final result = await _insertFrugalMonth(
            budgetId: budgetId.unwrap(),
            month: draft.month!,
            targetAmount: draft.targetAmount!,
            categoryIds: draft.categoryIds!,
            accountIds: draft.accountIds!,
          );
          switch (result) {
            case Ok<String, Exception>(:final value):
              final fMonth = FrugalMonth(
                id: value,
                month: draft.month!,
                budgetId: budgetId.unwrap(),
                targetAmount: draft.targetAmount!,
                categoryIds: draft.categoryIds!,
                accountIds: draft.accountIds!,
              );
              // Emit the new frugal month ID
              safeEmit(state.copyWith(frugalMonthId: Loaded(fMonth.id)));
              if (!state.isFrugalMonthNotificationsEnabled) {
                // The user has explicitly disabled notifications, so don't handle them,
                // just navigate to the frugal month details screen

                unawaited(_appReviewService.onEvent());
                safeEmit(
                  state.copyWith(route: FrugalMonthDetailsScreen.buildBudgetTabRoute(fMonth.id)),
                );
              } else {
                if (!await _hasNotificationPermissions()) {
                  safeEmit(state.copyWith(route: RequestFrugalMonthNotificationsScreen.route));
                } else {
                  // We already have permission, so act as if the user has granted it
                  return stepComplete(const RequestNotificationsStep(canNotify: true));
                }
              }
            case Err<String, Exception>(:final error):
              safeEmit(
                state.copyWith(route: FrugalMonthErrorScreen.route, frugalMonthId: Error(error)),
              );
          }
        }
      case RequestNotificationsStep(:final canNotify):
        // We should never get here if the frugal month has not yet been created
        final fMonthId = state.frugalMonthId.unwrap();
        if (canNotify) {
          final fMonthData = await _watchFrugalMonthData(fMonthId).nextValue();
          await _frugalMonthNotificationHandler.scheduleNewFrugalMonthNotifications(
            fMonth: fMonthData.month,
          );
        }
        safeEmit(state.copyWith(route: FrugalMonthDetailsScreen.buildBudgetTabRoute(fMonthId)));
    }
  }
}

sealed class CreateFrugalMonthStep {
  const CreateFrugalMonthStep();
}

/// A step for determining what months are available for the user
/// to create a frugal month for.
class FetchAvailableMonthsStep extends CreateFrugalMonthStep {
  const FetchAvailableMonthsStep({required this.availableMonths});

  final List<LocalDate> availableMonths;
}

/// A step for choosing a month to create a frugal month for.
class ChooseMonthStep extends CreateFrugalMonthStep {
  const ChooseMonthStep({required this.selectedMonth});

  final LocalDate selectedMonth;
}

class ChooseCategoriesStep extends CreateFrugalMonthStep {
  const ChooseCategoriesStep({required this.selectedCategories});

  final List<String> selectedCategories;
}

class ChooseAccountsStep extends CreateFrugalMonthStep {
  const ChooseAccountsStep({required this.selectedAccounts});

  final List<String> selectedAccounts;
}

class SetLimitStep extends CreateFrugalMonthStep {
  const SetLimitStep({required this.limit});

  final int limit;
}

class RequestNotificationsStep extends CreateFrugalMonthStep {
  const RequestNotificationsStep({required this.canNotify});

  final bool canNotify;
}
