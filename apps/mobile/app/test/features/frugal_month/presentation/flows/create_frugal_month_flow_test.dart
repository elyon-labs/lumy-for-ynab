import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/frugal_month/data/repositories/frugal_months_repository.dart';
import 'package:lumy/features/frugal_month/domain/use_cases/calculate_frugal_month_data.dart';
import 'package:lumy/features/frugal_month/domain/use_cases/insert_frugal_month.dart';
import 'package:lumy/features/frugal_month/domain/use_cases/watch_frugal_month_data.dart';
import 'package:lumy/features/frugal_month/domain/use_cases/watch_frugal_months.dart';
import 'package:lumy/features/frugal_month/presentation/flows/create_frugal_month_flow.dart';
import 'package:lumy/features/frugal_month/presentation/notifications/frugal_month_notifications.dart';
import 'package:lumy/features/notifications/notifications.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utilities/fake_app_review_service.dart';
import '../../../../utilities/fake_frugal_months_repository.dart';
import '../../../../utilities/fake_shared_preferences.dart';
import '../../../../utilities/fake_transactions_repository.dart';

void main() {
  group('CreateFrugalMonthFlow', () {
    CreateFrugalMonthFlow buildSubject({
      FrugalMonthsRepository? repository,
      FakeSharedPreferences? sharedPreferences,
      HasNotificationPermissions? hasNotificationPermissions,
    }) {
      repository ??= FakeFrugalMonthsRepository();
      sharedPreferences ??= FakeSharedPreferences();
      hasNotificationPermissions ??= () async => true;
      final settings = Settings(sharedPreferences);
      final watchFrugalMonths = WatchFrugalMonths(repository: repository, settings: settings);
      return CreateFrugalMonthFlow(
        settings: settings,
        watchFrugalMonthData: WatchFrugalMonthData(
          watchFrugalMonths: watchFrugalMonths,
          calculateFrugalMonthData: CalculateFrugalMonthData(worker: Worker.on(IsolateType.main)),
          transactionsRepository: FakeTransactionsRepository(),
        ),
        insertFrugalMonth: InsertFrugalMonth(frugalMonthsRepository: repository),
        frugalMonthNotificationHandler: FrugalMonthNotificationsHandler(
          notifications: FlutterLocalNotificationsPlugin(),
          watchFrugalMonths: watchFrugalMonths,
        ),
        hasNotificationPermissions: hasNotificationPermissions,
        appReviewService: FakeAppReviewService(),
      );
    }

    test('it emits initial route as /budget/available_months_loading', () {
      final subject = buildSubject();

      expect(subject.state.route, '/budget/available_months_loading');
    });

    group('stepComplete', () {
      group('FetchAvailableMonthsStep', () {
        group('when only one available month', () {
          test(
            'it emits route as /budget/choose_categories and sets month to the provided month',
            () async {
              final subject = buildSubject();

              await subject.stepComplete(
                FetchAvailableMonthsStep(availableMonths: [LocalDate(2021, 1, 1)]),
              );

              expect(subject.state.route, '/budget/choose_categories');
              expect(subject.state.draft.month, LocalDate(2021, 1, 1));
            },
          );
        });

        group('when more than one available month', () {
          test('it emits route as /budget/choose_frugal_month and does not set a month', () async {
            final subject = buildSubject();

            await subject.stepComplete(
              FetchAvailableMonthsStep(
                availableMonths: [LocalDate(2021, 1, 1), LocalDate(2021, 2, 1)],
              ),
            );

            expect(subject.state.route, '/budget/choose_frugal_month');
            expect(subject.state.draft.month, isNull);
          });
        });
      });

      group('ChooseMonthStep', () {
        test('it emits route as /budget/choose_frugal_month/choose_categories and '
            'sets month to the provided month', () async {
          final subject = buildSubject();

          await subject.stepComplete(
            FetchAvailableMonthsStep(
              availableMonths: [LocalDate(2021, 1, 1), LocalDate(2021, 2, 1)],
            ),
          );

          await subject.stepComplete(ChooseMonthStep(selectedMonth: LocalDate(2021, 1, 1)));

          expect(subject.state.route, '/budget/choose_frugal_month/choose_categories');
          expect(subject.state.draft.month, LocalDate(2021, 1, 1));
        });
      });

      group('ChooseCategoriesStep', () {
        group('when 1 month available', () {
          test('it emits route as /budget/choose_categories/choose_accounts and '
              'sets categories to the provided categories', () async {
            final subject = buildSubject();

            await subject.stepComplete(
              FetchAvailableMonthsStep(availableMonths: [LocalDate(2021, 1, 1)]),
            );

            await subject.stepComplete(
              const ChooseCategoriesStep(selectedCategories: ['foo', 'bar']),
            );

            expect(subject.state.route, '/budget/choose_categories/choose_accounts');
            expect(subject.state.draft.categoryIds, ['foo', 'bar']);
          });
        });

        group('when more than 1 month available', () {
          test(
            'it emits route as /budget/choose_frugal_month/choose_categories/choose_accounts/set_target_amount and '
            'sets categories to the provided categories',
            () async {
              final subject = buildSubject();

              await subject.stepComplete(
                FetchAvailableMonthsStep(
                  availableMonths: [LocalDate(2021, 1, 1), LocalDate(2021, 2, 1)],
                ),
              );

              await subject.stepComplete(ChooseMonthStep(selectedMonth: LocalDate(2021, 1, 1)));

              await subject.stepComplete(
                const ChooseCategoriesStep(selectedCategories: ['foo', 'bar']),
              );

              expect(
                subject.state.route,
                '/budget/choose_frugal_month/choose_categories/choose_accounts',
              );
              expect(subject.state.draft.categoryIds, ['foo', 'bar']);
            },
          );
        });
      });

      group('ChooseAccountsStep', () {
        group('when 1 month available', () {
          test('it emits route as /budget/choose_categories/choose_accounts/set_target_amount and '
              'sets accounts to the provided accounts', () async {
            final subject = buildSubject();

            await subject.stepComplete(
              FetchAvailableMonthsStep(availableMonths: [LocalDate(2021, 1, 1)]),
            );

            await subject.stepComplete(const ChooseAccountsStep(selectedAccounts: ['foo', 'bar']));

            expect(
              subject.state.route,
              '/budget/choose_categories/choose_accounts/set_target_amount',
            );
            expect(subject.state.draft.accountIds, ['foo', 'bar']);
          });
        });

        group('when more than 1 month available', () {
          test(
            'it emits route as /budget/choose_frugal_month/choose_categories/choose_accounts/set_target_amount and '
            'sets accounts to the provided accounts',
            () async {
              final subject = buildSubject();

              await subject.stepComplete(
                FetchAvailableMonthsStep(
                  availableMonths: [LocalDate(2021, 1, 1), LocalDate(2021, 2, 1)],
                ),
              );

              await subject.stepComplete(ChooseMonthStep(selectedMonth: LocalDate(2021, 1, 1)));

              await subject.stepComplete(
                const ChooseAccountsStep(selectedAccounts: ['foo', 'bar']),
              );

              expect(
                subject.state.route,
                '/budget/choose_frugal_month/choose_categories/choose_accounts/set_target_amount',
              );
              expect(subject.state.draft.accountIds, ['foo', 'bar']);
            },
          );
        });
      });

      group('SetLimitStep', () {
        group('when draft is invalid', () {
          test('it emits route as error screen', () async {
            final subject = buildSubject();

            await subject.stepComplete(const SetLimitStep(limit: 1000));

            expect(subject.state.route, '/budget/frugal_month_error');
          });
        });

        group('when draft is valid', () {
          test('it creates the frugal month', () async {
            const budgetId = 'budgetId';
            late final bool insertCalled;
            final frugalMonthsRepository = FakeFrugalMonthsRepository(
              onInsert: () {
                insertCalled = true;
              },
            );

            final subject = buildSubject(
              repository: frugalMonthsRepository,
              sharedPreferences: FakeSharedPreferences({'selected_budget_id': budgetId}),
            );

            await subject.stepComplete(ChooseMonthStep(selectedMonth: LocalDate(2021, 1, 1)));
            await subject.stepComplete(
              const ChooseCategoriesStep(selectedCategories: ['foo', 'bar']),
            );
            await subject.stepComplete(const ChooseAccountsStep(selectedAccounts: ['foo', 'bar']));
            await subject.stepComplete(const SetLimitStep(limit: 1000));

            expect(insertCalled, isTrue);
            expect(subject.state.frugalMonthId, isA<Loaded>());
          });
        });
      });
    });
  });
}
