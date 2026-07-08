import 'package:dart_foundation/dart_foundation.dart';

import '../../../../../ynab_api/oauth/ynab_access_token.dart';

class LinkYnabScreenState {
  LinkYnabScreenState({required this.uri, required this.accessToken});

  factory LinkYnabScreenState.initial({Uri? uri}) {
    return LinkYnabScreenState(uri: uri, accessToken: uri == null ? const Idle() : const Loading());
  }

  /// The Uri received when deep linking, if any.
  final Uri? uri;

  /// Progress in fetching the YNAB access token.
  final Async<YnabAccessToken> accessToken;
}
