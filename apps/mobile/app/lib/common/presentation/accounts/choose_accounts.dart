import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../ynab_api/_account.dart';
import '../design_system/list_row.dart';
import '../design_system/section_body.dart';
import '../design_system/section_header.dart';

class ChooseAccounts extends HookWidget {
  const ChooseAccounts({
    super.key,
    required this.selectedAccountIds,
    required this.options,
    this.allowSelectAll = true,
    this.showAccountStatusHeaders = true,
  });

  final ValueNotifier<List<String>> selectedAccountIds;
  final Iterable<Account> options;
  final bool allowSelectAll;
  final bool showAccountStatusHeaders;

  @override
  Widget build(BuildContext context) {
    Iterable<Account> sorted(Iterable<Account> src) sync* {
      final opened = src.whereOpen();
      final onBudget = src.whereOnBudget();
      final seen = <Account>{};
      final openedOnBudget = opened.toSet().intersection(onBudget.toSet());
      yield* openedOnBudget.where(seen.add);
      yield* opened.where(seen.add);
      yield* onBudget.where(seen.add);
      yield* src.where(seen.add);
    }

    final open = sorted(options.whereOpen());
    final closed = sorted(options.whereClosed());

    final optionsSorted = [...open, ...closed];

    _ItemRow buildRow(Account account) {
      return _ItemRow(
        name: account.name,
        isSelected: selectedAccountIds.value.contains(account.id),
        onChanged: (value) {
          if (value && !selectedAccountIds.value.contains(account.id)) {
            selectedAccountIds.value = [...selectedAccountIds.value, account.id];
          } else {
            selectedAccountIds.value = selectedAccountIds.value
                .where((e) => e != account.id)
                .toList();
          }
        },
      );
    }

    final rows = <Widget>[
      if (allowSelectAll)
        _SelectAllButton(selectedAccountIds: selectedAccountIds, options: optionsSorted),
      if (open.isNotEmpty) ...[
        if (showAccountStatusHeaders) const HEdgePadding(child: SectionHeader('Open Accounts')),
        ListSection(children: open.map(buildRow).toList()),
      ],
      if (closed.isNotEmpty) ...[
        if (open.isNotEmpty) const VSpace(),
        if (showAccountStatusHeaders) const HEdgePadding(child: SectionHeader('Closed Accounts')),
        ListSection(children: closed.map(buildRow).toList()),
      ],
    ];

    return SingleChildScrollView(
      child: VLayout(spacing: Sizes.unit * 2, children: rows),
    );
  }
}

class _SelectAllButton extends StatelessWidget {
  const _SelectAllButton({required this.selectedAccountIds, required this.options});

  final ValueNotifier<List<String>> selectedAccountIds;
  final Iterable<Account> options;

  @override
  Widget build(BuildContext context) {
    final canSelectAll = options.length != selectedAccountIds.value.length;
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          if (canSelectAll) {
            final newList = <String>[];
            for (final account in options) {
              newList.add(account.id);
            }
            selectedAccountIds.value = newList;
          } else {
            selectedAccountIds.value = [];
          }
        },
        child: HEdgePadding(
          child: HLayout(
            children: [
              Text(canSelectAll ? 'Select all' : 'Deselect all'),
              if (canSelectAll) const Icon(Ionicons.ellipse_outline),
              if (!canSelectAll) const Icon(Ionicons.checkmark_circle_outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.name, required this.isSelected, required this.onChanged});
  final String name;
  final bool isSelected;
  final ValueSetter<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: Text(name, overflow: TextOverflow.ellipsis),
      leading: SizedBox(
        width: Sizes.unit * 3,
        height: Sizes.unit * 3,
        child: Checkbox(value: isSelected, onChanged: (v) => onChanged?.call(v!)),
      ),
      onTap: () => onChanged?.call(!isSelected),
      implicitTrailing: false,
    );
  }
}
