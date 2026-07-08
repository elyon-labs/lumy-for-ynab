import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/models/transaction_template_draft.dart';

part 'update_template_request.mapper.dart';

@MappableClass()
class UpdateTemplateRequest with UpdateTemplateRequestMappable {
  UpdateTemplateRequest({required this.id, required this.draft});

  final String id;
  final TransactionTemplateDraft draft;
}
