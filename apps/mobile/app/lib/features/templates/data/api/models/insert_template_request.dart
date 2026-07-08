import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/models/transaction_template_draft.dart';

part 'insert_template_request.mapper.dart';

@MappableClass()
class InsertTemplateRequest with InsertTemplateRequestMappable {
  InsertTemplateRequest({required this.userId, required this.budgetId, required this.draft});

  final String userId;
  final String budgetId;
  final TransactionTemplateDraft draft;
}
