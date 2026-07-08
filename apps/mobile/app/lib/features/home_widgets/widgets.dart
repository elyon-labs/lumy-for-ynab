import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:logger/logger.dart';

import '../../app/error_reporting/error_reporter.dart';
import '../../common/domain/transactions/transactions_fetch_cubit.dart';
import '../../theme/color_palette.dart';
import 'metrics/update_metrics_widget_in_background.dart';

const String appWidgetsGroupId = 'group.com.brandontrautmann.apps';

Future<void> updateWidgetsInBackground({
  required ErrorReporter errorReporter,
  required Logger logger,
}) async {
  try {
    // Create the cubit--it will automatically fetch new transactions.
    final cubit = TransactionsFetchCubit.create();
    var state = cubit.state;
    while (state.transactions is Idle || state.transactions is Loading) {
      // Loop until we've refreshed transactions
      await Future.delayed(const Duration(milliseconds: 100));
      state = cubit.state;
    }
    if (state.transactions is Error) {
      logger.e('Error fetching transactions in background', error: state.transactions.error);
      return;
    }
    await updateMetricsWidgetInBackground(palette: lightPalette);
  } on Exception catch (e) {
    logger.e('Error updating widgets in background', error: e, stackTrace: StackTrace.current);
    await errorReporter.recordError(e, StackTrace.current);
  }
}

Future<void> keepWidgetsUpToDateInBackground({
  required ErrorReporter errorReporter,
  required Logger logger,
}) async {
  try {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(minimumFetchInterval: 60),
      (String taskId) async {
        await updateWidgetsInBackground(errorReporter: errorReporter, logger: logger);
        await BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        logger.w('Background fetch timed out: $taskId');
        await BackgroundFetch.finish(taskId);
      },
    );
  } on Exception catch (e) {
    logger.e('Error configuring background fetch', error: e, stackTrace: StackTrace.current);
    await errorReporter.recordError(e, StackTrace.current);
  }
}
