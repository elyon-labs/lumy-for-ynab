import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../../../app/di.dart';
import '../../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../templates/data/api/create_transaction.dart';
import '../../../../../../../../../templates/domain/models/transaction_template.dart';
import '../../../../../../../../../templates/domain/use_cases/delete_template.dart';
import '../../../../../../../../../templates/domain/use_cases/watch_all_templates.dart';

part 'templates_section_state.mapper.dart';

@MappableClass()
class TemplatesSectionState with TemplatesSectionStateMappable {
  TemplatesSectionState({required this.templates, required this.templateStatus});

  factory TemplatesSectionState.initial() {
    return TemplatesSectionState(templates: [], templateStatus: {});
  }

  final List<TransactionTemplate> templates;
  final Map<String, Async<void>> templateStatus;
}

class TemplatesSectionCubit extends Cubit<TemplatesSectionState> {
  TemplatesSectionCubit({
    required CreateTransactionService createTransactionService,
    required WatchAllTemplates watchAllTemplates,
    required DeleteTemplate deleteTemplate,
  }) : _createTransactionService = createTransactionService,
       _watchAllTemplates = watchAllTemplates,
       _deleteTemplate = deleteTemplate,
       super(TemplatesSectionState.initial()) {
    unawaited(fetch());
  }

  factory TemplatesSectionCubit.create() {
    return TemplatesSectionCubit(
      createTransactionService: inject(),
      watchAllTemplates: WatchAllTemplates.create(),
      deleteTemplate: DeleteTemplate.create(),
    );
  }

  final CreateTransactionService _createTransactionService;
  final WatchAllTemplates _watchAllTemplates;
  final DeleteTemplate _deleteTemplate;
  final _subs = CompositeSubscription();

  Future<void> fetch() async {
    final sub = _watchAllTemplates().listen((templates) {
      safeEmit(state.copyWith(templates: templates));
    });
    _subs.add(sub);
  }

  Future<void> deleteTemplate(TransactionTemplate template) {
    return _deleteTemplate(template.id);
  }

  Future<Result<String, Exception>> runTemplateImmediately(TransactionTemplate template) async {
    safeEmit(state.copyWith(templateStatus: {template.id: const Loading()}));
    final result = await _createTransactionService.create(template: template);
    safeEmit(
      state.copyWith(
        templateStatus: {
          template.id: switch (result) {
            Ok<String, Exception>() => const Idle(),
            Err<String, Exception>(:final error) => Error(error),
          },
        },
      ),
    );
    return result;
  }

  @override
  Future<void> close() async {
    await _subs.cancel();
    return super.close();
  }
}
