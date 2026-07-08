import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../common/domain/payees/use_payees.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import 'choose_entity_modal.dart';

class TemplatePayeeRow extends HookWidget {
  const TemplatePayeeRow({super.key, required this.payeeId, required this.onSelected});

  final String? payeeId;
  final ValueSetter<Payee> onSelected;

  @override
  Widget build(BuildContext context) {
    final (payees, isLoading, error) = usePayees().details();

    if (isLoading || payees == null || error != null) {
      return const SizedBox.shrink();
    }

    final payeeName = payees.firstWhereOrNull((p) => payeeId == p.id)?.name;
    final title = payeeName != null
        ? Text(payeeName)
        : Text('Choose payee', style: TextStyle(color: context.colors.muted));

    return ListRow(
      title: title,
      leading: const Icon(Ionicons.person_circle_outline),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (modalContext) => ChooseEntityModal<Payee>.single(
            title: const Text('Choose a payee'),
            entities: payees,
            builder: (payee) => Text(payee.name),
            onCancel: () {
              Navigator.of(modalContext).pop();
            },
            onSelected: (payee) {
              onSelected(payee);
              Navigator.of(modalContext).pop();
            },
            initialSelectedEntity: payees.firstWhereOrNull((p) => p.id == payeeId),
          ),
        );
      },
    );
  }
}
