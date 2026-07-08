import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import '../common/presentation/_color.dart';
import 'color_palette.dart';

ThemeData createAppTheme({required Brightness brightness, bool remoteFonts = true}) {
  final colors = switch (brightness) {
    Brightness.light => lightPalette,
    Brightness.dark => darkPalette,
  };

  final bespokeColors = switch (brightness) {
    Brightness.dark => darkBespokePalette,
    Brightness.light => lightBespokePalette,
  };

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: colors.primary,
    onPrimary: colors.onPrimary,
    secondary: colors.secondary,
    onSecondary: colors.onSecondary,
    error: colors.error,
    onError: colors.onError,
    surface: colors.card,
    onSurface: colors.foreground,
  );

  final coloredTheme = ThemeData.from(colorScheme: colorScheme);

  TextStyle appTextStyle({required double fontSize, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(fontFamily: 'Outfit', fontSize: fontSize, fontWeight: fontWeight);
  }

  final textTheme = coloredTheme.textTheme.copyWith(
    bodySmall: appTextStyle(fontSize: 10).copyWith(color: colors.foreground),
    bodyMedium: appTextStyle(fontSize: 12).copyWith(color: colors.foreground),
    bodyLarge: appTextStyle(fontSize: 14).copyWith(color: colors.foreground),
    titleSmall: appTextStyle(fontSize: 14).copyWith(color: colors.foreground),
    titleMedium: appTextStyle(fontSize: 16).copyWith(color: colors.foreground),
    headlineMedium: appTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ).copyWith(color: colors.foreground),
  );

  final text = ElyonText.fromMaterial(textTheme, colors: colors);

  final cupertinoTheme = CupertinoThemeData(
    primaryColor: colors.foreground,
    primaryContrastingColor: colors.foreground,
    brightness: brightness,
    scaffoldBackgroundColor: colors.body,
    barBackgroundColor: colors.body,
    textTheme: CupertinoTextThemeData(
      primaryColor: colors.primary,
      textStyle: text.body,
      navTitleTextStyle: text.title,
      navLargeTitleTextStyle: text.headline.copyWith(fontSize: 32),
      actionTextStyle: text.body,
    ),
  );

  return ThemeData(
    cupertinoOverrideTheme: cupertinoTheme,
    colorScheme: colorScheme,
    pageTransitionsTheme: UniversalPlatform.isWeb
        ? PageTransitionsTheme(
            builders: {
              for (final platform in TargetPlatform.values) platform: const NoTransitionsBuilder(),
            },
          )
        : coloredTheme.pageTransitionsTheme,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(colors.foreground),
        iconSize: const WidgetStatePropertyAll(Sizes.unit * 3),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.body,
      foregroundColor: colors.foreground,
      titleTextStyle: text.title,
      shadowColor: colors.foreground.withAlphaOf(0.10),
      surfaceTintColor: colors.body,
      actionsIconTheme: IconThemeData(color: colors.foreground, size: Sizes.unit * 3),
      iconTheme: IconThemeData(color: colors.foreground, size: Sizes.unit * 3),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(Sizes.unit * 1.5)),
    ),
    primaryTextTheme: textTheme,
    textTheme: textTheme,
    iconTheme: IconThemeData(color: colors.foreground),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(text.body),
        foregroundColor: WidgetStatePropertyAll(colors.foreground),
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Sizes.unit)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Sizes.unit)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent, width: 0)),
        textStyle: WidgetStatePropertyAll(text.body.copyWith(fontWeight: FontWeight.bold)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Sizes.unit)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.body,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.foreground);
        }
        return IconThemeData(color: colors.muted);
      }),
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStatePropertyAll(text.body),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    ),
    inputDecorationTheme: InputDecorationTheme(
      outlineBorder: BorderSide.none,
      border: InputBorder.none,
      labelStyle: text.body,
      hintStyle: text.body.copyWith(color: colors.muted),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: colors.foreground),
    listTileTheme: ListTileThemeData(
      titleTextStyle: text.title,
      subtitleTextStyle: text.body.copyWith(color: colors.muted),
      leadingAndTrailingTextStyle: text.body,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
    ),
    chipTheme: ChipThemeData(
      padding: EdgeInsets.zero,
      labelStyle: text.body,
      iconTheme: const IconThemeData(size: Sizes.unit),
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(Sizes.borderRadius)),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: colors.foreground,
      activeTrackColor: colors.muted.withAlphaOf(0.5),
      overlayShape: SliderComponentShape.noOverlay,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: colors.foreground,
      unselectedLabelColor: colors.muted,
      labelStyle: text.title,
      unselectedLabelStyle: text.title,
      indicatorColor: colors.foreground,
    ),
    dialogTheme: DialogThemeData(
      titleTextStyle: text.headline,
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(Sizes.borderRadius * 3)),
      backgroundColor: colors.card,
    ),
    scaffoldBackgroundColor: colors.body,
    splashFactory: NoSplash.splashFactory,
    dividerTheme: DividerThemeData(
      color: colors.divider,
      thickness: 0.5,
      space: 0,
      indent: Sizes.edgePadding,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    drawerTheme: DrawerThemeData(backgroundColor: colors.body),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.modal,
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.borderRadius * 5),
          topRight: Radius.circular(Sizes.borderRadius * 5),
        ),
      ),
    ),
    extensions: [colors, bespokeColors, text],
  );
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}
