import 'dart:async';

import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../auth/data/api/auth_api.dart';
import '../../domain/models/legacy_transaction_template.dart';
import '../../domain/models/transaction_template.dart';
import '../../domain/models/transaction_template_draft.dart';
import '../api/models/transaction_template_from_backend.dart';
import '../api/transaction_templates_api.dart';

class TransactionTemplatesRepository {
  TransactionTemplatesRepository({required TransactionTemplatesApi api, required AuthApi authApi})
    : _api = api,
      _authApi = authApi {
    unawaited(_fetchTemplates());
    _subs.add(_authApi.onAuthenticated(refresh));
  }

  factory TransactionTemplatesRepository.create() {
    return TransactionTemplatesRepository(api: inject(), authApi: inject());
  }

  final TransactionTemplatesApi _api;
  final AuthApi _authApi;

  final _subject = BehaviorSubject<List<TransactionTemplate>>.seeded(<TransactionTemplate>[]);
  final _subs = CompositeSubscription();

  Future<void> _fetchTemplates() async {
    final templates = await _api.getTemplates();
    _subject.add(templates.map((template) => template.toDomain()).toList());
  }

  Stream<List<TransactionTemplate>> get watch => _subject.stream;

  Future<void> refresh() async {
    await _fetchTemplates();
  }

  Future<Result<String, Exception>> insertTemplate({
    required String budgetId,
    required TransactionTemplateDraft draft,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.insertTemplate(userId: user.id, budgetId: budgetId, draft: draft);
    });
  }

  Future<Result<void, Exception>> deleteTemplate(String templateId) async {
    return _api.deleteTemplate(templateId);
  }

  Future<Result<void, Exception>> updateTemplate(String id, TransactionTemplateDraft draft) async {
    return _api.updateTemplate(id: id, draft: draft);
  }

  Future<void> dispose() async {
    await _subject.close();
    await _subs.dispose();
  }
}

extension on TransactionTemplateFromBackend {
  TransactionTemplate toDomain() {
    return TransactionTemplate(
      id: id,
      budgetId: budgetId,
      name: name,
      amount: amount,
      accountId: accountId,
      categoryId: categoryId,
      payeeId: payeeId,
      memo: memo,
      isInflow: isInflow,
      fireImmediately: fireImmediately,
      flag: flag == null ? null : Flag.values.byName(flag!),
      subTransactions: subTransactions
          .map(
            (sub) => SubTransactionTemplate(
              id: sub.id,
              categoryId: sub.categoryId,
              amount: sub.amount,
              isInflow: sub.isInflow,
              payeeId: sub.payeeId,
              memo: sub.memo,
            ),
          )
          .toList(),
    );
  }
}
