import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../../../../app/di.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../navigation/frugal_month_navigation.dart';

class FrugalMonthSplashScreen extends StatelessWidget {
  const FrugalMonthSplashScreen({super.key});

  static String route = '/budget/frugal_month_splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frugal Month')),
      body: VLayout(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VSpace(space: Sizes.unit * 2),
          ListRow(
            externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
            title: Text('Set a limit', style: context.text.title),
            subtitle: const Text(
              'Choose a spending limit for the month. '
              "This is the amount you'll aim to beat.",
            ),
          ),
          ListRow(
            externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
            title: Text('Stay motivated', style: context.text.title),
            subtitle: const Text('Weekly check-ins will help you stay on track. You can do it!'),
          ),
          ListRow(
            externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
            title: Text('Achieve and reflect', style: context.text.title),
            subtitle: const Text(
              'Lumy will help you track your progress and '
              'reflect on your spending habits.',
            ),
          ),
          const Spacer(),
          SafeArea(
            child: VEdgePadding(
              child: HEdgePadding(
                child: PrimaryButton(
                  onPressed: () async {
                    $settings().setHasSeenFrugalMonthsSplash(true);
                    context.startCreateFrugalMonth();
                  },
                  child: const Text('Get started'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
