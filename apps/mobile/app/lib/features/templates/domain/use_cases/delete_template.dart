import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/transaction_templates_repository.dart';

class DeleteTemplate {
  DeleteTemplate({required TransactionTemplatesRepository repository}) : _repository = repository;

  factory DeleteTemplate.create() {
    return DeleteTemplate(repository: inject());
  }

  final TransactionTemplatesRepository _repository;

  Future<Result<void, Exception>> call(String templateId) async {
    final result = await _repository.deleteTemplate(templateId);
    if (result.isOk()) {
      await _repository.refresh();
    }
    return result;
  }
}
