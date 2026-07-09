import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../app/feature_flags/feature_flags_cubit.dart';
import '../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../common/presentation/design_system/section_body.dart';

class FeatureFlagsScreen extends StatelessWidget {
  const FeatureFlagsScreen({super.key});

  static const route = '/settings/feature_flags';

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: const Text('Feature Flags'),
      child: SingleChildScrollView(
        child: VLayout(
          children: [
            const VSpace(),
            BlocBuilder<FeatureFlagsCubit, FeatureFlagState>(
              builder: (context, state) {
                return ListSection(
                  children: FeatureFlag.values.map((flag) {
                    return _FeatureFlagRow(flag: flag, isEnabled: state.isEnabled(flag));
                  }).toList(),
                );
              },
            ),
            const VSpace(),
          ],
        ),
      ),
    );
  }
}

class _FeatureFlagRow extends StatelessWidget {
  const _FeatureFlagRow({required this.flag, required this.isEnabled});

  final FeatureFlag flag;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final canToggle = flag.canToggle;
    final subtitle = canToggle ? flag.description : 'This feature cannot be toggled.';

    void toggle(bool value) => context.read<FeatureFlagsCubit>().setFlag(flag, enabled: value);

    return ListRow(
      title: Text(flag.title),
      subtitle: Text(subtitle),
      trailing: SmallerSwitch(value: isEnabled, onChanged: canToggle ? toggle : null),
      onTap: canToggle ? () => toggle(!isEnabled) : null,
    );
  }
}
