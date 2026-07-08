import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../../../../utils/_package_info.dart';

part 'home_screen_state.mapper.dart';

@MappableClass()
class HomeScreenState with HomeScreenStateMappable {
  HomeScreenState({
    required this.budgetId,
    required this.appVersion,
    required this.hasUnsyncedData,
  });

  factory HomeScreenState.initial({required PackageInfo packageInfo}) {
    return HomeScreenState(
      budgetId: const Loading(),
      appVersion: packageInfo.parsedVersion,
      hasUnsyncedData: false,
    );
  }

  final Async<Option<String>> budgetId;
  final Version appVersion;
  final bool hasUnsyncedData;
}
