import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../../utils/_build_context.dart';
import '../../../../../home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import '../../../../domain/models/transaction_template_draft.dart';
import '../../setup_template_flow.dart';

class ConfigureTemplateScreen extends StatelessWidget {
  const ConfigureTemplateScreen({super.key, required this.existingTemplateId});

  final String? existingTemplateId;

  static String route = '/budget/setup_template/configure_template';

  static String buildEditRoute(String templateId) {
    return '/budget/setup_template/$templateId/configure_template';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Template details')),
      body: BlocBuilder<SetupTemplateFlow, SetupTemplateFlowState>(
        builder: (context, state) {
          final (template, isLoading, error) = state.template.details();

          if (isLoading || template == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(child: Text('Error: $error'));
          }

          return VLayout(
            spacing: 0,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
                  child: VLayout(
                    children: [
                      _NameRow(template: template),
                      _FireImmediatelyRow(template: template),
                    ],
                  ),
                ),
              ),
              _SaveTemplateButton(template: template),
            ],
          );
        },
      ),
    );
  }
}

class _NameRow extends HookWidget {
  const _NameRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: template.name);

    return HEdgePadding(
      child: OutlinedChild(
        child: HEdgePadding(
          child: TextField(
            controller: nameController,
            autofocus: false,
            decoration: const InputDecoration(hintText: 'Enter a name'),
            onChanged: (value) {
              context.read<SetupTemplateFlow>().setName(value);
            },
          ),
        ),
      ),
    );
  }
}

class _FireImmediatelyRow extends StatelessWidget {
  const _FireImmediatelyRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    final fireImmediately = template.fireImmediately;
    final canFireImmediately = context.watch<SetupTemplateFlow>().state.canEnableFireImmediately;
    return ListRow(
      title: const Text('Fire immediately'),
      subtitle: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Creates a transaction immediately on tap, without modifying the template.',
            ),
            if (!canFireImmediately) ...[
              const TextSpan(text: ' '),
              TextSpan(
                text:
                    'To enable this you must have an account selected and all sub-transactions must sum to the total of the transaction itself.',
                style: TextStyle(color: context.colors.error),
              ),
            ],
          ],
        ),
      ),
      trailing: SmallerSwitch(
        value: fireImmediately,
        onChanged: canFireImmediately
            ? (value) {
                context.read<SetupTemplateFlow>().setFireImmediately(value);
              }
            : null,
      ),
      onTap: canFireImmediately
          ? () {
              context.read<SetupTemplateFlow>().toggleFireImmediately();
            }
          : null,
    );
  }
}

class _SaveTemplateButton extends StatelessWidget {
  const _SaveTemplateButton({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SetupTemplateFlow>().state;
    return Visibility(
      visible: state.canSave,
      child: SafeArea(
        child: HEdgePadding(
          child: VEdgePadding(
            child: PrimaryButton(
              child: const Text('Save'),
              onPressed: () async {
                final result = await context.read<SetupTemplateFlow>().save();
                if (context.mounted) {
                  result.when(
                    ok: (id) => GoRouter.of(context).go(BudgetTab.route),
                    err: (err) {
                      context.showToast(const Text('Oops! Something went wrong'));
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
