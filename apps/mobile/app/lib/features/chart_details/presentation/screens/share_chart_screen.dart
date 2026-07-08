import 'dart:io';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/presentation/orientation_aware.dart';
import '../../../../utils/_build_context.dart';
import '../../../../utils/_date_time.dart';
import '../../../charts/all_charts.dart';
import '../../../charts/models/chart.dart';

class ShareChartScreen extends HookWidget {
  const ShareChartScreen({super.key, required this.chartId});
  final String chartId;

  static String buildRoute(String chartId) {
    return '/reports/chart_details/$chartId/share';
  }

  @override
  Widget build(BuildContext context) {
    final controller = useScreenshotController();
    final chart = useState<Chart>(allCharts.selectSingle(chartId));
    final chartWidget = Screenshot(
      controller: controller,
      child: _Chart(chart: chart),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Share')),
      body: OrientationAware(
        ifPortrait: (_) => _List(chartWidget: chartWidget, chart: chart, controller: controller),
        ifLandscape: (context) => SingleChildScrollView(
          child: Row(
            children: [
              Expanded(child: chartWidget),
              Expanded(
                child: _List(chartWidget: chartWidget, chart: chart, controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.chartWidget, required this.chart, required this.controller});

  final Screenshot chartWidget;
  final ValueNotifier<Chart> chart;
  final ScreenshotController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: VLayout(
        children: [
          ...[
            ...context.whenPortrait((_) => [chartWidget], orElse: (_) => <Widget>[]),
          ],
          HEdgePadding(
            padding: Sizes.edgePadding * 2,
            child: VLayout(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HStretch(
                  child: Builder(
                    builder: (context) {
                      return SafeArea(
                        child: PrimaryButton(
                          onPressed: () async {
                            final image = await controller.capture(
                              delay: const Duration(milliseconds: 100),
                              pixelRatio: MediaQuery.of(context).devicePixelRatio,
                            );
                            if (context.mounted) {
                              if (image == null) {
                                context.showToast(const Text('Oops, something went wrong.'));
                                return;
                              }
                              final box = context.findRenderObject() as RenderBox?;
                              final tempDirectory = await getTemporaryDirectory();
                              final imagePath =
                                  '${tempDirectory.path}/lumy_share${nowLocal.millisecondsSinceEpoch}.png';
                              final file = File(imagePath);
                              await file.writeAsBytes(image);
                              await Share.shareXFiles([
                                XFile(imagePath),
                              ], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                            }
                          },
                          child: const Text('Share'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.chart});

  final ValueNotifier<Chart> chart;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ColoredBox(
        color: context.theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Sizes.edgePadding),
              child: Text('Lumy for YNAB', style: context.text.headline),
            ),
            const VSpace(space: Sizes.unit / 2),
            Padding(
              padding: const EdgeInsets.all(Sizes.edgePadding),
              child: chart.value.build(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenshotControllerHookCreator {
  const _ScreenshotControllerHookCreator();

  ScreenshotController call({List<Object?>? keys}) {
    return use(_ScreenshotControllerHook(keys));
  }
}

const useScreenshotController = _ScreenshotControllerHookCreator();

class _ScreenshotControllerHook extends Hook<ScreenshotController> {
  const _ScreenshotControllerHook([List<Object?>? keys]) : super(keys: keys);

  @override
  _ScreenshotControllerHookState createState() {
    return _ScreenshotControllerHookState();
  }
}

class _ScreenshotControllerHookState
    extends HookState<ScreenshotController, _ScreenshotControllerHook> {
  late final _controller = ScreenshotController();

  @override
  ScreenshotController build(BuildContext context) => _controller;

  @override
  void dispose() {}

  @override
  String get debugLabel => 'useScreenshotController';
}
