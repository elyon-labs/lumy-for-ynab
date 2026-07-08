import 'dart:async';

import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart' hide Offset;
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../app/di.dart';
import '../../../../../../common/domain/accounts/accounts_repository.dart';
import '../../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../../common/domain/categories/categories_repository.dart';
import '../../../../../../common/domain/categories/category_groups_view.dart';
import '../../../../../../common/domain/payees/payees_repository.dart';
import '../../../../../../common/domain/payees/payees_view.dart';
import '../../../../../../common/domain/transactions/filters.dart';
import '../../../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../../../common/domain/transactions/transactions_view.dart';
import '../../../../../../common/domain/worker/_base_transactions_async.dart';
import '../../../../../../common/domain/worker/_transactions_async.dart';
import '../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../common/presentation/markdown.dart';
import '../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../../utils/_T.dart';
import '../../../../../../utils/_cubit.dart';
import '../../../../../../utils/hooks/hook_bloc_builder.dart';
import '../../../../../../utils/sort.dart';
import '../../../../../../ynab_api/_category_group.dart';
import '../../../../domain/models/condition_builder_api.dart';
import '../../../../domain/models/transaction_conditions.dart';
import '../screens/spend_tracker_query_results_screen.dart';
import 'add_condition_bottom_sheet.dart';
import 'change_test_condition_modal.dart';

class ConditionBuilderState {
  ConditionBuilderState({
    required this.payees,
    required this.categoryGroups,
    required this.transactions,
    required this.accounts,
  });

  factory ConditionBuilderState.initial() {
    return ConditionBuilderState(payees: [], categoryGroups: [], transactions: [], accounts: []);
  }

  final List<Payee> payees;
  final List<CategoryGroup> categoryGroups;
  final List<PastTransaction> transactions;
  final List<Account> accounts;
}

class ConditionBuilderCubit extends Cubit<ConditionBuilderState> {
  ConditionBuilderCubit({
    required this.transactionsRepo,
    required this.payeesRepo,
    required this.categoriesRepo,
    required this.accountsRepo,
  }) : super(ConditionBuilderState.initial()) {
    fetch();
  }

  factory ConditionBuilderCubit.create() {
    return ConditionBuilderCubit(
      transactionsRepo: inject(),
      payeesRepo: inject(),
      categoriesRepo: inject(),
      accountsRepo: inject(),
    );
  }

  final TransactionsRepository transactionsRepo;
  final PayeesRepository payeesRepo;
  final CategoriesRepository categoriesRepo;
  final AccountsRepository accountsRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = Rx.combineLatest4(
      transactionsRepo.watch(TransactionsView.all()),
      payeesRepo.watch(const AllPayees()),
      categoriesRepo.watchCategoryGroups(const AllCategoryGroups()),
      accountsRepo.watch(const AllAccounts()),
      (transactions, payees, categoryGroups, accounts) => ConditionBuilderState(
        payees: payees,
        categoryGroups: categoryGroups,
        transactions: transactions,
        accounts: accounts,
      ),
    ).listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ConditionBuilder extends HookWidget {
  const ConditionBuilder({super.key, required this.onSave, this.initialCondition});

  final ValueSetter<TransactionCondition> onSave;
  final NestedCondition<TransactionTestPayload, TransactionTest>? initialCondition;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConditionBuilderCubit.create(),
      child: HookBlocBuilder<ConditionBuilderCubit, ConditionBuilderState>(
        builder: (context, state) {
          final condition = useState<RootTransactionConditionDraft>(
            initialCondition?.toDraft() ?? And(const []),
          );

          final rows = condition.value.buildQueryRows(
            onUpdate: (value) {
              condition.value = value;
            },
            payees: state.payees,
            categoryGroups: state.categoryGroups,
            accounts: state.accounts,
          );

          bool canSave() {
            return condition.value.conditions.isNotEmpty &&
                condition.value.invalidReasons.isEmpty &&
                condition.value.allTestDraftsAreValid();
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Build query'),
              actions: !canSave()
                  ? []
                  : [
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          onSave(condition.value.finalize());
                        },
                        icon: const Icon(Ionicons.checkmark_circle_outline),
                      ),
                    ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
                  child: VLayout(spacing: 0, children: rows),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: QueryResultsCard(condition: condition, canSave: canSave()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

TransactionFilter _queryFilter(TransactionCondition condition, List<CategoryGroup> categoryGroups) {
  return (txn, parent) {
    return condition.evaluateSafe((txn: txn, parent: parent, groups: categoryGroups));
  };
}

class QueryResultsCard extends HookWidget {
  const QueryResultsCard({super.key, required this.condition, required this.canSave});

  final ValueNotifier<RootTransactionConditionDraft> condition;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final matches = useState(<LocalDate, List<PastTransaction>>{});
    final controller = useAnimationController(duration: 300.milliseconds);
    final matchesLength = matches.value.values.flattenSafe().length;
    final transactions = context.watch<ConditionBuilderCubit>().state.transactions;
    final categoryGroups = context.watch<ConditionBuilderCubit>().state.categoryGroups;
    useEffect(() {
      Future<void> runQuery() async {
        if (!canSave) {
          await controller.reverse();
          return;
        }
        final finalized = condition.value.finalize();
        final results = await transactions.filter(_queryFilter(finalized, categoryGroups));
        matches.value = await results.groupByDate(dateDesc);
        if (canSave) {
          await controller.forward();
        } else {
          await controller.reverse();
        }
      }

      unawaited(runQuery());
      return null;
    }, [condition.value, transactions, categoryGroups]);
    final tile = Animate(
      controller: controller,
      autoPlay: false,
      effects: [
        ScaleEffect(
          duration: 300.milliseconds,
          begin: Offset.zero,
          end: const Offset(1, 1),
          curve: Curves.easeInOut,
        ),
      ],
      child: VEdgePadding(
        child: SafeArea(
          child: Card(
            color: context.colors.secondary,
            child: InkWell(
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
              onTap: matchesLength == 0
                  ? null
                  : () async => Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) =>
                            SpendTrackerQueryResultsScreen(transactions: matches.value),
                      ),
                    ),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.edgePadding),
                child: Text(
                  'Matches $matchesLength transactions',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.onSecondary),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return HEdgePadding(child: tile);
  }
}

extension on RootTransactionConditionDraft {
  List<Widget> buildQueryRows({
    required ValueSetter<NestedCondition<TransactionTestPayload, TransactionTestDraft>> onUpdate,
    required List<Payee> payees,
    required List<CategoryGroup> categoryGroups,
    required List<Account> accounts,
  }) {
    List<Widget> buildInternal(
      Condition<TransactionTestPayload, TransactionTestDraft> condition, [
      NestedCondition<TransactionTestPayload, TransactionTestDraft>? parent,
      int depth = 0,
      List<Condition<TransactionTestPayload, TransactionTestDraft>> siblings = const [],
    ]) {
      final row = switch (condition) {
        TestCondition() => TestConditionRow(
          rootCondition: this,
          parent: parent!,
          condition: condition,
          onUpdate: onUpdate,
          siblings: siblings
              .whereType<TestCondition<TransactionTestPayload, TransactionTestDraft>>()
              .toList(),
          payees: payees,
          categoryGroups: categoryGroups,
          accounts: accounts,
          depth: depth,
        ),
        NestedCondition() => NestedConditionRow(
          rootCondition: this,
          parent: parent ?? this,
          condition: condition,
          onUpdate: onUpdate,
        ),
      };

      final withPadding = Padding(
        padding: depth == 0
            ? EdgeInsets
                  .zero //
            : EdgeInsets.only(left: Sizes.unit * 2 * depth),
        child: row,
      );

      return switch (condition) {
        TestCondition<TransactionTestPayload, TransactionTestDraft>() => [withPadding],
        NestedCondition<TransactionTestPayload, TransactionTestDraft>(:final conditions) => [
          withPadding,
          ...conditions.expand(
            (c) => buildInternal(
              c,
              condition,
              depth + 1,
              conditions.whereNot((c) => c == condition).toList(),
            ),
          ),
        ],
      };
    }

    return buildInternal(this);
  }
}

class NestedConditionRow extends HookWidget {
  const NestedConditionRow({
    super.key,
    required this.rootCondition,
    required this.parent,
    required this.condition,
    required this.onUpdate,
  });
  final RootTransactionConditionDraft rootCondition;
  final NestedCondition<TransactionTestPayload, TransactionTestDraft> condition;
  final NestedCondition<TransactionTestPayload, TransactionTestDraft> parent;
  final ValueSetter<RootTransactionConditionDraft> onUpdate;

  @override
  Widget build(BuildContext context) {
    final conditions = condition.conditions;
    final canDelete = condition != rootCondition;
    final menuVisible = useState(false);
    void replace(NestedCondition<TransactionTestPayload, TransactionTestDraft> value) {
      menuVisible.value = false;
      onUpdate(rootCondition.replace(condition, value));
    }

    final invalidReasons = condition.invalidReasons;
    final testDraftsAreValid = condition.conditions.every((c) => c.allTestDraftsAreValid());

    final canAdd = invalidReasons.isEmpty && testDraftsAreValid;

    final addButton = IconButton(
      onPressed: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => AddConditionBottomSheet(
            onAdd: (type) {
              switch (type) {
                case AddConditionType.and:
                  replace(condition.add(And(const [])));
                case AddConditionType.or:
                  replace(condition.add(Or(const [])));
                case AddConditionType.child:
                  replace(condition.add(IsTrue(const HasCategoryIdDraft())));
              }
            },
          ),
        );
      },
      icon: const Icon(Ionicons.add_circle_outline),
    ).visible(canAdd, maintainSize: true);

    final errorButton = IconButton(
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      icon: const Icon(Ionicons.alert_circle_outline),
      onPressed: () async {
        final message = invalidReasons.isNotEmpty
            ? '''
This condition is invalid for the following reasons:
${invalidReasons.map((e) => '- ${e.description}').join('\n')}
'''
            : 'A child condition is incomplete.';
        await context.showGenericDialog(
          title: const Text('Invalid condition'),
          body: Markdown(data: message),
          buttons: [DialogActionButton(text: 'Got it')],
        );
      },
    ).visible(!canAdd, maintainSize: true);

    final row = ListRow(
      shape: !canAdd
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
              side: BorderSide(color: context.colors.error, width: 2),
            )
          : null,
      title: NestedConditionType(condition: condition),
      onTap: () => replace(switch (condition) {
        And<TransactionTestPayload, TransactionTestDraft>() => Or(conditions),
        Or<TransactionTestPayload, TransactionTestDraft>() => And(conditions),
      }),
      trailing: canAdd ? addButton : errorButton,
    );

    if (!canDelete) return row;
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const BehindMotion(),
        children: [
          CustomSlidableAction(
            backgroundColor: context.colors.body,
            onPressed: (_) => {onUpdate(rootCondition.replace(parent, parent.remove(condition)))},
            child: const Icon(Ionicons.trash_outline),
          ),
        ],
      ),
      child: row,
    );
  }
}

class NestedConditionType extends StatelessWidget {
  const NestedConditionType({super.key, required this.condition});
  final NestedCondition<TransactionTestPayload, TransactionTestDraft> condition;

  @override
  Widget build(BuildContext context) {
    final prefix = switch (condition) {
      And<TransactionTestPayload, TransactionTestDraft>() => 'All',
      Or<TransactionTestPayload, TransactionTestDraft>() => 'Any',
    };
    return Text('$prefix of the child conditions are met');
  }
}

class TestConditionRow extends StatelessWidget {
  const TestConditionRow({
    super.key,
    required this.rootCondition,
    required this.parent,
    required this.condition,
    required this.siblings,
    required this.onUpdate,
    required this.payees,
    required this.categoryGroups,
    required this.accounts,
    required this.depth,
  });

  final RootTransactionConditionDraft rootCondition;
  final NestedCondition<TransactionTestPayload, TransactionTestDraft> parent;
  final TestCondition<TransactionTestPayload, TransactionTestDraft> condition;
  final List<TestCondition<TransactionTestPayload, TransactionTestDraft>> siblings;
  final ValueSetter<RootTransactionConditionDraft> onUpdate;
  final List<Payee> payees;
  final List<CategoryGroup> categoryGroups;
  final List<Account> accounts;
  final int depth;

  @override
  Widget build(BuildContext context) {
    void replaceThisCondition(
      List<TestCondition<TransactionTestPayload, TransactionTestDraft>> value,
    ) {
      onUpdate(rootCondition.replace(condition, value.first, additional: value.skip(1).toList()));
    }

    void removeTestCondition() {
      onUpdate(rootCondition.replace(parent, parent.remove(condition)));
    }

    final testConditionDescription = TestConditionDescription(condition: condition);
    final testDescription = TestDescription(condition: condition);
    final testValue = TestValue(
      condition: condition,
      payees: payees,
      categoryGroups: categoryGroups,
      accounts: accounts,
    );
    final requiresTestValue = switch (condition.test) {
      MatchesValueDraft() => true,
      MatchesLogicDraft() => false,
    };
    final testDescriptionFirst = switch (condition.test) {
      MatchesValueDraft() => true,
      MatchesLogicDraft() => false,
    };
    final duplicates = parent.duplicates();
    final isDuplicate = duplicates.contains(condition);

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const BehindMotion(),
        children: [
          CustomSlidableAction(
            backgroundColor: context.colors.body,
            onPressed: (_) => removeTestCondition(),
            child: const Icon(Ionicons.trash_bin_outline),
          ),
        ],
      ),
      child: ListRow(
        shape: isDuplicate
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                side: BorderSide(color: context.colors.error, width: 2),
              )
            : null,
        title: Row(
          children: [
            if (testDescriptionFirst) testDescription,
            testConditionDescription,
            if (!testDescriptionFirst) testDescription,
          ].spaced(),
        ),
        subtitle: requiresTestValue ? testValue : null,
        implicitTrailing: false,
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => ChangeTestConditionModal(
                condition: condition,
                onUpdate: replaceThisCondition,
                payees: payees,
                categoryGroups: categoryGroups,
                accounts: accounts,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TestConditionDescription extends StatelessWidget {
  const TestConditionDescription({super.key, required this.condition});
  final TestCondition<TransactionTestPayload, TransactionTestDraft> condition;

  @override
  Widget build(BuildContext context) {
    final isTrue = switch (condition) {
      IsTrue<TransactionTestPayload, TransactionTestDraft>() => true,
      IsNotTrue<TransactionTestPayload, TransactionTestDraft>() => false,
    };
    final text = switch (condition.test) {
      ContainsMemoKeywordDraft() => isTrue ? 'contains' : 'does not contain',
      _ => isTrue ? 'is' : 'is not',
    };
    return Text(text);
  }
}

class TestDescription extends StatelessWidget {
  const TestDescription({super.key, required this.condition});
  final TestCondition<TransactionTestPayload, TransactionTestDraft> condition;

  @override
  Widget build(BuildContext context) {
    final valueType = switch (condition.test) {
      HasFlagColorDraft() => 'Flag color',
      HasPayeeIdDraft() => 'Payee',
      HasCategoryIdDraft() => 'Category',
      HasCategoryGroupIdDraft() => 'Category group',
      HasAccountIdDraft() => 'Account',
      ContainsMemoKeywordDraft() => 'Memo',
      IsIncomeDraft() => 'Income',
      IsInflowDraft() => 'Inflow',
      IsExpenseDraft() => 'Expense',
      IsOutflowDraft() => 'Outflow',
    };
    return Text(valueType);
  }
}

class TestValue extends HookWidget {
  const TestValue({
    super.key,
    required this.condition,
    required this.payees,
    required this.categoryGroups,
    required this.accounts,
  });

  final TestCondition<TransactionTestPayload, TransactionTestDraft> condition;
  final List<Payee> payees;
  final List<CategoryGroup> categoryGroups;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    final value = switch (condition.test) {
      HasFlagColorDraft(:final value) => value,
      HasPayeeIdDraft(:final value) =>
        value == null ? value : payees.firstWhereOrNull((p) => p.id == value)?.name,
      HasCategoryIdDraft(:final value) =>
        value == null
            ? value
            : categoryGroups.categories.firstWhereOrNull((c) => c.id == value)?.name,
      HasAccountIdDraft(:final value) =>
        value == null ? value : accounts.firstWhereOrNull((a) => a.id == value)?.name,
      HasCategoryGroupIdDraft(:final value) =>
        value == null ? value : categoryGroups.firstWhereOrNull((g) => g.id == value)?.name,
      ContainsMemoKeywordDraft(:final value) => value,
      IsIncomeDraft() => null,
      IsInflowDraft() => null,
      IsExpenseDraft() => null,
      IsOutflowDraft() => null,
    };

    return Text(value ?? '---', maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}

extension on InvalidConditionTreeReason {
  String get description {
    return switch (this) {
      InvalidConditionTreeReason.emptyChild => 'A child condition is incomplete',
      InvalidConditionTreeReason.duplicate => 'Contains duplicate conditions',
    };
  }
}
