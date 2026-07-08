import 'package:blackbird/blackbird.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../../ynab_api/_category_group.dart';
import '../../../../domain/models/condition_builder_api.dart';
import '../../../../domain/models/transaction_conditions.dart';

class ChangeTestConditionModal extends HookWidget {
  const ChangeTestConditionModal({
    super.key,
    required this.condition,
    required this.onUpdate,
    required this.payees,
    required this.categoryGroups,
    required this.accounts,
  });

  final TestCondition<TransactionTestPayload, TransactionTestDraft> condition;
  final ValueSetter<List<TestCondition<TransactionTestPayload, TransactionTestDraft>>> onUpdate;
  final List<Payee> payees;
  final List<CategoryGroup> categoryGroups;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    final selectedCondition =
        useState<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>(
          switch (condition) {
            IsTrue(:final test) => IsTrueDraft(test),
            IsNotTrue(:final test) => IsNotTrueDraft(test),
          },
        );

    final selectedTests = useState<List<TransactionTestDraft>>([condition.test]);

    final controller = useTextEditingController();

    final body = switch (selectedTests.value.first) {
      HasFlagColorDraft(:final value) => _FlagBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        initialValue: value,
        onUpdate: (v) {
          if (v.isEmpty) {
            selectedTests.value = [const HasFlagColorDraft(null)];
          } else {
            selectedTests.value = v.map(HasFlagColorDraft.new).toList();
          }
        },
      ),
      HasPayeeIdDraft(:final value) => _PayeeBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        controller: controller,
        initialValue: value,
        options: payees,
        onUpdate: (v) {
          if (v.isEmpty) {
            selectedTests.value = [const HasPayeeIdDraft(null)];
          } else {
            selectedTests.value = v.map(HasPayeeIdDraft.new).toList();
          }
        },
      ),
      HasCategoryIdDraft(:final value) => _CategoryBody(
        initialValue: value,
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        controller: controller,
        options: categoryGroups.categories.toList(),
        onUpdate: (v) {
          if (v.isEmpty) {
            selectedTests.value = [const HasCategoryIdDraft(null)];
          } else {
            selectedTests.value = v.map(HasCategoryIdDraft.new).toList();
          }
        },
      ),
      HasCategoryGroupIdDraft(:final value) => _CategoryGroupBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        controller: controller,
        initialValue: value,
        options: categoryGroups,
        onUpdate: (v) {
          if (v.isEmpty) {
            selectedTests.value = [const HasCategoryGroupIdDraft(null)];
          } else {
            selectedTests.value = v.map(HasCategoryGroupIdDraft.new).toList();
          }
        },
      ),
      HasAccountIdDraft(:final value) => _AccountBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        controller: controller,
        initialValue: value,
        options: accounts,
        onUpdate: (v) {
          if (v.isEmpty) {
            selectedTests.value = [const HasAccountIdDraft(null)];
          } else {
            selectedTests.value = v.map(HasAccountIdDraft.new).toList();
          }
        },
      ),
      ContainsMemoKeywordDraft(:final value) => _MemoKeywordBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
        controller: controller,
        currentValue: value,
        onUpdate: (v) {
          selectedTests.value = [ContainsMemoKeywordDraft(v)];
        },
      ),
      IsIncomeDraft() => _IsIncomeOrExpenseBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
      ),
      IsInflowDraft() => _IsIncomeOrExpenseBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
      ),
      IsExpenseDraft() => _IsIncomeOrExpenseBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
      ),
      IsOutflowDraft() => _IsIncomeOrExpenseBody(
        selectedTests: selectedTests,
        selectedCondition: selectedCondition,
      ),
    };

    final canSave = selectedTests.value.every((test) {
      return switch (test) {
        ContainsMemoKeywordDraft(:final value) => value != null && value.isNotEmpty,
        HasFlagColorDraft(:final value) => value != null,
        HasPayeeIdDraft(:final value) => value != null,
        HasCategoryIdDraft(:final value) => value != null,
        HasCategoryGroupIdDraft(:final value) => value != null,
        HasAccountIdDraft(:final value) => value != null,
        IsIncomeDraft() => true,
        IsInflowDraft() => true,
        IsExpenseDraft() => true,
        IsOutflowDraft() => true,
      };
    });

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Condition'),
          actions: [
            IconButton(
              onPressed: () {
                onUpdate(switch (selectedCondition.value) {
                  IsTrueDraft() =>
                    selectedTests.value
                        .map(IsTrue<TransactionTestPayload, TransactionTestDraft>.new)
                        .toList(),
                  IsNotTrueDraft() =>
                    selectedTests.value
                        .map(IsNotTrue<TransactionTestPayload, TransactionTestDraft>.new)
                        .toList(),
                });
                Navigator.of(context).pop();
              },
              icon: const Icon(Ionicons.checkmark_circle_outline),
            ).visible(canSave),
          ],
        ),
        body: CustomScrollView(
          primary: true,
          slivers: [
            const SliverVSpace(space: Sizes.edgePadding),
            body,
            const SliverToBoxAdapter(
              child: SafeArea(child: VSpace(space: Sizes.edgePadding)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestConditionPicker extends StatelessWidget {
  const _TestConditionPicker({required this.selectedCondition, required this.selectedTest});

  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final ValueNotifier<List<TransactionTestDraft>> selectedTest;

  @override
  Widget build(BuildContext context) {
    final testConditionChoices = <TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>[
      const IsTrueDraft(),
      const IsNotTrueDraft(),
    ];
    return HEdgePadding(
      child: Wrap(
        children: [
          for (final choice in testConditionChoices)
            Builder(
              builder: (context) {
                final isSelected = selectedCondition.value.runtimeType == choice.runtimeType;
                // TODO: Add ChoiceChip custom component
                return ChoiceChip(
                  selected: isSelected,
                  onSelected: (v) {
                    if (v) selectedCondition.value = choice;
                  },
                  label: Text(
                    choice.userFriendlyDescription(selectedTest.value.first),
                    style: TextStyle(
                      color: isSelected
                          ? context
                                .colors
                                .onSelected //
                          : context.colors.foreground,
                    ),
                  ),
                );
              },
            ),
        ].spaced(),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return VEdgePadding(
      padding: Sizes.unit,
      child: HEdgePadding(
        child: OutlinedChild(
          child: HEdgePadding(
            child: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(hintText: hint),
            ),
          ),
        ),
      ),
    );
  }
}

class _TestPicker extends StatelessWidget {
  const _TestPicker({required this.selectedTest});

  final ValueNotifier<List<TransactionTestDraft>> selectedTest;

  @override
  Widget build(BuildContext context) {
    const allTestDraftChoices = [
      HasPayeeIdDraft(),
      HasCategoryIdDraft(),
      HasCategoryGroupIdDraft(),
      HasAccountIdDraft(),
      ContainsMemoKeywordDraft(),
      IsIncomeDraft(),
      IsInflowDraft(),
      IsExpenseDraft(),
      IsOutflowDraft(),
      HasFlagColorDraft(),
    ];
    return HEdgePadding(
      child: Wrap(
        children: [
          for (final choice in allTestDraftChoices)
            Builder(
              builder: (context) {
                final isSelected = selectedTest.value.first.runtimeType == choice.runtimeType;
                // TODO: Add ChoiceChip custom component
                return ChoiceChip(
                  selected: isSelected,
                  onSelected: (v) {
                    if (v) selectedTest.value = [choice];
                  },
                  label: Text(
                    choice.userFriendlyDescription,
                    style: TextStyle(
                      color: isSelected
                          ? context
                                .colors
                                .onSelected //
                          : context.colors.foreground,
                    ),
                  ),
                );
              },
            ),
        ].spaced(),
      ),
    );
  }
}

class _CategoryBody extends HookWidget {
  const _CategoryBody({
    required this.initialValue,
    required this.selectedTests,
    required this.selectedCondition,
    required this.controller,
    required this.options,
    required this.onUpdate,
  });

  final String? initialValue;
  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final TextEditingController controller;
  final List<Category> options;
  final ValueSetter<Set<String>> onUpdate;

  @override
  Widget build(BuildContext context) {
    final updates = useListenable(controller);
    final filtered = options.search(updates.text);
    final currentValues = useState<Set<String>>(Set.from([initialValue].nonNulls));

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return VLayout(
            children: [
              _TestPicker(selectedTest: selectedTests),
              _TestConditionPicker(
                selectedCondition: selectedCondition,
                selectedTest: selectedTests,
              ),
              _TextField(controller: controller, hint: 'Category name'),
            ],
          );
        }
        final correctedIndex = index - 1;
        final choice = filtered.elementAt(correctedIndex);
        final name = choice.name;
        return VLayout(
          spacing: 0,
          children: [
            ListRow(
              visualDensity: VisualDensity.compact,
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              title: Text(name),
              onTap: () {
                if (currentValues.value.contains(choice.id)) {
                  currentValues.value.remove(choice.id);
                } else {
                  currentValues.value.add(choice.id);
                }
                onUpdate(currentValues.value);
              },
              trailing: const Icon(
                Ionicons.checkmark_circle_outline,
              ).visible(currentValues.value.contains(choice.id)),
            ),
            if (correctedIndex != filtered.length - 1) const Divider(),
          ],
        );
      }, childCount: filtered.length + 1),
    );
  }
}

class _CategoryGroupBody extends HookWidget {
  const _CategoryGroupBody({
    required this.selectedTests,
    required this.selectedCondition,
    required this.controller,
    required this.initialValue,
    required this.options,
    required this.onUpdate,
  });

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final TextEditingController controller;
  final String? initialValue;
  final List<CategoryGroup> options;
  final ValueSetter<Set<String>> onUpdate;

  @override
  Widget build(BuildContext context) {
    final updates = useListenable(controller);
    final filtered = options.search(updates.text);
    final currentValues = useState<Set<String>>(Set.from([initialValue].nonNulls));

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return VLayout(
            children: [
              _TestPicker(selectedTest: selectedTests),
              _TestConditionPicker(
                selectedCondition: selectedCondition,
                selectedTest: selectedTests,
              ),
              _TextField(controller: controller, hint: 'Category group name'),
            ],
          );
        }
        final correctedIndex = index - 1;
        final choice = filtered.elementAt(correctedIndex);
        final name = choice.name;
        return VLayout(
          spacing: 0,
          children: [
            ListRow(
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              title: Text(name),
              onTap: () {
                if (currentValues.value.contains(choice.id)) {
                  currentValues.value.remove(choice.id);
                } else {
                  currentValues.value.add(choice.id);
                }
                onUpdate(currentValues.value);
              },
              trailing: const Icon(
                Ionicons.checkmark_circle_outline,
              ).visible(currentValues.value.contains(choice.id)),
            ),
            if (correctedIndex != filtered.length - 1) const Divider(),
          ],
        );
      }, childCount: filtered.length + 1),
    );
  }
}

class _AccountBody extends HookWidget {
  const _AccountBody({
    required this.selectedTests,
    required this.selectedCondition,
    required this.controller,
    required this.initialValue,
    required this.options,
    required this.onUpdate,
  });

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final TextEditingController controller;
  final String? initialValue;
  final List<Account> options;
  final ValueSetter<Set<String>> onUpdate;

  @override
  Widget build(BuildContext context) {
    final updates = useListenable(controller);
    final filtered = options.search(updates.text);
    final currentValues = useState<Set<String>>(Set.from([initialValue].nonNulls));

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return VLayout(
            children: [
              _TestPicker(selectedTest: selectedTests),
              _TestConditionPicker(
                selectedCondition: selectedCondition,
                selectedTest: selectedTests,
              ),
              _TextField(controller: controller, hint: 'Account name'),
            ],
          );
        }
        final correctedIndex = index - 1;
        final choice = filtered.elementAt(correctedIndex);
        final name = choice.name;
        return VLayout(
          spacing: 0,
          children: [
            ListRow(
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              title: Text(name),
              onTap: () {
                if (currentValues.value.contains(choice.id)) {
                  currentValues.value.remove(choice.id);
                } else {
                  currentValues.value.add(choice.id);
                }
                onUpdate(currentValues.value);
              },
              trailing: const Icon(
                Ionicons.checkmark_circle_outline,
              ).visible(currentValues.value.contains(choice.id)),
            ),
            if (correctedIndex != filtered.length - 1) const Divider(),
          ],
        );
      }, childCount: filtered.length + 1),
    );
  }
}

class _PayeeBody extends HookWidget {
  const _PayeeBody({
    required this.selectedTests,
    required this.selectedCondition,
    required this.controller,
    required this.initialValue,
    required this.options,
    required this.onUpdate,
  });

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final TextEditingController controller;
  final String? initialValue;
  final List<Payee> options;
  final ValueSetter<Set<String>> onUpdate;

  @override
  Widget build(BuildContext context) {
    final updates = useListenable(controller);
    final filtered = options.search(updates.text);
    final currentValues = useState<Set<String>>(Set.from([initialValue].nonNulls));

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return VLayout(
            children: [
              _TestPicker(selectedTest: selectedTests),
              _TestConditionPicker(
                selectedCondition: selectedCondition,
                selectedTest: selectedTests,
              ),
              _TextField(controller: controller, hint: 'Payee name'),
            ],
          );
        }
        final correctedIndex = index - 1;
        final choice = filtered.elementAt(correctedIndex);
        final name = choice.name;
        return VLayout(
          spacing: 0,
          children: [
            ListRow(
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              title: Text(name),
              onTap: () {
                if (currentValues.value.contains(choice.id)) {
                  currentValues.value.remove(choice.id);
                } else {
                  currentValues.value.add(choice.id);
                }
                onUpdate(currentValues.value);
              },
              trailing: const Icon(
                Ionicons.checkmark_circle_outline,
              ).visible(currentValues.value.contains(choice.id)),
            ),
            if (correctedIndex != filtered.length - 1) const Divider(),
          ],
        );
      }, childCount: filtered.length + 1),
    );
  }
}

class _MemoKeywordBody extends HookWidget {
  const _MemoKeywordBody({
    required this.selectedTests,
    required this.selectedCondition,
    required this.controller,
    required this.currentValue,
    required this.onUpdate,
  });

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final TextEditingController controller;
  final String? currentValue;
  final ValueSetter<String> onUpdate;

  @override
  Widget build(BuildContext context) {
    final updates = useListenable(controller);
    useEffect(() {
      if (currentValue != updates.text) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onUpdate(updates.text);
        });
      }
      return null;
    }, [updates.text]);

    return SliverList(
      delegate: SliverChildListDelegate([
        _TestPicker(selectedTest: selectedTests),
        const VSpace(),
        _TestConditionPicker(selectedCondition: selectedCondition, selectedTest: selectedTests),
        const VSpace(),
        _TextField(controller: controller, hint: 'Memo keyword'),
      ]),
    );
  }
}

class _FlagBody extends HookWidget {
  const _FlagBody({
    required this.selectedTests,
    required this.selectedCondition,
    required this.initialValue,
    required this.onUpdate,
  });

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;
  final String? initialValue;
  final ValueSetter<Set<String>> onUpdate;

  @override
  Widget build(BuildContext context) {
    final currentValues = useState<Set<String>>(Set.from([initialValue].nonNulls));
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return VLayout(
            children: [
              _TestPicker(selectedTest: selectedTests),
              _TestConditionPicker(
                selectedCondition: selectedCondition,
                selectedTest: selectedTests,
              ),
            ],
          );
        }
        final correctedIndex = index - 1;
        final choice = Flag.values.elementAt(correctedIndex);
        final name = choice.name;
        return VLayout(
          spacing: 0,
          children: [
            ListRow(
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              title: Text(name),
              onTap: () {
                if (currentValues.value.contains(choice.name)) {
                  currentValues.value.remove(choice.name);
                } else {
                  currentValues.value.add(choice.name);
                }
                onUpdate(currentValues.value);
              },
              trailing: const Icon(
                Ionicons.checkmark_circle_outline,
              ).visible(currentValues.value.contains(choice.name)),
            ),
            if (correctedIndex != Flag.values.length - 1) const Divider(),
          ],
        );
      }, childCount: Flag.values.length + 1),
    );
  }
}

class _IsIncomeOrExpenseBody extends HookWidget {
  const _IsIncomeOrExpenseBody({required this.selectedTests, required this.selectedCondition});

  final ValueNotifier<List<TransactionTestDraft>> selectedTests;
  final ValueNotifier<TestConditionDraft<TransactionTestPayload, TransactionTestDraft>>
  selectedCondition;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _TestConditionPicker(selectedCondition: selectedCondition, selectedTest: selectedTests),
        const VSpace(),
        _TestPicker(selectedTest: selectedTests),
      ]),
    );
  }
}
