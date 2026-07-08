import 'package:design/layout/edge_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../../../../common/presentation/currency.dart';
import 'amount_input.dart';

class TemplateAmountRow extends HookWidget {
  const TemplateAmountRow({
    super.key,
    required this.amount,
    required this.isInflow,
    required this.onChanged,
  });

  final int amount;
  final bool isInflow;
  final ValueSetter<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final controller = useTextEditingController(text: amount.format(currencyFormat));

    return HEdgePadding(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: AmountInput(controller: controller, onChanged: onChanged, isInflow: isInflow),
      ),
    );
  }
}
