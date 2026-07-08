import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../common/presentation/design_system/section_header.dart';
import 'about_app_screen_cubit.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static String route = '/settings/about';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutAppScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: VLayout(
            spacing: Sizes.unit * 2,
            children: [
              HEdgePadding(
                child: VLayout(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/brandon_avatar.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text("👋 Hi, I'm Brandon.", style: context.text.headline),
                  ],
                ),
              ),
              const HEdgePadding(
                child: Text(
                  "I started working on Lumy back in 2023 as a way to play with YNAB's public API and my own budget data. Since then, Lumy has been downloaded thousands of times by fellow nerds in the community. My hope is that Lumy ends up being a useful tool for you in your budgeting journey! Please feel free to reach out via the Give Feedback button in Settings, or better yet...join the Discord!",
                ),
              ),
              const VSpace(space: Sizes.unit * 2),

              const HEdgePadding(child: SectionHeader('Resources')),
              ListSection(
                children: [
                  ListRow(
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(
                      Ionicons.chevron_forward_outline,
                      size: Sizes.unit * 2.5,
                    ).opacity(0.25),
                    onTap: () async {
                      final url = Uri.parse('https://lumyforynab.app/privacy');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                  ListRow(
                    title: const Text('Terms of Use'),
                    trailing: const Icon(
                      Ionicons.chevron_forward_outline,
                      size: Sizes.unit * 2.5,
                    ).opacity(0.25),
                    onTap: () async {
                      final url = Uri.parse(
                        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                ],
              ),
              const _Version(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Version extends StatelessWidget {
  const _Version();

  @override
  Widget build(BuildContext context) {
    final version = context.watch<AboutAppScreenCubit>().state.appVersion;
    final text = version.mapOr((value) => 'Version $value', 'Version');
    return HEdgePadding(
      child: Skeletonizer(
        enabled: version.isLoading,
        child: Text(text, style: context.text.caption),
      ),
    );
  }
}
