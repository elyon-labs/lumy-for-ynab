import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:version/version.dart';

import '../../../app/di.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';

class WhatsNewState {
  WhatsNewState({required this.hasNewFeatures, required this.data});

  factory WhatsNewState.initial() {
    return WhatsNewState(hasNewFeatures: false, data: '');
  }
  final bool hasNewFeatures;
  final String data;
}

class WhatsNewCubit extends Cubit<WhatsNewState> {
  WhatsNewCubit({required this.settings, required this.packageInfo})
    : super(WhatsNewState.initial()) {
    fetch();
  }

  factory WhatsNewCubit.create() {
    return WhatsNewCubit(settings: inject(), packageInfo: inject());
  }

  final Settings settings;
  final PackageInfo packageInfo;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = settings.watchLastWhatsNewVersion().listen((lastWhatsNewVersion) async {
      final contentFuture = rootBundle.loadString('assets/WHATS_NEW.md');
      if (lastWhatsNewVersion == null) {
        safeEmit(WhatsNewState(hasNewFeatures: true, data: await contentFuture));
      } else {
        final content = await contentFuture;
        final contentContainsCurrentVersion = content.contains(packageInfo.version);
        final lastSeenVersion = Version.parse(lastWhatsNewVersion);
        final currentVersion = Version.parse(packageInfo.version);
        safeEmit(
          WhatsNewState(
            hasNewFeatures: contentContainsCurrentVersion && currentVersion > lastSeenVersion,
            data: content,
          ),
        );
      }
    });
    subs.add(sub);
  }

  void markSeen() {
    settings.setLastWhatsNewVersion(packageInfo.version);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}
