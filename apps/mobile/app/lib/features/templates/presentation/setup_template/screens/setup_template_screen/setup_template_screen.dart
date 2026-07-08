import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/legacy_transaction_template.dart';
import '../../../../domain/models/transaction_template_draft.dart';
import '../../setup_template_flow.dart';
import 'widgets/template_account_row.dart';
import 'widgets/template_amount_row.dart';
import 'widgets/template_category_rows.dart';
import 'widgets/template_flag_row.dart';
import 'widgets/template_inflow_row.dart';
import 'widgets/template_memo_row.dart';
import 'widgets/template_payee_row.dart';

class SetupTemplateScreen extends StatelessWidget {
  const SetupTemplateScreen({super.key, required this.existingTemplateId});

  static String route = '/budget/setup_template';

  static String buildEditRoute(String templateId) {
    return '$route/$templateId';
  }

  final String? existingTemplateId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: existingTemplateId == null
            ? const Text('Create Template')
            : const Text('Edit Template'),
        leading: BackButton(onPressed: () => GoRouter.of(context).pop()),
      ),
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
                  child: VLayout(
                    children: [
                      _AmountRow(template: template),
                      _InflowRow(template: template),
                      _PayeeRow(template: template),
                      _AccountRow(template: template),
                      _CategoryRow(template: template),
                      _FlagRow(template: template),
                      _MemoRow(template: template),
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

class _AmountRow extends HookWidget {
  const _AmountRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateAmountRow(
      amount: template.amount,
      isInflow: template.isInflow,
      onChanged: (value) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(amount: value));
      },
    );
  }
}

class _InflowRow extends HookWidget {
  const _InflowRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateInflowRow(
      value: template.isInflow,
      onChanged: (value) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(isInflow: value));
      },
    );
  }
}

class _PayeeRow extends HookWidget {
  const _PayeeRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplatePayeeRow(
      payeeId: template.payeeId,
      onSelected: (payee) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(payeeId: payee.id));
      },
    );
  }
}

class _AccountRow extends HookWidget {
  const _AccountRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateAccountRow(
      accountId: template.accountId,
      onSelected: (account) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(accountId: account.id));
      },
    );
  }
}

class _CategoryRow extends HookWidget {
  const _CategoryRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateCategoryRows(
      categoryId: template.categoryId,
      subTransactions: template.subTransactions,
      isSplit: template.isSplit,
      onCategorySelected: (category) {
        context.read<SetupTemplateFlow>().updateTemplate(
          (t) => t.copyWith(categoryId: category.id),
        );
      },
      onCategoriesSelected: (categories) {
        context.read<SetupTemplateFlow>().updateTemplate(
          (t) => t.copyWith(
            categoryId: null,
            subTransactions: categories
                .map((c) => SubTransactionTemplate(categoryId: c.id))
                .toList(),
          ),
        );
      },
      onSubTransactionUpdated: (value) {
        final index = template.subTransactions.indexWhere((st) => st.id == value.id);
        final newSubtransactions = [
          ...template.subTransactions.sublist(0, index),
          value,
          ...template.subTransactions.sublist(index + 1),
        ];
        context.read<SetupTemplateFlow>().updateTemplate(
          (t) => t.copyWith(subTransactions: newSubtransactions),
        );
      },
    );
  }
}

class _FlagRow extends StatelessWidget {
  const _FlagRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateFlagRow(
      flag: template.flag,
      onChanged: (value) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(flag: value));
      },
    );
  }
}

class _MemoRow extends StatelessWidget {
  const _MemoRow({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return TemplateMemoRow(
      memo: template.memo,
      onChanged: (value) {
        context.read<SetupTemplateFlow>().updateTemplate((t) => t.copyWith(memo: value));
      },
    );
  }
}

class _SaveTemplateButton extends StatelessWidget {
  const _SaveTemplateButton({required this.template});

  final TransactionTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HEdgePadding(
        child: VEdgePadding(
          child: PrimaryButton(
            child: const Text('Save'),
            onPressed: () async {
              await context.read<SetupTemplateFlow>().stepComplete(SetupTransaction());
            },
          ),
        ),
      ),
    );
  }
}
