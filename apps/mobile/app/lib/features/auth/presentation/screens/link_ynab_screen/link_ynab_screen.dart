import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/presentation/markdown.dart';
import 'link_ynab_screen_cubit.dart';

class LinkYnabScreen extends StatelessWidget {
  const LinkYnabScreen({super.key});

  static String buildRoute() {
    return '/oauth';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkYnabScreenCubit.create(uri: null),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(Sizes.edgePadding),
          child: VLayout(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: HEdgePadding(
                    child: VLayout(
                      children: [
                        HLayout(
                          children: [
                            Transform.rotate(
                              angle: -0.2,
                              alignment: Alignment.centerRight,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: context.colors.foreground,
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: BorderRadius.circular(Sizes.unit * 1.5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Sizes.unit),
                                  child: Image.asset(
                                    'assets/images/ynab/YNAB-Tree.png',
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: 0.2,
                              alignment: Alignment.centerLeft,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: context.colors.primary,
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: BorderRadius.circular(Sizes.unit * 1.5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Sizes.unit),
                                  child: Image.asset(
                                    'assets/icon-transparent-no-padding.png',
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VSpace(space: Sizes.unit * 4),
                        Text('YNAB & Lumy go better together.', style: context.text.headline),
                        const Markdown(
                          data:
                              'Lumy connects to your YNAB account to help you visualize your spending and budgets. This is done by a process called OAuth, which securely connects Lumy to your YNAB account without ever seeing your login information. Read more about OAuth [here](https://api.ynab.com/#oauth-applications).',
                        ),
                        const Markdown(
                          data:
                              'After tapping the button, you will be redirected to the YNAB website to complete the linking process.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                child: const Text('Link YNAB Account'),
                onPressed: () async {
                  await context.read<LinkYnabScreenCubit>().fetch();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
