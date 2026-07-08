import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../features/recurring_transactions/hydrated_scheduled_transaction.dart';
import '../../../utils/_string.dart';
import '../../domain/budgets/currency_format_cubit.dart';
import '../currency.dart';
import '../design_system/list_row.dart';

class TransactionRow extends HookWidget {
  const TransactionRow({
    super.key,
    required this.transaction,
    this.backgroundColor,
    this.buildAmount,
    this.buildTitle,
    this.buildSubtitle,
    this.colorCodeAmounts = false,
  });

  final BaseTransaction transaction;
  final Color? backgroundColor;
  final bool colorCodeAmounts;

  final WidgetBuilder? buildAmount;
  final WidgetBuilder? buildTitle;
  final WidgetBuilder? buildSubtitle;

  @override
  Widget build(BuildContext context) {
    final uiTransaction = transaction.toUiTransaction();
    final subTransactions = uiTransaction.subTransactions;
    final child = VLayout(
      children: [
        ListRow(
          leading: CircleAvatar(
            radius: Sizes.unit * 2,
            backgroundColor: context.colors.good,
            child: Text(
              uiTransaction.payeeName.alphaNumericOnly.safeSubstring(0, 1).toUpperCase(),
              style: context.text.title.copyWith(color: context.colors.onGood),
            ),
          ),
          title: HLayout(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: Sizes.unit * 2),
                  child: DefaultTextStyle.merge(
                    child: buildTitle?.call(context) ?? Text(uiTransaction.payeeName),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DefaultTextStyle.merge(
                child:
                    buildAmount?.call(context) ??
                    _AmountText(amount: uiTransaction.amount, colorCodeAmounts: colorCodeAmounts),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorCodeAmounts
                      ? uiTransaction.amount < 0
                            ? context.colors.error
                            : context.colors.good
                      : null,
                ),
              ),
            ],
          ),
          subtitle: HLayout(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 0,
                child: DefaultTextStyle.merge(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: buildSubtitle?.call(context) ?? Text(uiTransaction.categoryName),
                ),
              ),
              Expanded(
                child: Text(
                  uiTransaction.memo,
                  softWrap: false,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        ...subTransactions.mapIndexed((i, t) {
          return Padding(
            padding: const EdgeInsets.only(left: Sizes.edgePadding),
            child: ListRow(
              leading: CircleAvatar(
                radius: Sizes.unit * 2,
                backgroundColor: context.colors.secondary,
                child: Text(
                  uiTransaction.payeeName.alphaNumericOnly.safeSubstring(0, 1).toUpperCase(),
                  style: context.text.title.copyWith(color: context.colors.onSecondary),
                ),
              ),
              visualDensity: VisualDensity.compact,
              title: HLayout(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: Sizes.unit * 2),
                      child: Text(
                        t.payeeName,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  _AmountText(amount: t.amount, colorCodeAmounts: colorCodeAmounts),
                ],
              ),
              subtitle: HLayout(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: Sizes.unit * 2),
                    child: DefaultTextStyle.merge(
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      child: buildSubtitle?.call(context) ?? Text(t.categoryName),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      t.memo,
                      softWrap: false,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
    return HStretch(child: child);
  }
}

class _AmountText extends HookWidget {
  const _AmountText({required this.amount, required this.colorCodeAmounts});

  final int amount;
  final bool colorCodeAmounts;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final color = colorCodeAmounts
        ? amount < 0
              ? context.colors.error
              : context.colors.good
        : null;
    return Text(
      amount.format(currencyFormat),
      style: TextStyle(fontWeight: FontWeight.bold, color: color),
    );
  }
}

class _UiTransaction {
  _UiTransaction({
    required this.payeeName,
    required this.categoryName,
    required this.memo,
    required this.amount,
    required this.subTransactions,
  });

  final String payeeName;
  final String categoryName;
  final String memo;
  final int amount;
  final List<_UiTransaction> subTransactions;
}

extension on BaseTransaction {
  _UiTransaction toUiTransaction({
    String? fallbackPayeeName,
    String? fallbackCategoryName,
    String? fallbackMemo,
  }) {
    _UiTransaction standard({
      String? payeeName,
      String? categoryName,
      String? memo,
      List<_UiTransaction> subTransactions = const [],
    }) {
      return _UiTransaction(
        payeeName: payeeName ?? fallbackPayeeName ?? 'No Payee',
        categoryName: categoryName ?? fallbackCategoryName ?? '',
        memo: memo ?? fallbackMemo ?? '',
        amount: amount,
        subTransactions: subTransactions,
      );
    }

    return switch (this) {
      ScheduledTransaction(
        :final payeeName,
        :final categoryName,
        :final memo,
        :final subTransactions,
      ) =>
        standard(
          payeeName: payeeName,
          categoryName: categoryName,
          memo: memo,
          subTransactions: subTransactions.map((e) => e.toUiTransaction()).toList(),
        ),
      PastTransaction(:final payeeName, :final categoryName, :final memo, :final subTransactions) =>
        standard(
          payeeName: payeeName,
          categoryName: categoryName,
          memo: memo,
          subTransactions: subTransactions.map((e) => e.toUiTransaction()).toList(),
        ),
      HydratedScheduledSubTransaction(:final payeeName, :final categoryName, :final memo) =>
        standard(payeeName: payeeName, categoryName: categoryName, memo: memo),
      SubTransaction(:final payeeName, :final categoryName, :final memo) => standard(
        payeeName: payeeName,
        categoryName: categoryName,
        memo: memo,
      ),
      _ => standard(),
    };
  }
}
