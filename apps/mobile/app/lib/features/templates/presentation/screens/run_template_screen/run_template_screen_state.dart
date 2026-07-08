import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../utils/_cubit.dart';
import '../../../data/api/create_transaction.dart';
import '../../../domain/models/transaction_template.dart';
import '../../../domain/use_cases/watch_all_templates.dart';

part 'run_template_screen_state.mapper.dart';

@MappableClass()
class RunTemplateScreenState with RunTemplateScreenStateMappable {
  RunTemplateScreenState({
    required this.isReadyToBeCreated,
    required this.template,
    required this.templateId,
  });

  factory RunTemplateScreenState.initial(String templateId) {
    return RunTemplateScreenState(
      isReadyToBeCreated: false,
      template: const Loading(),
      templateId: templateId,
    );
  }

  final bool isReadyToBeCreated;
  final Async<TransactionTemplate> template;
  final String templateId;
}

class RunTemplateScreenCubit extends Cubit<RunTemplateScreenState> {
  RunTemplateScreenCubit({
    required String templateId,
    required WatchAllTemplates watchAllTemplates,
    required CreateTransactionService createTransactionService,
  }) : _createTransactionService = createTransactionService,
       _templateId = templateId,
       _watchAllTemplates = watchAllTemplates,
       super(RunTemplateScreenState.initial(templateId)) {
    fetch();
  }

  factory RunTemplateScreenCubit.create(String templateId) {
    return RunTemplateScreenCubit(
      templateId: templateId,
      watchAllTemplates: WatchAllTemplates.create(),
      createTransactionService: inject(),
    );
  }

  final String _templateId;
  final WatchAllTemplates _watchAllTemplates;
  final CreateTransactionService _createTransactionService;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _watchAllTemplates().listen((templates) {
      final template = templates.firstWhereOrNull((t) => t.id == _templateId);
      if (template != null) {
        safeEmit(state.copyWith(template: Loaded(template), isReadyToBeCreated: template.isValid));
      }
    });
    _subs.add(sub);
  }

  void updateTemplate(TransactionTemplate Function(TransactionTemplate) update) {
    final template = state.template.unwrap();
    final newTemplate = update(template);
    safeEmit(
      state.copyWith(template: Loaded(newTemplate), isReadyToBeCreated: newTemplate.isValid),
    );
  }

  Future<Result<String, Exception>> createTransaction() async {
    return _createTransactionService.create(template: state.template.unwrap());
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
