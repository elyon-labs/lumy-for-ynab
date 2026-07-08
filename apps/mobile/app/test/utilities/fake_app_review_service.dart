import 'package:lumy/features/app_review/app_review_service.dart';

class FakeAppReviewService implements AppReviewService {
  @override
  Future<void> onEvent() async {}

  @override
  Future<void> openStore() async {}
}
