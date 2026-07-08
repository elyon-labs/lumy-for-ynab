import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../app/di.dart';
import '../../../../../common/presentation/accounts/choose_accounts.dart';
import '../../../../../common/presentation/bottom_glow_container.dart';
import '../../../../../ynab_api/_account.dart';
import '../../../../charts/all_charts.dart';
import '../../../../charts/models/chart.dart';
import 'choose_chart_accounts_screen_cubit.dart';
import 'choose_chart_accounts_screen_state.dart';

class ChooseChartAccountsScreen extends HookWidget {
  const ChooseChartAccountsScreen({super.key, required this.chartId});

  final String chartId;

  static String buildRoute(String chartId) {
    return '/reports/chart_details/$chartId/accounts';
  }

  @override
  Widget build(BuildContext context) {
    final chart = allCharts.selectSingle(chartId);
    return BlocProvider(
      create: (context) => ChooseChartAccountsScreenCubit.create(chart),
      child: BlocBuilder<ChooseChartAccountsScreenCubit, ChooseChartAccountsScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(state.chart.title)),
            body: switch (state.chartAccounts) {
              Loaded<Option<List<String>>>(:final value) => _LoadedBody(
                accounts: state.accounts,
                chartAccounts: value,
                chart: state.chart,
              ),
              _ => const Center(child: CircularProgressIndicator.adaptive()),
            },
          );
        },
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.accounts, required this.chartAccounts, required this.chart});

  final List<Account> accounts;
  final Option<List<String>> chartAccounts;
  final Chart chart;

  @override
  Widget build(BuildContext context) {
    final options = accounts.where(chart.accountFilter);
    final selectedAccounts = useState(chartAccounts.unwrapOr(options.ids));
    return VLayout(
      spacing: 0,
      children: [
        Expanded(
          child: ChooseAccounts(selectedAccountIds: selectedAccounts, options: options),
        ),
        BottomGlowContainer(
          child: PrimaryButton(
            onPressed: selectedAccounts.value.isEmpty
                ? null //
                : () async {
                    await $settings().setChartAccounts(chart, selectedAccounts.value);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
            child: const Text('Use these accounts'),
          ),
        ),
      ],
    );
  }
}
