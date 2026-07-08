import 'package:charlatan/charlatan.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:lumy/app/di.dart';
import 'package:lumy/common/domain/accounts/accounts_repository.dart';
import 'package:lumy/common/domain/budgets/budgets_repository.dart';
import 'package:lumy/common/domain/categories/categories_repository.dart';
import 'package:lumy/common/domain/months/months_repository.dart';
import 'package:lumy/common/domain/payees/payees_repository.dart';
import 'package:lumy/common/domain/scheduled_transactions/scheduled_transactions_repository.dart';
import 'package:lumy/common/domain/transactions/transactions_repository.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/external/http_client.dart';
import 'package:lumy/features/auth/data/api/auth_api.dart';
import 'package:lumy/features/auth/data/repositories/auth_repository.dart';
import 'package:lumy/features/category_views/data/api/category_views_api.dart';
import 'package:lumy/features/category_views/data/repositories/category_views_repository.dart';
import 'package:lumy/features/frugal_month/data/api/frugal_months_api.dart';
import 'package:lumy/features/frugal_month/data/repositories/frugal_months_repository.dart';
import 'package:lumy/features/frugal_month/presentation/notifications/frugal_month_notifications.dart';
import 'package:lumy/features/month_in_review/notifications/notifications.dart';
import 'package:lumy/features/spend_tracker/data/api/spend_trackers_api.dart';
import 'package:lumy/features/spend_tracker/data/repositories/spend_trackers_repository.dart';
import 'package:lumy/features/templates/data/api/transaction_templates_api.dart';
import 'package:lumy/features/templates/data/repositories/transaction_templates_repository.dart';
import 'package:lumy/persistence/drift/native.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'fake_app_review_service.dart';
import 'fake_environment.dart';
import 'fake_error_reporter.dart';
import 'fake_http.dart';
import 'fake_package_info.dart';
import 'fake_shared_preferences.dart';

Future<void> setUpTestGraph() async {
  await graph.reset();
  final database = await createInMemoryDb();
  final charlatan = charlatanWithDefaults();

  await setUpGraph(
    localDatabase: database,
    settings: Settings(FakeSharedPreferences()),
    environment: FakeEnvironment(),
    logger: Logger(level: Level.off),
    packageInfo: FakePackageInfo(),
    errorReporter: FakeErrorReporter(),
    supabase: Supabase.instance.client,
    ynabAuthHelper: () => throw UnimplementedError(),
    appReviewService: FakeAppReviewService.new,
    ynabClient: () =>
        HttpClient(dio: Dio()..httpClientAdapter = charlatan.toFakeHttpClientAdapter()),
    discordClient: () =>
        HttpClient(dio: Dio()..httpClientAdapter = charlatan.toFakeHttpClientAdapter()),
    worker: () => Worker.on(IsolateType.main),
    notifications: FlutterLocalNotificationsPlugin.new,
    authApi: AuthApi.create,
    authRepository: AuthRepository.create,
    payeesRepository: PayeesRepository.create,
    accountsRepository: AccountsRepository.create,
    budgetsRepository: BudgetsRepository.create,
    categoriesRepository: CategoriesRepository.create,
    categoryViewsRepository: CategoryViewsRepository.create,
    categoryViewsApi: CategoryViewsApi.create,
    transactionsRepository: TransactionsRepository.create,
    scheduledTransactionsRepository: ScheduledTransactionsRepository.create,
    monthsRepository: MonthsRepository.create,
    monthInReviewNotificationsHandler: MonthInReviewNotificationsHandler.create,
    frugalMonthNotificationsHandler: FrugalMonthNotificationsHandler.create,
    frugalMonthsRepository: FrugalMonthsRepository.create,
    frugalMonthsApi: FrugalMonthsApi.create,
    spendTrackersRepository: SpendTrackersRepository.create,
    spendTrackersApi: SpendTrackersApi.create,
    templatesRepository: TransactionTemplatesRepository.create,
    transactionTemplatesApi: TransactionTemplatesApi.create,
  );
}
