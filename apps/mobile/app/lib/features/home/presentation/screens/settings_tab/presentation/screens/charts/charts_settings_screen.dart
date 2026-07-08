import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../charts/state/chart_settings_cubit.dart';
import 'charts_selection_screen.dart';

class ChartSettingsScreen extends HookWidget {
  const ChartSettingsScreen({super.key});

  static String route = '/settings/charts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chart Settings')),
      body: ListSection(
        children: [
          ListRow(
            leading: const Icon(Ionicons.stats_chart_outline),
            title: const Text('Select and reorder charts'),
            trailing: const Icon(
              Ionicons.chevron_forward_outline,
              size: Sizes.unit * 2.5,
            ).opacity(0.25),
            onTap: () => GoRouter.of(context).go(ChartsSelectionScreen.route),
          ),
          BlocBuilder<ChartSettingsCubit, ChartSettingsState>(
            builder: (context, state) {
              return ListRow(
                leading: const Icon(Ionicons.analytics_outline),
                title: const Text('Show trendlines on charts'),
                trailing: SmallerSwitch(
                  value: state.showTrendlines,
                  onChanged: (_) => $settings().setShowTrendlines(!state.showTrendlines),
                ),
                onTap: () => $settings().setShowTrendlines(!state.showTrendlines),
              );
            },
          ),
        ],
      ),
    );
  }
}
