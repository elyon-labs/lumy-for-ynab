import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../link_email_screen/link_email_screen.dart';
import 'widgets/testimonials.dart';

class WelcomeScreen extends HookWidget {
  const WelcomeScreen({super.key});

  static String route = '/welcome';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: VEdgePadding(
          padding: Sizes.edgePadding,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: HEdgePadding(
              padding: Sizes.unit * 8,
              child: VLayout(children: [_Branding(), _Buttons()]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  const _Branding();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VLayout(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: VLayout(
                children: [
                  Text('Lumy', style: context.text.headline.copyWith(fontSize: 48)),
                  Text('Illuminate your spending.', style: context.text.caption),
                ],
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: TestimonialRotator(
                testimonials: [
                  Testimony(
                    text:
                        'Since YNAB doesn’t provide many out of the box reports, an app to do this is required…and Lumy does this amazingly well. Strong charts, amazingly active developer, and a nice plan for the future in their roadmap.',
                    author: 'Staxxed',
                  ),
                  Testimony(
                    text:
                        'I have nothing but good things to say about this app. The developer takes feedback and improves the app. It offers so many charts YNAB lacks and even helps track spending.',
                    author: 'Littiy',
                  ),
                  Testimony(
                    text:
                        'This app is incredible, it elegantly adds so much functionally to YNAB! Reporting, goal setting, etc.',
                    author: 'jake from stakefarm',
                  ),
                  Testimony(
                    text: 'If you love YNAB you will love this app. Amazing reports for mobile!',
                    author: 'Me and the weather',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends HookWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return VLayout(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.unit * 6),
          child: HStretch(
            child: PrimaryButton(
              onPressed: () async {
                GoRouter.of(context).go(LinkEmailScreen.buildWelcomeRoute(isExistingUser: false));
              },
              child: const Text('Get started'),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).go(LinkEmailScreen.buildWelcomeRoute(isExistingUser: true));
          },
          child: const Text('Already have an account? Log in'),
        ),
      ],
    );
  }
}
