import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/transaction_templates_repository.dart';
import '../models/transaction_template_draft.dart';

class InsertTransactionTemplate {
  InsertTransactionTemplate({required TransactionTemplatesRepository templatesRepository})
    : _templatesRepository = templatesRepository;

  factory InsertTransactionTemplate.create() {
    return InsertTransactionTemplate(templatesRepository: inject());
  }

  final TransactionTemplatesRepository _templatesRepository;

  Future<Result<String, Exception>> call({
    required String budgetId,
    required TransactionTemplateDraft draft,
  }) async {
    final result = await _templatesRepository.insertTemplate(budgetId: budgetId, draft: draft);

    if (result.isOk()) {
      await _templatesRepository.refresh();
    }

    return result;
  }
}
