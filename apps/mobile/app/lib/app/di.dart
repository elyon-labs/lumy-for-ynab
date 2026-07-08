import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/domain/accounts/accounts_repository.dart';
import '../common/domain/budgets/budgets_repository.dart';
import '../common/domain/categories/categories_repository.dart';
import '../common/domain/months/months_repository.dart';
import '../common/domain/payees/payees_repository.dart';
import '../common/domain/scheduled_transactions/scheduled_transactions_repository.dart';
import '../common/domain/transactions/transactions_repository.dart';
import '../common/domain/worker/worker.dart';
import '../external/http_client.dart';
import '../features/app_review/app_review_service.dart';
import '../features/auth/data/api/auth_api.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/category_views/data/api/category_views_api.dart';
import '../features/category_views/data/repositories/category_views_repository.dart';
import '../features/frugal_month/data/api/frugal_months_api.dart';
import '../features/frugal_month/data/repositories/frugal_months_repository.dart';
import '../features/frugal_month/presentation/notifications/frugal_month_notifications.dart';
import '../features/month_in_review/notifications/notifications.dart';
import '../features/spend_tracker/data/api/spend_trackers_api.dart';
import '../features/spend_tracker/data/repositories/spend_trackers_repository.dart';
import '../features/templates/data/api/create_transaction.dart';
import '../features/templates/data/api/transaction_templates_api.dart';
import '../features/templates/data/repositories/transaction_templates_repository.dart';
import '../persistence/drift/local_database.dart';
import '../persistence/settings.dart';
import '../ynab_api/oauth/ynab_auth_helper.dart';
import 'environment/environment.dart';
import 'error_reporting/error_reporter.dart';

GetIt graph = GetIt.instance;

T inject<T extends Object>([String? instanceName]) => graph.get<T>(instanceName: instanceName);

typedef LazyBuilder<T> = T Function();

const ynabHttpClient = 'ynabHttpClient';
const discordHttpClient = 'discordHttpClient';

Future<void> setUpGraph({
  required LocalDatabase localDatabase,
  required Settings settings,
  required Environment environment,
  required Logger logger,
  required PackageInfo packageInfo,
  required ErrorReporter errorReporter,
  required SupabaseClient supabase,
  required LazyBuilder<YnabAuthHelper> ynabAuthHelper,
  required LazyBuilder<AppReviewService> appReviewService,
  required LazyBuilder<HttpClient> ynabClient,
  required LazyBuilder<HttpClient> discordClient,
  required LazyBuilder<Worker> worker,
  required LazyBuilder<FlutterLocalNotificationsPlugin> notifications,
  required LazyBuilder<AuthApi> authApi,
  required LazyBuilder<AuthRepository> authRepository,
  required LazyBuilder<PayeesRepository> payeesRepository,
  required LazyBuilder<AccountsRepository> accountsRepository,
  required LazyBuilder<BudgetsRepository> budgetsRepository,
  required LazyBuilder<CategoriesRepository> categoriesRepository,
  required LazyBuilder<CategoryViewsRepository> categoryViewsRepository,
  required LazyBuilder<CategoryViewsApi> categoryViewsApi,
  required LazyBuilder<TransactionsRepository> transactionsRepository,
  required LazyBuilder<ScheduledTransactionsRepository> scheduledTransactionsRepository,
  required LazyBuilder<MonthsRepository> monthsRepository,
  required LazyBuilder<MonthInReviewNotificationsHandler> monthInReviewNotificationsHandler,
  required LazyBuilder<FrugalMonthNotificationsHandler> frugalMonthNotificationsHandler,
  required LazyBuilder<FrugalMonthsRepository> frugalMonthsRepository,
  required LazyBuilder<FrugalMonthsApi> frugalMonthsApi,
  required LazyBuilder<SpendTrackersRepository> spendTrackersRepository,
  required LazyBuilder<SpendTrackersApi> spendTrackersApi,
  required LazyBuilder<TransactionTemplatesRepository> templatesRepository,
  required LazyBuilder<TransactionTemplatesApi> transactionTemplatesApi,
}) async {
  graph
    ..registerSingleton(localDatabase, dispose: (db) => db.close())
    ..registerSingleton(environment)
    ..registerSingleton(packageInfo)
    ..registerSingleton(errorReporter)
    ..registerSingleton(supabase)
    ..registerSingleton(logger)
    ..registerLazySingleton(appReviewService)
    ..registerLazySingleton(() => settings)
    ..registerLazySingleton(ynabAuthHelper, dispose: (h) => h.close())
    ..registerLazySingleton(ynabClient, instanceName: ynabHttpClient)
    ..registerLazySingleton(discordClient, instanceName: discordHttpClient)
    ..registerLazySingleton(worker)
    ..registerLazySingleton(authApi)
    ..registerLazySingleton(authRepository)
    ..registerLazySingleton(payeesRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(accountsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(budgetsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(categoriesRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(categoryViewsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(categoryViewsApi)
    ..registerLazySingleton(transactionsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(scheduledTransactionsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(monthsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(frugalMonthsRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(frugalMonthsApi)
    ..registerLazySingleton(spendTrackersRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(spendTrackersApi)
    ..registerLazySingleton(templatesRepository, dispose: (r) => r.dispose())
    ..registerLazySingleton(transactionTemplatesApi)
    ..registerLazySingleton(notifications)
    ..registerLazySingleton(monthInReviewNotificationsHandler)
    ..registerLazySingleton(frugalMonthNotificationsHandler)
    ..registerLazySingleton(ShorebirdCodePush.new)
    ..registerLazySingleton(CreateTransactionService.create);

  await graph.allReady();
}

Worker $worker() => graph.get<Worker>();
FlutterLocalNotificationsPlugin $notifications() => graph.get<FlutterLocalNotificationsPlugin>();
Settings $settings() => graph.get<Settings>();
