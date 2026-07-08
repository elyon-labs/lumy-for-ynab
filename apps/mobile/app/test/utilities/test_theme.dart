import 'package:flutter/material.dart';
import 'package:lumy/theme/app_theme.dart';

ThemeData createTestTheme() {
  return createAppTheme(brightness: Brightness.dark, remoteFonts: false);
}
