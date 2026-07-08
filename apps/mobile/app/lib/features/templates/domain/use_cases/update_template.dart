import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/transaction_templates_repository.dart';
import '../models/transaction_template_draft.dart';

class UpdateTemplate {
  UpdateTemplate({required TransactionTemplatesRepository repository}) : _repository = repository;

  factory UpdateTemplate.create() {
    return UpdateTemplate(repository: inject());
  }

  final TransactionTemplatesRepository _repository;

  Future<Result<void, Exception>> call({
    required String id,
    required TransactionTemplateDraft draft,
  }) async {
    final result = await _repository.updateTemplate(id, draft);

    if (result.isOk()) {
      await _repository.refresh();
    }

    return result;
  }
}
