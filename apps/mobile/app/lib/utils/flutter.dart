import 'dart:io';

import 'package:universal_platform/universal_platform.dart';

bool isFlutterTestMode() {
  return !UniversalPlatform.isWeb && Platform.environment.containsKey('FLUTTER_TEST');
}
