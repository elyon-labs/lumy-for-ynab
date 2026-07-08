import 'package:flutter/widgets.dart';

import '_build_context.dart';

/// A Widget that displays the appropriate child based on the size of the screen.
/// This is useful for displaying different layouts on mobile, tablet, and desktop.
class AdaptiveChild extends StatelessWidget {
  const AdaptiveChild({super.key, required this.mobile, this.tablet, this.desktop});

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isDesktop) {
          return desktop?.call(context) ?? tablet?.call(context) ?? mobile(context);
        } else if (context.isTablet) {
          return tablet?.call(context) ?? mobile(context);
        } else {
          return mobile(context);
        }
      },
    );
  }
}
