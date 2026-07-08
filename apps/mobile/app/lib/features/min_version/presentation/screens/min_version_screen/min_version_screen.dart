import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/_build_context.dart';
import 'min_version_screen_cubit.dart';

class MinVersionScreen extends StatelessWidget {
  const MinVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MinVersionScreenCubit.create(),
      child: Scaffold(body: const _Body(), appBar: AppBar(automaticallyImplyLeading: false)),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(
      child: VLayout(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: VLayout(
                children: [
                  CircleAvatar(
                    radius: Sizes.unit * 4,
                    backgroundColor: context.colors.warning,
                    child: Icon(
                      Ionicons.arrow_up_outline,
                      size: Sizes.unit * 4,
                      color: context.colors.onWarning,
                    ),
                  ),
                  const VSpace(space: Sizes.edgePadding),
                  Text('Oops, this version of Lumy is too old', style: context.text.headline),
                  Text(
                    'Please update the app to continue using it. This is required occassionally to ensure the best experience and security.',
                    style: context.text.body.copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: VEdgePadding(
              child: PrimaryButton(
                child: const Text('Update now'),
                onPressed: () async {
                  final state = context.read<MinVersionScreenCubit>().state;
                  final url = UniversalPlatform.isIOS ? state.iosStoreUrl : state.androidStoreUrl;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    // ignore: use_build_context_synchronously
                    context.showToast(Text('Could not launch $url'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
