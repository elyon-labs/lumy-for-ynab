import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../../../common/domain/accounts/use_accounts.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import 'choose_entity_modal.dart';

class TemplateAccountRow extends HookWidget {
  const TemplateAccountRow({super.key, required this.accountId, required this.onSelected});

  final String? accountId;
  final ValueSetter<Account> onSelected;

  @override
  Widget build(BuildContext context) {
    final (accounts, isLoading, error) = useAccounts(view: const OpenAccounts()).details();

    if (isLoading || accounts == null || error != null) {
      return const SizedBox.shrink();
    }

    final accountName = accounts.firstWhereOrNull((a) => accountId == a.id)?.name;

    final title = accountName != null
        ? Text(accountName)
        : Text('Choose account', style: TextStyle(color: context.colors.muted));

    return ListRow(
      title: title,
      leading: const Icon(Ionicons.wallet_outline),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (modalContext) => ChooseEntityModal<Account>.single(
            title: const Text('Choose an account'),
            entities: accounts,
            builder: (account) => Text(account.name),
            onCancel: () {
              Navigator.of(modalContext).pop();
            },
            onSelected: (account) {
              onSelected(account);
              Navigator.of(modalContext).pop();
            },
            initialSelectedEntity: accounts.firstWhereOrNull((a) => a.id == accountId),
          ),
        );
      },
    );
  }
}
