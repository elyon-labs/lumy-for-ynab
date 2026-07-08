import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import '../../../utils/_cubit.dart';
import '../../../utils/flutter.dart';

enum FeatureFlag {
  // Names of values here must match the Remote Config keys
  minimumSupportedVersion,
  widgets,
}

class FeatureFlagState {
  FeatureFlagState({required this.minimumSupportedVersion, required this.isWidgetsEnabled});

  /// Creates a new instance of [FeatureFlagState] from a map of values.
  ///
  /// The map must contain all keys from [FeatureFlag] and their corresponding
  /// values. If a key is missing, an exception will be thrown.
  factory FeatureFlagState.fromMap(Map<String, Object> map) {
    return FeatureFlagState(
      minimumSupportedVersion: Version.parse(
        map[FeatureFlag.minimumSupportedVersion.name]! as String,
      ),
      isWidgetsEnabled: map[FeatureFlag.widgets.name]! as bool,
    );
  }

  final Version minimumSupportedVersion;
  final bool isWidgetsEnabled;
}

class FeatureFlagsCubit extends Cubit<FeatureFlagState> {
  FeatureFlagsCubit({required this.config}) : super(FeatureFlagState.fromMap(defaultFeatureFlags)) {
    fetch();
  }

  factory FeatureFlagsCubit.create() {
    return FeatureFlagsCubit(config: FirebaseRemoteConfig.instance);
  }

  final FirebaseRemoteConfig config;
  final subs = CompositeSubscription();

  void fetch() {
    if (isFlutterTestMode()) return;
    _updateState(config);
    if (!UniversalPlatform.isWeb) {
      final sub = config.onConfigUpdated.listen((_) async {
        // For now, activate new parameters as soon as we get them, even if the
        // app is running. If this causes funky UI, we can change this to *only*
        // activate when the app is restarted.
        await config.activate();
        _updateState(config);
      });
      subs.add(sub);
    }
  }

  void _updateState(FirebaseRemoteConfig config) {
    safeEmit(
      FeatureFlagState(
        minimumSupportedVersion: config.getMinimumSupportedVersion(),
        isWidgetsEnabled: UniversalPlatform.isIOS,
      ),
    );
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

final Map<String, Object> defaultFeatureFlags = Map.fromEntries(
  FeatureFlag.values.map((e) {
    final value = switch (e) {
      // An exceedingly low number to ensure that the app will never be
      // disabled due to this flag accidentally.
      FeatureFlag.minimumSupportedVersion => Version(0, 0, 0).toString(),
      FeatureFlag.widgets => kDebugMode && UniversalPlatform.isIOS,
    };
    return MapEntry(e.name, value);
  }),
);

extension on FirebaseRemoteConfig {
  // ignore: unused_element
  bool getBoolInternal(String key) => kDebugMode || getBool(key);

  Version getMinimumSupportedVersion() {
    final defaultVersion = Version(0, 0, 0);
    if (kDebugMode || kProfileMode) return defaultVersion;
    final minVersion = getString(FeatureFlag.minimumSupportedVersion.name);
    return minVersion.isEmpty ? defaultVersion : Version.parse(minVersion);
  }
}

extension FeatureFlagsHookX on HookWidget {
  /// Returns the current [FeatureFlagState].
  FeatureFlagState useFeatureFlags() {
    final context = useContext();
    return context.watch<FeatureFlagsCubit>().state;
  }
}
