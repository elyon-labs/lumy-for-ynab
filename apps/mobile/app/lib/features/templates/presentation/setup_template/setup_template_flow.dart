import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../external/flow.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import '../../domain/models/transaction_template.dart';
import '../../domain/models/transaction_template_draft.dart';
import '../../domain/use_cases/insert_template.dart';
import '../../domain/use_cases/update_template.dart';
import '../../domain/use_cases/watch_all_templates.dart';
import 'screens/configure_template_screen/configure_template_screen.dart';
import 'screens/setup_template_screen/setup_template_screen.dart';

part 'setup_template_flow.mapper.dart';

@MappableClass()
class SetupTemplateFlowState extends FlowState with SetupTemplateFlowStateMappable {
  SetupTemplateFlowState({
    required super.route,
    required this.template,
    required this.canSave,
    required this.canEnableFireImmediately,
  });

  factory SetupTemplateFlowState.initial() {
    return SetupTemplateFlowState(
      route: SetupTemplateScreen.route,
      template: const Loading(),
      canSave: false,
      canEnableFireImmediately: false,
    );
  }

  final Async<TransactionTemplateDraft> template;
  final bool canSave;
  final bool canEnableFireImmediately;
}

class SetupTemplateFlow extends FlowManager<SetupTemplateFlowState, SetupTemplateFlowStep> {
  SetupTemplateFlow({
    required String? existingTemplateId,
    required Settings settings,
    required WatchAllTemplates watchAllTemplates,
    required InsertTransactionTemplate insertTemplate,
    required UpdateTemplate updateTemplate,
  }) : _existingTemplateId = existingTemplateId,
       _settings = settings,
       _watchAllTemplates = watchAllTemplates,
       _insertTemplate = insertTemplate,
       _updateTemplate = updateTemplate,
       super(SetupTemplateFlowState.initial()) {
    fetch();
  }

  factory SetupTemplateFlow.create({required String? existingTemplateId}) {
    return SetupTemplateFlow(
      existingTemplateId: existingTemplateId,
      settings: inject(),
      watchAllTemplates: WatchAllTemplates.create(),
      insertTemplate: InsertTransactionTemplate.create(),
      updateTemplate: UpdateTemplate.create(),
    );
  }

  final String? _existingTemplateId;
  final Settings _settings;
  final WatchAllTemplates _watchAllTemplates;
  final InsertTransactionTemplate _insertTemplate;
  final UpdateTemplate _updateTemplate;
  final _subs = CompositeSubscription();

  bool get _isEditing => _existingTemplateId != null;

  void fetch() {
    final sub = _watchAllTemplates().listen((templates) {
      if (_existingTemplateId != null) {
        final existingTemplate = templates.firstWhere((t) => t.id == _existingTemplateId);
        final draft = existingTemplate.toTransactionTemplateDraft();
        safeEmit(
          state.copyWith(
            template: Loaded(draft),
            canSave: draft.canSave,
            canEnableFireImmediately: draft.canCreateTransaction,
          ),
        );
      } else {
        safeEmit(state.copyWith(template: Loaded(TransactionTemplateDraft())));
      }
    });
    _subs.add(sub);
  }

  void updateTemplate(TransactionTemplateDraft Function(TransactionTemplateDraft template) update) {
    final currentTemplate = state.template.unwrap();
    final updatedTemplate = update(currentTemplate);
    safeEmit(
      state.copyWith(
        template: Loaded(updatedTemplate),
        canSave: updatedTemplate.name?.isNotEmpty ?? false,
        canEnableFireImmediately: updatedTemplate.canCreateTransaction,
      ),
    );
  }

  void setName(String name) {
    safeEmit(
      state.copyWith(
        template: Loaded(state.template.unwrap().copyWith(name: name)),
        canSave: name.isNotEmpty,
      ),
    );
  }

  void setFireImmediately(bool fireImmediately) {
    safeEmit(
      state.copyWith(
        template: Loaded(state.template.unwrap().copyWith(fireImmediately: fireImmediately)),
      ),
    );
  }

  void toggleFireImmediately() {
    final current = state.template.unwrap();
    safeEmit(
      state.copyWith(template: Loaded(current.copyWith(fireImmediately: !current.fireImmediately))),
    );
  }

  Future<Result<void, Exception>> save() async {
    final selectedBudgetId = await _settings.watchSelectedBudgetId().nextValue().unwrap();
    final Result<void, Exception> result;
    final TransactionTemplateDraft draft = state.template.unwrap();
    if (_isEditing) {
      result = await _updateTemplate(id: draft.id, draft: draft);
    } else {
      result = await _insertTemplate(budgetId: selectedBudgetId, draft: draft);
    }
    if (result.isOk()) {
      safeEmit(state.copyWith(route: BudgetTab.route));
    }
    return result;
  }

  @override
  Future<void> stepComplete(SetupTemplateFlowStep step) async {
    switch (step) {
      case SetupTransaction():
        safeEmit(
          state.copyWith(
            route: _isEditing
                ? ConfigureTemplateScreen.buildEditRoute(_existingTemplateId!)
                : ConfigureTemplateScreen.route,
            canEnableFireImmediately: state.template.unwrap().canCreateTransaction,
            canSave: state.template.unwrap().canSave,
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

sealed class SetupTemplateFlowStep {
  const SetupTemplateFlowStep();
}

class SetupTransaction extends SetupTemplateFlowStep {}
