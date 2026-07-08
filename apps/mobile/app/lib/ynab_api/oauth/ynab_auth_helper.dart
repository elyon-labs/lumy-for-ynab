import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:async/async.dart' hide Result;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:oxidized/oxidized.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:universal_web/web.dart' as web;
import 'package:url_launcher/url_launcher.dart';

import '../../app/error_reporting/error_reporter.dart';
import '../../external/http_client.dart';
import '../../persistence/settings.dart';
import '../../utils/hydratable.dart';
import '../../utils/typedefs.dart';
import 'lumy_client.dart';
import 'ynab_access_token.dart';

/// Keys used for storing/retrieving [YnabAccessToken] metadata.
const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';
const _expiresInKey = 'expires_in';
const _createdAtKey = 'created_at';
const _scopeKey = 'scope';

/// {@template ynab_auth_helper}
///
/// A helper utility that facilitates authentication with the YNAB API.
///
/// {@endtemplate}
class YnabAuthHelper with Hydratable<YnabAccessToken?> {
  /// {@macro ynab_auth_helper}
  YnabAuthHelper._({
    required String authorizationEndpoint,
    required String tokenEndpoint,
    required String redirectUrl,
    required String clientId,
    required HttpClient client,
    required ErrorReporter errorReporter,
  }) : _authorizationEndpoint = authorizationEndpoint,
       _redirectUrl = redirectUrl,
       _tokenEndpoint = tokenEndpoint,
       _clientId = clientId,
       _client = client,
       _errorReporter = errorReporter {
    unawaited(_initToken());
  }

  /// {@macro ynab_auth_helper}
  static Future<YnabAuthHelper> create({
    required String authorizationUrl,
    required String redirectUrl,
    required String tokenUrl,
    required String clientId,
    required Logger logger,
    required ErrorReporter errorReporter,
    required PackageInfo packageInfo,
    required Settings settings,
  }) async {
    final client = createLumyHttpClient(
      logger: logger,
      packageInfo: packageInfo,
      settings: settings,
    );
    final helper = YnabAuthHelper._(
      authorizationEndpoint: authorizationUrl,
      redirectUrl: redirectUrl,
      tokenEndpoint: tokenUrl,
      clientId: clientId,
      client: client,
      errorReporter: errorReporter,
    );
    await helper.future;
    return helper;
  }

  /// The endpoint used to authorize the client
  final String _authorizationEndpoint;

  /// The URL the authorization server redirects to once the client is authorized
  final String _redirectUrl;

  /// The endpoint used to fetch or refresh the access token
  final String _tokenEndpoint;

  /// The client id of this application
  final String _clientId;

  final HttpClient _client;

  final ErrorReporter _errorReporter;

  final _accessToken = BehaviorSubject<YnabAccessToken?>();

  /// Fetches a [YnabAccessToken] from the YNAB server. Returns a [Result].
  Future<Result<YnabAccessToken, Exception>> fetchToken({required bool includeWriteScope}) async {
    if (_fetchCompleter != null && !_fetchCompleter!.isCompleted) {
      return _fetchCompleter!.future;
    }

    Future<Result<YnabAccessToken, Exception>> fetch() async {
      try {
        final url = await _fetchAuthorizationCode(includeWriteScope: includeWriteScope);

        if (UniversalPlatform.isMobile) {
          await closeInAppWebView();
        }

        final state = url.queryParameters['state'];
        if (state != _state) {
          return Err(Exception('State from server did not match client state'));
        }
        final code = url.queryParameters['code'];
        if (code == null) {
          return Err(Exception('No code in redirect URL'));
        }
        final result = await _exchangeCodeForToken(code);
        switch (result) {
          case Ok():
            await _updateToken(result.value);
            return Ok(result.value);
          case Err():
            return Err(result.error);
        }
      } on Exception catch (e) {
        return Err(e);
      }
    }

    _fetchCompleter = Completer();

    final result = await fetch();
    _fetchCompleter!.complete(result);
    _fetchCompleter = null;

    return result;
  }

  Future<Result<RefreshTokenOutcome, Exception>> refreshToken() async {
    final $accessToken = _accessToken.value;
    if ($accessToken == null) {
      return Err(Exception('No access token to refresh'));
    }
    final $completer = _refreshCompleter;
    if ($completer != null && !$completer.isCompleted) {
      // A request to refresh is already in progress. Signal completion
      // via the existing completer.
      return $completer.future;
    }
    // No request is in progress. Create a new completer and proceed.
    _refreshCompleter = Completer();
    final response = await _client.execute<Json>(
      PostRequest(
        _tokenEndpoint,
        headers: _buildHeaders(),
        body: JsonRequestBody({
          'client_id': _clientId,
          'refresh_token': $accessToken.refreshToken,
          'grant_type': 'refresh_token',
          'redirect_uri': _redirectUrl,
          'scope': $accessToken.scope,
        }),
      ),
    );

    /// Handles a successful response from the `/token` endpoint.
    Future<Result<RefreshTokenOutcome, Exception>> onSuccess(Response<Json> response) async {
      final json = response.data!;
      final accessToken = YnabAccessToken(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        createdAt: json['created_at'] as int,
        expiresIn: json['expires_in'] as int,
        scope: json['scope'] as String,
      );
      await _updateToken(accessToken);
      return Ok(RefreshTokenSuccess(accessToken));
    }

    // Handles an error response from the `/token` endpoint.
    Future<Result<RefreshTokenOutcome, Exception>> onError(int? statusCode, Exception error) async {
      return Ok(
        RefreshTokenFailure(
          e.toString(),
          // We will receive a `400` status code if the user has revoked access
          // to their YNAB account via YNAB settings.
          isUnauthorized: statusCode == 401 || statusCode == 400,
        ),
      );
    }

    final result = switch (response) {
      SuccessResponse<Json>(:final response) => await onSuccess(response),
      ErrorResponse<Json>(:final statusCode, :final error) => await onError(statusCode, error),
    };

    _refreshCompleter!.complete(result);
    _refreshCompleter = null;
    return result;
  }

  /// Whether the user has an access token available. The token may still
  /// be expired.
  ValueStream<bool> watchHasAccessToken() {
    return _accessToken.stream.map((token) => token != null).shareValue();
  }

  /// Clears the user's [YnabAccessToken] from local state and disk. This
  /// should be called when the user is no longer authenticated.
  Future<void> unauthenticate() async {
    await _updateToken(null);
  }

  Future<void> close() async {
    await _accessToken.close();
    await _redirectStream.cancel();
  }

  Future<void> _updateToken(YnabAccessToken? token) async {
    // Persist the token to disk before we tell anybody about it.
    if (token != null) {
      await _writeTokenToStorage(token);
    } else {
      await _clearStorage();
    }
    // Update the token in memory, allowing listeners to react.
    _accessToken.value = token;
  }

  /// The user's access token. If this is null, the user should be treated as
  /// not being authenticated.
  late final ValueStream<YnabAccessToken?> accessToken = _accessToken;

  /// Used for PKCE to prevent CSRF attacks.
  final _state = _pkceState(32);

  /// Used to store/retrieve the [YnabAccessToken] from a secure location on disk.
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: true,
    ),
  );

  /// Used to observe redirects from the browser back to the client.
  final _appLinks = AppLinks();

  /// A queue of redirects from the browser back to the client.
  late final _redirectStream = StreamQueue(_appLinks.uriLinkStream);

  /// Completer for the current attempt to exchange an authorization code
  /// for an access token.
  ///
  /// This allows us to de-duplicate the request to `/token`.
  Completer<Result<YnabAccessToken, Exception>>? _fetchCompleter;

  /// Completer for the current refresh token attempt.
  ///
  /// This allows us to de-duplicate the request to `/token`.
  Completer<Result<RefreshTokenOutcome, Exception>>? _refreshCompleter;

  /// Initializes [_accessToken]. Must be called upon creation of the helper.
  ///
  /// Signals to callers via [Hydratable] that the internal state can be trusted.
  Future<void> _initToken() async {
    final outcome = await _readTokenFromStorage();
    switch (outcome) {
      case TokenUnavailable(:final error):
        await _errorReporter.recordError(error, StackTrace.current);
      case TokenAvailable(:final token):
        try {
          await _updateToken(token);
          complete(token);
        } catch (e) {
          await _errorReporter.recordError(e, StackTrace.current);
        }
    }
  }

  /// Builds the headers for a POST request to the YNAB token endpoint.
  Map<String, String> _buildHeaders() {
    return {'Content-Type': Headers.formUrlEncodedContentType};
  }

  /// Creates a [Uri] that can be used in a browser to authorize the client.
  ///
  /// Since YNAB uses the authorization code flow, the `response_type` is
  /// hard-coded to `code`.
  ///
  /// The `write` scope is used.
  Uri _buildAuthorizationUrl({bool includeWriteScope = false}) {
    final baseUri =
        '$_authorizationEndpoint'
        '?client_id=$_clientId'
        '&redirect_uri=$_redirectUrl'
        '&response_type=code'
        '&state=$_state';
    return Uri.parse(includeWriteScope ? baseUri : '$baseUri&scope=read-only');
  }

  /// Writes the given [token] to storage for retrieval later.
  ///
  /// The inverse of [_readTokenFromStorage].
  Future<void> _writeTokenToStorage(YnabAccessToken token) async {
    await _storage.write(key: _accessTokenKey, value: token.accessToken);
    await _storage.write(key: _refreshTokenKey, value: token.refreshToken);
    await _storage.write(key: _expiresInKey, value: token.expiresIn.toString());
    await _storage.write(key: _createdAtKey, value: token.createdAt.toString());
    await _storage.write(key: _scopeKey, value: token.scope);
  }

  /// Reads the [YnabAccessToken] from storage.
  ///
  /// The inverse of [_writeTokenToStorage].
  Future<ReadTokenOutcome> _readTokenFromStorage() async {
    try {
      final accessToken = _storage.read(key: _accessTokenKey);
      final refreshToken = _storage.read(key: _refreshTokenKey);
      final expiresIn = _storage.read(key: _expiresInKey);
      final createdAt = _storage.read(key: _createdAtKey);
      final scope = _storage.read(key: _scopeKey);

      final results = await Future.wait([accessToken, refreshToken, expiresIn, createdAt, scope]);

      final $access = results[0];
      final $refresh = results[1];
      final $expiresIn = results[2];
      final $createdAt = results[3];
      final $scope = results[4];

      if ($access == null || $refresh == null || $expiresIn == null || $createdAt == null) {
        return TokenAvailable(null);
      }

      final token = YnabAccessToken(
        accessToken: $access,
        refreshToken: $refresh,
        expiresIn: int.parse($expiresIn),
        createdAt: int.parse($createdAt),
        scope: $scope ?? YnabAccessToken.readOnlyScope,
      );

      return TokenAvailable(token);
    } on PlatformException catch (e) {
      return TokenUnavailable(e);
    }
  }

  Future<void> _clearStorage() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresInKey),
      _storage.delete(key: _createdAtKey),
    ]);
  }

  Future<Uri> _fetchAuthorizationCode({required bool includeWriteScope}) async {
    if (UniversalPlatform.isWeb) {
      // Open a centered popup with modest dimensions
      const features = 'width=500,height=700,menubar=no,toolbar=no,location=no,status=no';
      final expectedOrigin = web.window.location.origin;
      final popup = web.window.open(
        _buildAuthorizationUrl(includeWriteScope: includeWriteScope).toString(),
        'oauth_popup',
        features,
      );

      // Detect popup blocked
      if (popup == null) {
        throw Exception('Popup blocked. Please allow popups and try again.');
      }

      final completer = Completer<Uri>();

      // Optional: timeout so callers aren’t left hanging forever.
      final timeout = Timer(const Duration(minutes: 5), () {
        if (!completer.isCompleted) {
          completer.completeError(Exception('OAuth timed out.'));
          try {
            popup.close();
          } catch (_) {}
        }
      });

      late final StreamSubscription<web.MessageEvent> sub;
      sub = web.window.onMessage.listen((event) async {
        // SECURITY: only accept messages from your own redirect page's origin
        if (event.origin != expectedOrigin) return;

        final data = event.data.toString();
        if (!data.startsWith('http')) return;

        try {
          final uri = Uri.parse(data);
          if (!completer.isCompleted) completer.complete(uri);
        } catch (_) {
          // ignore non-URI messages
        } finally {
          await sub.cancel();
          timeout.cancel();
          try {
            popup.close();
          } catch (_) {}
        }
      });

      return completer.future;
    } else {
      unawaited(launchUrl(_buildAuthorizationUrl(includeWriteScope: includeWriteScope)));
      return _redirectStream.next;
    }
  }

  /// Makes a POST request to [_tokenEndpoint] for the given [code] in attempt
  /// to fetch an access token.
  Future<Result<YnabAccessToken, Exception>> _exchangeCodeForToken(String code) async {
    final response = await _client.execute<Json>(
      PostRequest(
        _tokenEndpoint,
        headers: _buildHeaders(),
        body: JsonRequestBody({
          'client_id': _clientId,
          'code': code,
          'grant_type': 'authorization_code',
          'redirect_uri': _redirectUrl,
        }),
      ),
    );

    switch (response) {
      case SuccessResponse<Json>(:final response):
        final json = response.data!;
        final accessToken = YnabAccessToken(
          accessToken: json['access_token'] as String,
          refreshToken: json['refresh_token'] as String,
          createdAt: json['created_at'] as int,
          expiresIn: json['expires_in'] as int,
          scope: json['scope'] as String,
        );
        return Ok(accessToken);
      case ErrorResponse<Json>(:final error):
        return Err(error);
    }
  }
}

/// Generates a random [String] that can be used as a PKCE challenge.
String _pkceState(int length) {
  const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(length, (index) => charset[random.nextInt(charset.length)]).join();
}

sealed class RefreshTokenOutcome {}

class RefreshTokenSuccess extends RefreshTokenOutcome {
  RefreshTokenSuccess(this.accessToken);

  final YnabAccessToken accessToken;
}

class RefreshTokenFailure extends RefreshTokenOutcome {
  RefreshTokenFailure(this.error, {required this.isUnauthorized});

  final String error;
  final bool isUnauthorized;
}

sealed class ReadTokenOutcome {}

class TokenUnavailable extends ReadTokenOutcome {
  TokenUnavailable(this.error);

  final Object? error;
}

class TokenAvailable extends ReadTokenOutcome {
  TokenAvailable(this.token);

  final YnabAccessToken? token;
}
