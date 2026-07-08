import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'feature_flags_cubit.dart';

Future<void> initializeFeatureFlags() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: kReleaseMode
          ? const Duration(hours: 12)
          : //
            const Duration(minutes: 1),
    ),
  );
  await remoteConfig.setDefaults(defaultFeatureFlags);

  // Fetch and activate the remote config values. Don't handle the result,
  // since we don't need to know if the config changed or not.
  remoteConfig.fetchAndActivate().ignore();
}
