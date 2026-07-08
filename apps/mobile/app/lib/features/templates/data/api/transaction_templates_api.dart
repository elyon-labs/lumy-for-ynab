import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/di.dart';
import '../../domain/models/transaction_template_draft.dart';
import 'models/insert_template_request.dart';
import 'models/transaction_template_from_backend.dart';
import 'models/update_template_request.dart';

class TransactionTemplatesApi {
  TransactionTemplatesApi({required SupabaseClient client}) : _client = client;

  factory TransactionTemplatesApi.create() {
    return TransactionTemplatesApi(client: inject());
  }

  final SupabaseClient _client;

  Future<List<TransactionTemplateFromBackend>> getTemplates() async {
    final rows = await _client.from('v_user_transaction_templates').select();
    return rows.map(TransactionTemplateFromBackendMapper.fromMap).toList();
  }

  Future<Result<String, Exception>> insertTemplate({
    required String userId,
    required String budgetId,
    required TransactionTemplateDraft draft,
  }) async {
    return Result.asyncOf(() async {
      final request = InsertTemplateRequest(userId: userId, budgetId: budgetId, draft: draft);

      final response = await _client.functions.invoke('insert-template', body: request.toMap());

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        // ignore: avoid_dynamic_calls
        throw Exception('Failed to insert template: ${response.data?['error'] ?? 'Unknown error'}');
      }

      // ignore: avoid_dynamic_calls
      return response.data['id'] as String;
    });
  }

  Future<Result<void, Exception>> updateTemplate({
    required String id,
    required TransactionTemplateDraft draft,
  }) async {
    return Result.asyncOf(() async {
      final request = UpdateTemplateRequest(id: id, draft: draft);

      final response = await _client.functions.invoke('update-template', body: request.toMap());

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        // ignore: avoid_dynamic_calls
        throw Exception('Failed to update template: ${response.data?['error'] ?? 'Unknown error'}');
      }
    });
  }

  Future<Result<void, Exception>> deleteTemplate(String templateId) {
    return Result.asyncOf(() async {
      return await _client.from('transaction_templates').delete().eq('id', templateId);
    });
  }
}
