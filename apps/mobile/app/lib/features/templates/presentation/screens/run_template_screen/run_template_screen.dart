import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../app/scaffold_messenger/scaffold_messenger.dart';
import '../../../../../utils/_build_context.dart';
import '../../../../auth/presentation/screens/write_access_screen/widgets/write_access_guard/write_access_guard.dart';
import '../../../domain/models/legacy_transaction_template.dart';
import '../../../domain/models/transaction_template.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_account_row.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_amount_row.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_category_rows.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_flag_row.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_inflow_row.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_memo_row.dart';
import '../../setup_template/screens/setup_template_screen/widgets/template_payee_row.dart';
import 'run_template_screen_state.dart';

class RunTemplateScreen extends StatelessWidget {
  const RunTemplateScreen({super.key, required this.templateId});

  final String templateId;

  static String buildRoute(String templateId) {
    return '/budget/run_template/$templateId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run template')),
      body: BlocProvider(
        create: (context) => RunTemplateScreenCubit.create(templateId),
        child: BlocBuilder<RunTemplateScreenCubit, RunTemplateScreenState>(
          builder: (context, state) {
            final (template, isLoading, error) = state.template.details();

            if (isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (error != null || template == null) {
              return Center(child: Text('Error loading template: $error'));
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
                _CreateTransactionButton(template: template),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AmountRow extends HookWidget {
  const _AmountRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateAmountRow(
      amount: template.amount,
      isInflow: template.isInflow,
      onChanged: (value) {
        context.read<RunTemplateScreenCubit>().updateTemplate((t) => t.copyWith(amount: value));
      },
    );
  }
}

class _InflowRow extends HookWidget {
  const _InflowRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateInflowRow(
      value: template.isInflow,
      onChanged: (value) {
        context.read<RunTemplateScreenCubit>().updateTemplate((t) => t.copyWith(isInflow: value));
      },
    );
  }
}

class _PayeeRow extends StatelessWidget {
  const _PayeeRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplatePayeeRow(
      payeeId: template.payeeId,
      onSelected: (payee) {
        context.read<RunTemplateScreenCubit>().updateTemplate((t) => t.copyWith(payeeId: payee.id));
      },
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateAccountRow(
      accountId: template.accountId,
      onSelected: (account) {
        context.read<RunTemplateScreenCubit>().updateTemplate(
          (t) => t.copyWith(accountId: account.id),
        );
      },
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateCategoryRows(
      categoryId: template.categoryId,
      subTransactions: template.subTransactions,
      isSplit: template.isSplit,
      onCategorySelected: (category) {
        context.read<RunTemplateScreenCubit>().updateTemplate(
          (t) => t.copyWith(categoryId: category.id),
        );
      },
      onCategoriesSelected: (categories) {
        context.read<RunTemplateScreenCubit>().updateTemplate(
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
        context.read<RunTemplateScreenCubit>().updateTemplate(
          (t) => t.copyWith(subTransactions: newSubtransactions),
        );
      },
    );
  }
}

class _FlagRow extends StatelessWidget {
  const _FlagRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateFlagRow(
      flag: template.flag,
      onChanged: (value) {
        context.read<RunTemplateScreenCubit>().updateTemplate((t) => t.copyWith(flag: value));
      },
    );
  }
}

class _MemoRow extends StatelessWidget {
  const _MemoRow({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    return TemplateMemoRow(
      memo: template.memo,
      onChanged: (value) {
        context.read<RunTemplateScreenCubit>().updateTemplate((t) => t.copyWith(memo: value));
      },
    );
  }
}

class _CreateTransactionButton extends StatelessWidget {
  const _CreateTransactionButton({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    final canCreate = template.canCreateTransaction;

    Future<void> onTap() async {
      final result = await context.read<RunTemplateScreenCubit>().createTransaction();
      if (!context.mounted) return;

      switch (result) {
        case Ok<String, Exception>():
          Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            rootScaffoldKey.showSnackBar(
              SnackBar(content: Text('Template ${template.name} executed successfully')),
            );
          });
        case Err<String, Exception>(:final error):
          context.showToast(Text('Error running ${template.name}: $error'));
      }
    }

    return Visibility(
      visible: canCreate,
      child: SafeArea(
        child: HEdgePadding(
          child: VEdgePadding(
            child: WriteAccessGuard(
              isBlocking: true,
              onAccessGranted: onTap,
              child: PrimaryButton(onPressed: onTap, child: const Text('Create transaction')),
            ),
          ),
        ),
      ),
    );
  }
}
