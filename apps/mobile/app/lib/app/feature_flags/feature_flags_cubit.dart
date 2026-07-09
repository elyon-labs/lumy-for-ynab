import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../persistence/settings.dart';
import '../../utils/_cubit.dart';
import '../../utils/flutter.dart';
import '../di.dart';

/// A client-side feature flag.
///
/// Flags are toggled locally (and persisted to preferences) rather than being
/// controlled remotely. Each flag describes itself so it can be rendered on the
/// feature flags debug screen and gated per-platform.
enum FeatureFlag {
  widgets(
    title: 'Home Screen Widgets',
    description: 'Show Lumy metrics in iOS home screen widgets.',
  );

  const FeatureFlag({required this.title, required this.description});

  /// A human-readable name for this flag, shown on the feature flags screen.
  final String title;

  /// A human-readable description of what this flag controls.
  final String description;

  /// The preferences key under which this flag's override is stored.
  ///
  /// If no value is stored under this key, [defaultValue] is used.
  String get preferenceKey => 'feature_flag_$name';

  /// Whether the user is allowed to toggle this flag on the current platform.
  ///
  /// Flags whose underlying feature is unavailable on a platform (e.g. home
  /// screen widgets on Android) are locked so they cannot be enabled.
  bool get canToggle => switch (this) {
    FeatureFlag.widgets =>
      false, // Don't allow toggling as these are native and we won't remove them if toggled off.
  };

  /// The value used when the user has not stored an explicit override.
  bool get defaultValue => switch (this) {
    FeatureFlag.widgets => UniversalPlatform.isIOS,
  };
}

class FeatureFlagState {
  const FeatureFlagState(this.values);

  /// Creates a state where every flag falls back to its [FeatureFlag.defaultValue].
  factory FeatureFlagState.defaults() {
    return FeatureFlagState({for (final flag in FeatureFlag.values) flag: flag.defaultValue});
  }

  final Map<FeatureFlag, bool> values;

  /// Whether [flag] is currently enabled, falling back to its default.
  bool isEnabled(FeatureFlag flag) => values[flag] ?? flag.defaultValue;

  bool get isWidgetsEnabled => isEnabled(FeatureFlag.widgets);

  FeatureFlagState withFlag(FeatureFlag flag, bool value) {
    return FeatureFlagState({...values, flag: value});
  }
}

class FeatureFlagsCubit extends Cubit<FeatureFlagState> {
  FeatureFlagsCubit({required this.settings}) : super(FeatureFlagState.defaults()) {
    fetch();
  }

  factory FeatureFlagsCubit.create({required Settings settings}) {
    return FeatureFlagsCubit(settings: settings);
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    if (isFlutterTestMode()) return;
    for (final flag in FeatureFlag.values) {
      final sub = settings.watchFeatureFlag(flag.preferenceKey).listen((value) {
        safeEmit(state.withFlag(flag, value ?? flag.defaultValue));
      });
      subs.add(sub);
    }
  }

  /// Persists an override for [flag]. The change is reflected in the state via
  /// the subscription established in [fetch].
  Future<void> setFlag(FeatureFlag flag, {required bool enabled}) {
    return settings.setFeatureFlag(flag.preferenceKey, enabled);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

extension FeatureFlagsHookX on HookWidget {
  /// Returns the current [FeatureFlagState].
  FeatureFlagState useFeatureFlags() {
    final context = useContext();
    return context.watch<FeatureFlagsCubit>().state;
  }
}
