import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../common/presentation/bottom_glow_container.dart';
import '../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../../../utils/_build_context.dart';
import '../../../../../../../ynab_api/_category_group.dart';
import '../../../../../../../ynab_api/_flag.dart';
import '../../../../../domain/models/spend_tracker_draft.dart';
import '../../../../../domain/models/transaction_conditions.dart';
import '../../state/create_spend_tracker_cubit.dart';
import '../../widgets/condition_builder.dart';
import '../name_spend_tracker_screen.dart';
import 'choose_spend_tracker_source_screen_cubit.dart';
import 'choose_spend_tracker_source_screen_state.dart';

class ChooseSpendTrackerSourceScreen extends StatelessWidget {
  const ChooseSpendTrackerSourceScreen({super.key, required this.onContinue});

  final ValueSetter<String> onContinue;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<CreateSpendTrackerCubit>().state.draft;
    return BlocProvider(
      create: (_) => ChooseSpendTrackerSourceScreenCubit.create(),
      child: switch (draft.type!) {
        Single(:final type) => AppScreen(
          title: _Title(type),
          child: _Body(onContinue: onContinue, testType: type),
        ),
        Multi() => ConditionBuilder(
          onSave: (condition) {
            context.read<CreateSpendTrackerCubit>().setCondition(condition);
            GoRouter.of(context).go(NameSpendTrackerScreen.route);
          },
        ),
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.testType);
  final TransactionTestType testType;

  @override
  Widget build(BuildContext context) {
    return switch (testType) {
      TransactionTestType.hasFlagColor => const Text('Choose flag'),
      TransactionTestType.hasPayeeId => const Text('Search payees'),
      TransactionTestType.hasCategoryId => const Text('Search categories'),
      TransactionTestType.hasCategoryGroupId => const Text('Search category groups'),
      TransactionTestType.hasMemoKeyword => const Text('Specify memo'),
      _ => throw Exception('Invalid type $testType for Single type'),
    };
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.onContinue, required this.testType});

  final TransactionTestType testType;
  final ValueSetter<String> onContinue;

  @override
  Widget build(BuildContext context) {
    return switch (testType) {
      TransactionTestType.hasFlagColor => _FlagSearch(onContinue: onContinue),
      TransactionTestType.hasPayeeId => _PayeeSearch(onContinue: onContinue),
      TransactionTestType.hasCategoryId => _CategorySearch(onContinue: onContinue),
      TransactionTestType.hasCategoryGroupId => _CategoryGroupsSearch(onContinue: onContinue),
      TransactionTestType.hasMemoKeyword => _MemoSearch(onContinue: onContinue),
      _ => throw Exception('Invalid type $testType for Single type'),
    };
  }
}

class _CategorySearch extends HookWidget {
  const _CategorySearch({required this.onContinue});
  final ValueSetter<String> onContinue;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final updates = useListenable(controller);
    final selectedCategory = useState<Category?>(null);
    final textFieldRow = _TextFieldRow(
      controller: controller,
      labelText: 'Category name',
      hintText: 'e.g Groceries',
    );

    return BlocBuilder<ChooseSpendTrackerSourceScreenCubit, ChooseSpendTrackerSourceScreenState>(
      builder: (context, state) {
        final filteredCategories = state.categoryGroups.categories.where((category) {
          final name = category.name.toLowerCase();
          final search = updates.text.toLowerCase();
          final isDeleted = category.isDeleted;
          return name.contains(search) && !isDeleted;
        }).toList();
        final rows = [
          textFieldRow,
          for (final c in filteredCategories) ...[
            _ItemRow(
              title: c.name,
              isSelected: selectedCategory.value == c,
              isAnySelected: selectedCategory.value != null,
              onTap: () => selectedCategory.value = c,
              isLastInList: c == filteredCategories.last,
            ),
            if (c != filteredCategories.last) const Divider(),
          ],
        ];
        return VLayout(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverVSpace(space: Sizes.edgePadding),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: rows.length,
                      (context, index) => rows[index],
                    ),
                  ),
                ],
              ),
            ),
            _SaveButton(
              canProceed: selectedCategory.value != null,
              sourceId: () => selectedCategory.value!.id,
              selectedValueName: () => selectedCategory.value!.name,
              defaultName: () => 'Choose a category',
              onContinue: onContinue,
            ),
          ],
        );
      },
    );
  }
}

class _CategoryGroupsSearch extends HookWidget {
  const _CategoryGroupsSearch({required this.onContinue});
  final ValueSetter<String> onContinue;
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final updates = useListenable(controller);
    final selectedCategoryGroup = useState<CategoryGroup?>(null);

    return BlocBuilder<ChooseSpendTrackerSourceScreenCubit, ChooseSpendTrackerSourceScreenState>(
      builder: (context, state) {
        final textFieldRow = _TextFieldRow(
          controller: controller,
          labelText: 'Category group name',
          hintText: 'e.g Bills',
        );

        final filteredCategoryGroups = state.categoryGroups.where((categoryGroup) {
          final name = categoryGroup.name.toLowerCase();
          final search = updates.text.toLowerCase();
          final isDeleted = categoryGroup.isDeleted;
          return name.contains(search) && !isDeleted;
        }).toList();
        final rows = [
          textFieldRow,
          for (final c in filteredCategoryGroups) ...[
            _ItemRow(
              title: c.name,
              isSelected: selectedCategoryGroup.value == c,
              isAnySelected: selectedCategoryGroup.value != null,
              onTap: () => selectedCategoryGroup.value = c,
              isLastInList: c == filteredCategoryGroups.last,
            ),
            if (c != filteredCategoryGroups.last) const Divider(),
          ],
        ];
        return VLayout(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: rows.length, (context, index) {
                      return rows[index];
                    }),
                  ),
                ],
              ),
            ),
            _SaveButton(
              canProceed: selectedCategoryGroup.value != null,
              sourceId: () => selectedCategoryGroup.value!.id,
              selectedValueName: () => selectedCategoryGroup.value!.name,
              defaultName: () => 'Choose a category group',
              onContinue: onContinue,
            ),
          ],
        );
      },
    );
  }
}

class _PayeeSearch extends HookWidget {
  const _PayeeSearch({required this.onContinue});
  final ValueSetter<String> onContinue;
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final updates = useListenable(controller);
    final selectedPayee = useState<Payee?>(null);
    final textFieldRow = _TextFieldRow(
      controller: controller,
      labelText: 'Payee name',
      hintText: 'e.g Amazon',
    );
    return BlocBuilder<ChooseSpendTrackerSourceScreenCubit, ChooseSpendTrackerSourceScreenState>(
      builder: (context, state) {
        final filteredPayees = state.payees.where((payee) {
          final name = payee.name.toLowerCase();
          final search = updates.text.toLowerCase();
          final isDeleted = payee.isDeleted;
          return name.contains(search) && !isDeleted;
        }).toList()..sortBy((payee) => payee.name);
        final rows = [
          textFieldRow,
          for (final p in filteredPayees) ...[
            _ItemRow(
              title: p.name,
              isSelected: selectedPayee.value == p,
              isAnySelected: selectedPayee.value != null,
              onTap: () => selectedPayee.value = p,
              isLastInList: p == filteredPayees.last,
            ),
            if (p != filteredPayees.last) const Divider(),
          ],
        ];
        return VLayout(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: rows.length, (context, index) {
                      return rows[index];
                    }),
                  ),
                ],
              ),
            ),
            _SaveButton(
              canProceed: selectedPayee.value != null,
              sourceId: () => selectedPayee.value!.id,
              selectedValueName: () => selectedPayee.value!.name,
              defaultName: () => 'Choose a payee',
              onContinue: onContinue,
            ),
          ],
        );
      },
    );
  }
}

class _MemoSearch extends HookWidget {
  const _MemoSearch({required this.onContinue});
  final ValueSetter<String> onContinue;
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final updates = useListenable(controller);
    final spanTheme = context.text.body;
    final rows = [
      _TextFieldRow(
        controller: controller,
        labelText: 'Memo keyword',
        hintText: 'e.g #MyCoolProject',
      ),
      _SearchDescriptionRow(
        isVisible: updates.text.isNotEmpty,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Track all transactions with memos including the phrase: ',
                style: spanTheme,
              ),
              TextSpan(
                text: updates.text,
                style: spanTheme.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ];
    return VLayout(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: rows.length, (context, index) {
                  final item = rows[index];
                  return item.build(context);
                }),
              ),
            ],
          ),
        ),
        _SaveButton(
          canProceed: updates.text.isNotEmpty,
          sourceId: () => updates.text,
          selectedValueName: () => updates.text,
          defaultName: () => 'Specify a memo',
          onContinue: onContinue,
        ),
      ],
    );
  }
}

class _FlagSearch extends HookWidget {
  const _FlagSearch({required this.onContinue});
  final ValueSetter<String> onContinue;
  @override
  Widget build(BuildContext context) {
    final selectedFlag = useState<Flag?>(null);

    final rows = [
      for (final e in Flag.values) ...[
        _ItemRow(
          title: e.name.capitalize(),
          isSelected: selectedFlag.value == e,
          isAnySelected: selectedFlag.value != null,
          onTap: () => selectedFlag.value = e,
          isLastInList: e == Flag.values.last,
          leading: e.icon,
        ),
        if (e != Flag.values.last) const Divider(),
      ],
    ];

    return VLayout(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: rows.length, (context, index) {
                  final item = rows[index];
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: Sizes.edgePadding),
                      child: item.build(context),
                    );
                  }
                  return item.build(context);
                }),
              ),
            ],
          ),
        ),
        _SaveButton(
          canProceed: selectedFlag.value != null,
          sourceId: () => selectedFlag.value!.name,
          selectedValueName: () => '${selectedFlag.value!.name.capitalize()} flag',
          defaultName: () => 'Choose a flag',
          onContinue: onContinue,
        ),
      ],
    );
  }
}

// ignore: unused_element
class _LoadingRow extends StatelessWidget {
  const _LoadingRow();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Sizes.edgePadding),
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

// ignore: unused_element
class _ErrorRow extends StatelessWidget {
  const _ErrorRow();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Sizes.edgePadding),
      child: Center(child: Text('Oops! Something went wrong')),
    );
  }
}

class _SearchDescriptionRow extends StatelessWidget {
  const _SearchDescriptionRow({required this.child, required this.isVisible});
  final Widget child;
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.unit * 3.5, vertical: Sizes.unit),
      child: child,
    ).visible(isVisible);
  }
}

class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({required this.controller, required this.labelText, required this.hintText});
  final String labelText;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(
      child: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.unit),
        child: OutlinedChild(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
            child: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: hintText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.title,
    required this.isSelected,
    required this.isAnySelected,
    required this.onTap,
    required this.isLastInList,
    this.leading,
  });
  final String title;
  final bool isSelected;
  final bool isAnySelected;
  final VoidCallback onTap;
  final bool isLastInList;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      visualDensity: VisualDensity.compact,
      externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
      title: Text(title),
      trailing: const Icon(Ionicons.checkmark_circle_outline).visible(isSelected),
      onTap: onTap,
      leading: leading,
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.canProceed,
    required this.onContinue,
    required this.sourceId,
    required this.selectedValueName,
    required this.defaultName,
  });

  final bool canProceed;
  final ValueSetter<String> onContinue;
  final ValueGetter<String> sourceId;
  final ValueGetter<String> selectedValueName;
  final ValueGetter<String> defaultName;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<CreateSpendTrackerCubit>().state.draft;
    return BottomGlowContainer(
      child: PrimaryButton(
        onPressed: !canProceed
            ? null
            : () async {
                switch (draft.type!) {
                  case Single(:final type):
                    context.read<CreateSpendTrackerCubit>().setName(selectedValueName());
                    context.read<CreateSpendTrackerCubit>().setCondition(
                      IsTrue(type.toTest(sourceId())),
                    );
                    final result = await context.read<CreateSpendTrackerCubit>().save();
                    if (context.mounted) {
                      result.when(
                        ok: onContinue,
                        err: (err) {
                          context.showToast(const Text('Oops! Something went wrong'));
                        },
                      );
                    }
                  case Multi():
                }
              },
        child: Text(
          !canProceed ? defaultName() : 'Track ${selectedValueName()}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
