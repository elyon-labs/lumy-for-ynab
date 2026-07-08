import 'package:flutter/widgets.dart';

class OrientationAware extends StatelessWidget {
  const OrientationAware({super.key, required this.ifPortrait, required this.ifLandscape});
  final WidgetBuilder ifPortrait;
  final WidgetBuilder ifLandscape;

  @override
  Widget build(BuildContext context) {
    // We don't use OrientationBuilder because that does not return
    // the actual orientation of the device, but the orientation
    // of the widget tree. In cases like ScrollViews with vertical scroll
    // (aka most of the app), the orientation is always portrait.
    // https://github.com/flutter/flutter/issues/96759
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return ifPortrait(context);
    } else {
      return ifLandscape(context);
    }
  }
}
