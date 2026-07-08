import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stack_trace/stack_trace.dart' as st;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_platform/universal_platform.dart';

import 'app/configure_mobile.dart' if (dart.library.html) 'app/configure_web.dart';
import 'app/di.dart';
import 'app/environment/environment.dart';
import 'app/error_reporting/error_reporter.dart';
import 'app/firebase/feature_flags/feature_flags_cubit.dart';
import 'app/firebase/feature_flags/initialize.dart';
import 'app/logging.dart';
import 'app/navigation/deep_link_handler.dart';
import 'app/navigation/router.dart';
import 'app/scaffold_messenger/scaffold_messenger.dart';
import 'common/domain/accounts/accounts_fetch_cubit.dart';
import 'common/domain/accounts/accounts_repository.dart';
import 'common/domain/budgets/budgets_fetch_cubit.dart';
import 'common/domain/budgets/budgets_repository.dart';
import 'common/domain/budgets/currency_format_cubit.dart';
import 'common/domain/categories/categories_fetch_cubit.dart';
import 'common/domain/categories/categories_repository.dart';
import 'common/domain/months/months_fetch_cubit.dart';
import 'common/domain/months/months_repository.dart';
import 'common/domain/payees/payees_fetch_cubit.dart';
import 'common/domain/payees/payees_repository.dart';
import 'common/domain/scheduled_transactions/scheduled_transactions_fetch_cubit.dart';
import 'common/domain/scheduled_transactions/scheduled_transactions_repository.dart';
import 'common/domain/transactions/transactions_fetch_cubit.dart';
import 'common/domain/transactions/transactions_repository.dart';
import 'common/domain/user/user_id_fetch_cubit.dart';
import 'common/domain/worker/worker.dart';
import 'common/presentation/design_system/_build_context.dart';
import 'features/app_review/app_review_service.dart';
import 'features/auth/data/api/auth_api.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/dependencies.dart';
import 'features/auth/domain/use_cases/get_ynab_access_token.dart';
import 'features/auth/domain/use_cases/is_user_logged_in.dart';
import 'features/auth/domain/use_cases/watch_user.dart';
import 'features/category_views/data/api/category_views_api.dart';
import 'features/category_views/data/repositories/category_views_repository.dart';
import 'features/category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import 'features/charts/days_buffer/state/days_buffer_chart_data_cubit.dart';
import 'features/charts/income_expense/state/income_expense_chart_data_cubit.dart';
import 'features/charts/net_worth/net_worth_data_cubit.dart';
import 'features/charts/smoothed_income/smoothed_income_chart_data_cubit.dart';
import 'features/charts/spend_by_category/state/spend_by_category_chart_data_cubit.dart';
import 'features/charts/spend_by_payee/state/spend_by_payee_chart_data_cubit.dart';
import 'features/charts/state/chart_settings_cubit.dart';
import 'features/charts/targets/state/targets_health_report_chart_data_cubit.dart';
import 'features/date_range/state/selected_date_range_cubit.dart';
import 'features/frugal_month/data/api/frugal_months_api.dart';
import 'features/frugal_month/data/repositories/frugal_months_repository.dart';
import 'features/frugal_month/presentation/notifications/frugal_month_notifications.dart';
import 'features/home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import 'features/home_widgets/metrics/update_metrics_widget_cubit.dart';
import 'features/home_widgets/widgets.dart';
import 'features/income_expense/state/income_expense_report_cubit.dart';
import 'features/month_in_review/notifications/notifications.dart';
import 'features/notifications/notifications.dart';
import 'features/spend_tracker/data/api/spend_trackers_api.dart';
import 'features/spend_tracker/data/repositories/spend_trackers_repository.dart';
import 'features/spend_tracker/presentation/flows/create_spend_tracker/state/create_spend_tracker_cubit.dart';
import 'features/templates/data/api/transaction_templates_api.dart';
import 'features/templates/data/repositories/transaction_templates_repository.dart';
import 'firebase_options.dart';
import 'networking/dependencies.dart';
import 'persistence/drift/local_database.dart';
import 'persistence/drift/shared.dart';
import 'persistence/settings.dart';
import 'theme/app_theme.dart';
import 'utils/_cubit.dart';
import 'utils/_date_time.dart';
import 'utils/mappers/local_date_mapper.dart';
import 'ynab_api/oauth/ynab_auth_helper.dart';

Future<void> main() async {
  // Attempt to demangle stack traces for easier reading
  // I am not sure that this actually works.
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is st.Trace) return stack.vmTrace;
    if (stack is st.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  ErrorReporter? errorReporter;
  await st.Chain.capture(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Register mappers globally
      MapperContainer.globals.use(const LocalDateMapper());

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      final environment = parseEnvironment();
      final logger = environment.logger;

      final packageInfo = await PackageInfo.fromPlatform();

      errorReporter = ErrorReporter(logger: logger);

      await errorReporter!.initialize();

      final featureFlagsCubit = FeatureFlagsCubit.create();

      // Globally enable stringify for Equatable
      EquatableConfig.stringify = true;
      if (featureFlagsCubit.state.isWidgetsEnabled) {
        await HomeWidget.setAppGroupId(appWidgetsGroupId);
      }

      final localDatabase = createPersistentDb(logger: logger);
      final sharedPreferences = await SharedPreferences.getInstance();
      final settings = Settings(sharedPreferences);

      final ynabAuthHelper = await createYnabAuthHelper(
        environment: environment,
        logger: logger,
        errorReporter: errorReporter!,
        packageInfo: packageInfo,
        settings: settings,
      );

      final supabase = await Supabase.initialize(
        url: environment.supabaseUrl,
        anonKey: environment.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );

      await _setUpGraph(
        localDatabase,
        settings,
        environment,
        logger,
        packageInfo,
        errorReporter!,
        supabase,
        ynabAuthHelper,
      );

      await initializeFeatureFlags();

      await $notifications().init();

      // Schedule local notifications
      await inject<MonthInReviewNotificationsHandler>().scheduleNext12MonthInReviewNotifications();
      if (await settings.watchFrugalMonthNotificationsEnabled().nextValue()) {
        await inject<FrugalMonthNotificationsHandler>().rescheduleFrugalMonthNotifications();
      }

      // Get the initial route when the app has been opened via a tap on a push
      // notification or a Widget. If the app is opening normally (i.e not a tap
      // on one of those things), return `null` and we'll open to `/`.
      Future<String?> getInitialRoute() async {
        final defaultRoute = BudgetTab.route;
        final appStartPayload = await $notifications().getAppStartNotificationPayload();
        if (appStartPayload != null) {
          return appStartPayload.destination;
        }
        return defaultRoute;
      }

      if (featureFlagsCubit.state.isWidgetsEnabled) {
        // awaiting this seems to cause occasional hangs on app start
        unawaited(keepWidgetsUpToDateInBackground(errorReporter: errorReporter!, logger: logger));
      }

      configureApp();
      final router = createRouter(
        initialLocation: await getInitialRoute(),
        watchUser: WatchUser.create(),
        isUserLoggedIn: IsUserLoggedIn.create(),
        getYnabAccessToken: GetYnabAccessToken.create(),
        settings: settings,
      );

      final appLinks = AppLinks();
      appLinks.uriLinkStream.listen(DeepLinkHandler(router: router));

      // Update our lastFetch time to now so our auto-refresher doesn't; the
      // instantiation of the stores will trigger a fetch so a refresh would
      // be redundant.
      $settings().setLastFetch(nowLocal);

      runApp(
        MainApp(
          router: router,
          preBuiltProviders: [BlocProvider.value(value: featureFlagsCubit)],
          isWidgetsEnabled: featureFlagsCubit.state.isWidgetsEnabled,
        ),
      );
    },
    onError: (error, chain) {
      // If we're in debug mode, rethrow the error so we can see it in the console
      if (errorReporter != null) {
        unawaited(errorReporter!.recordError(error, chain.terse));
      }
    },
  );
}

Future<void> _setUpGraph(
  LocalDatabase localDatabase,
  Settings settings,
  Environment environment,
  Logger logger,
  PackageInfo packageInfo,
  ErrorReporter errorReporter,
  Supabase supabase,
  YnabAuthHelper ynabAuthHelper,
) {
  return setUpGraph(
    localDatabase: localDatabase,
    settings: settings,
    environment: environment,
    logger: logger,
    packageInfo: packageInfo,
    errorReporter: errorReporter,
    supabase: supabase.client,
    ynabAuthHelper: () => ynabAuthHelper,
    appReviewService: AppReviewService.create,
    ynabClient: () => createYnabHttpClient(
      environment: environment,
      logger: logger,
      ynabAuthHelper: ynabAuthHelper,
      packageInfo: packageInfo,
      settings: settings,
    ),

    discordClient: () => createDiscordHttpClient(environment: environment, logger: logger),
    worker: () => Worker.on(UniversalPlatform.isMobile ? IsolateType.background : IsolateType.main),
    authApi: AuthApi.create,
    authRepository: AuthRepository.create,
    notifications: FlutterLocalNotificationsPlugin.new,
    payeesRepository: PayeesRepository.create,
    accountsRepository: AccountsRepository.create,
    budgetsRepository: BudgetsRepository.create,
    categoriesRepository: CategoriesRepository.create,
    categoryViewsRepository: CategoryViewsRepository.create,
    categoryViewsApi: CategoryViewsApi.create,
    transactionsRepository: TransactionsRepository.create,
    scheduledTransactionsRepository: ScheduledTransactionsRepository.create,
    monthsRepository: MonthsRepository.create,
    frugalMonthNotificationsHandler: FrugalMonthNotificationsHandler.create,
    frugalMonthsApi: FrugalMonthsApi.create,
    monthInReviewNotificationsHandler: MonthInReviewNotificationsHandler.create,
    frugalMonthsRepository: FrugalMonthsRepository.create,
    spendTrackersRepository: SpendTrackersRepository.create,
    spendTrackersApi: SpendTrackersApi.create,
    templatesRepository: TransactionTemplatesRepository.create,
    transactionTemplatesApi: TransactionTemplatesApi.create,
  );
}

class AppState {
  AppState({required this.themeMode});

  factory AppState.initial() {
    return AppState(themeMode: ThemeMode.dark);
  }

  final ThemeMode themeMode;
}

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit({required this.settings}) : super(AppState.initial()) {
    fetch();
  }

  factory AppStateCubit.create() {
    return AppStateCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    subs.add(
      settings.watchThemeMode().listen((themeMode) {
        safeEmit(AppState(themeMode: themeMode));
      }),
    );
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class MainApp extends HookWidget {
  const MainApp({
    super.key,
    required this.router,
    required this.preBuiltProviders,
    required this.isWidgetsEnabled,
  });

  final bool isWidgetsEnabled;
  final List<SingleChildWidget> preBuiltProviders;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...preBuiltProviders,
        Provider<HasNotificationPermissions>(create: (_) => $notifications().hasPermission),
        // App Cubits
        BlocProvider(create: (_) => AppStateCubit.create()),
        BlocProvider(create: (_) => FeatureFlagsCubit.create()),
        BlocProvider(create: (_) => UserIdFetchCubit.create()),
        BlocProvider(create: (_) => BudgetsFetchCubit.create()),
        BlocProvider(create: (_) => CategoriesFetchCubit.create()),
        BlocProvider(create: (_) => PayeesFetchCubit.create()),
        BlocProvider(create: (_) => AccountsFetchCubit.create()),
        BlocProvider(create: (_) => TransactionsFetchCubit.create()),
        BlocProvider(create: (_) => ScheduledTransactionsFetchCubit.create()),
        BlocProvider(create: (_) => MonthsFetchCubit.create()),
        BlocProvider(create: (_) => CurrencyFormatCubit.create()),
        BlocProvider(create: (_) => SelectedDateRangeCubit.create()),
        BlocProvider(create: (_) => ChartSettingsCubit.create()),
        if (isWidgetsEnabled)
          BlocProvider(
            create: (_) => UpdateMetricsWidgetsCubit.create(isEnabled: isWidgetsEnabled),
          ),
        // Chart & Reports Cubits
        BlocProvider(create: (_) => IncomeExpenseReportCubit.create()),
        BlocProvider(create: (_) => IncomeExpenseChartDataCubit.create()),
        BlocProvider(create: (_) => NetWorthDataCubit.create()),
        BlocProvider(create: (_) => SpendByPayeeChartDataCubit.create()),
        BlocProvider(create: (_) => SpendByCategoryChartDataCubit.create()),
        BlocProvider(create: (_) => SmoothedIncomeChartDataCubit.create()),
        BlocProvider(create: (_) => DaysBufferChartDataCubit.create()),
        BlocProvider(create: (_) => TargetsHealthReportChartDataCubit.create()),
        // Entity Creation Cubits
        // TODO: Migrate these to use ShellRoute + Flows
        BlocProvider(create: (_) => CreateSpendTrackerCubit.create()),
        BlocProvider(create: (_) => CreateCategoryViewCubit.create()),
      ],
      child: BlocBuilder<AppStateCubit, AppState>(
        builder: (context, state) {
          final brightness = switch (state.themeMode) {
            ThemeMode.system => MediaQuery.of(context).platformBrightness,
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
          };

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarBrightness: brightness),
          );

          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                MaterialApp.router(
                  scaffoldMessengerKey: rootScaffoldKey,
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  theme: createAppTheme(brightness: brightness),
                  themeMode: state.themeMode,
                  builder: (context, child) {
                    return SkeletonizerConfig(data: context.skeletonizerTheme, child: child!);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
