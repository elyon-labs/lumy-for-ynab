import 'package:dart_mappable/dart_mappable.dart';

import '../ynab_api_models.dart';

part 'scheduled_transactions_response.mapper.dart';

@MappableClass()
class ScheduledTransactionsResponse with ScheduledTransactionsResponseMappable {
  const ScheduledTransactionsResponse({required this.data});

  final ScheduledTransactions data;
}

@MappableClass()
class ScheduledTransactions with ScheduledTransactionsMappable {
  const ScheduledTransactions({required this.serverKnowledge, required this.scheduledTransactions});

  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
  @MappableField(key: 'scheduled_transactions')
  final List<ScheduledTransaction> scheduledTransactions;
}
