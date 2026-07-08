import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../../../../app/di.dart';
import '../../../../../utils/_cubit.dart';
import 'about_app_screen_state.dart';

class AboutAppScreenCubit extends Cubit<AboutAppScreenState> {
  AboutAppScreenCubit({
    required PackageInfo packageInfo,
    required ShorebirdCodePush shorebirdCodePush,
  }) : _shorebirdCodePush = shorebirdCodePush,
       _packageInfo = packageInfo,
       super(AboutAppScreenState.initial()) {
    unawaited(fetch());
  }

  factory AboutAppScreenCubit.create() {
    return AboutAppScreenCubit(packageInfo: inject(), shorebirdCodePush: inject());
  }

  final PackageInfo _packageInfo;
  final ShorebirdCodePush _shorebirdCodePush;

  Future<void> fetch() async {
    final baseAppVersion = _packageInfo.version;
    final buildNumber = _packageInfo.buildNumber;
    final patchVersion = await _shorebirdCodePush.currentPatchNumber();

    final appVersion =
        '$baseAppVersion+$buildNumber${patchVersion != null ? '/$patchVersion' : ''}';

    safeEmit(AboutAppScreenState(appVersion: Loaded(appVersion)));
  }
}
