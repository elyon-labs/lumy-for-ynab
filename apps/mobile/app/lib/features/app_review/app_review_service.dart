import 'package:clock/clock.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../app/di.dart';
import '../../app/environment/environment.dart';
import '../../persistence/settings.dart';

class AppReviewService {
  const AppReviewService({
    required String iosStoreUrl,
    required InAppReview inAppReview,
    required Settings settings,
  }) : _settings = settings,
       _inAppReview = inAppReview,
       _iosStoreUrl = iosStoreUrl;

  factory AppReviewService.create() {
    return AppReviewService(
      iosStoreUrl: inject<Environment>().iosStoreUrl,
      inAppReview: InAppReview.instance,
      settings: inject(),
    );
  }

  static const _promptEventCount = 15;

  final String _iosStoreUrl;
  final InAppReview _inAppReview;
  final Settings _settings;

  Future<void> onEvent() async {
    final eventCount = await _settings.incrementAppReviewEvents();
    final lastRequest = await _settings.watchLastAppReviewRequest().nextValue();

    bool lastRequestOver7DaysAgo() {
      final $lastRequest = lastRequest.unwrapOr(clock.daysAgo(100));
      final difference = $lastRequest.difference(clock.now()).inDays;
      return difference.abs() > 7;
    }

    final canRequest = lastRequestOver7DaysAgo();

    if (eventCount >= _promptEventCount && canRequest) {
      await _settings.resetAppReviewEvents();
      _settings.setLastAppReviewRequest(clock.now());
      await _requestReview();
    }
  }

  Future<void> openStore() async {
    final iosStoreId = _iosStoreUrl.split('/id').lastOrNull;
    await _inAppReview.openStoreListing(appStoreId: iosStoreId);
  }

  Future<void> _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
}
