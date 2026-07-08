import 'package:go_router/go_router.dart';

import '../recurring_transactions_screen/recurring_transactions_screen.dart';

// ignore: non_constant_identifier_names
RouteBase RecurringTransactionsRoute() {
  return GoRoute(
    path: 'recurring_transactions',
    builder: (context, state) => const RecurringTransactionsScreen(),
  );
}
