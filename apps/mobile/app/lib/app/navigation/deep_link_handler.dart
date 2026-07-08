import 'package:go_router/go_router.dart';
import 'package:universal_platform/universal_platform.dart';

/// Handles all deep links other than special ones like the ones for authentication
/// and for widgets.
// ignore: non_constant_identifier_names
void Function(Uri uri) DeepLinkHandler({required GoRouter router}) {
  return (uri) {
    if (UniversalPlatform.isWeb) return;
    // Ignore links from widgets, the widget handler handles those.
    if (uri.isWidgetLink) return;
    // If we haven't ignored the link, we can navigate to it.
    router.go(uri.toString());
  };
}

extension on Uri {
  bool get isWidgetLink => scheme.toLowerCase().contains('widget');
}
