// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ynab_access_token.dart';

class YnabAccessTokenMapper extends ClassMapperBase<YnabAccessToken> {
  YnabAccessTokenMapper._();

  static YnabAccessTokenMapper? _instance;
  static YnabAccessTokenMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = YnabAccessTokenMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'YnabAccessToken';

  static String _$accessToken(YnabAccessToken v) => v.accessToken;
  static const Field<YnabAccessToken, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
    key: r'access_token',
  );
  static String _$refreshToken(YnabAccessToken v) => v.refreshToken;
  static const Field<YnabAccessToken, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
    key: r'refresh_token',
  );
  static int _$createdAt(YnabAccessToken v) => v.createdAt;
  static const Field<YnabAccessToken, int> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static int _$expiresIn(YnabAccessToken v) => v.expiresIn;
  static const Field<YnabAccessToken, int> _f$expiresIn = Field(
    'expiresIn',
    _$expiresIn,
    key: r'expires_in',
  );
  static String _$scope(YnabAccessToken v) => v.scope;
  static const Field<YnabAccessToken, String> _f$scope = Field(
    'scope',
    _$scope,
  );
  static List<Object?> _$props(YnabAccessToken v) => v.props;
  static const Field<YnabAccessToken, List<Object?>> _f$props = Field(
    'props',
    _$props,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<YnabAccessToken> fields = const {
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
    #createdAt: _f$createdAt,
    #expiresIn: _f$expiresIn,
    #scope: _f$scope,
    #props: _f$props,
  };

  static YnabAccessToken _instantiate(DecodingData data) {
    return YnabAccessToken(
      accessToken: data.dec(_f$accessToken),
      refreshToken: data.dec(_f$refreshToken),
      createdAt: data.dec(_f$createdAt),
      expiresIn: data.dec(_f$expiresIn),
      scope: data.dec(_f$scope),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static YnabAccessToken fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<YnabAccessToken>(map);
  }

  static YnabAccessToken fromJson(String json) {
    return ensureInitialized().decodeJson<YnabAccessToken>(json);
  }
}

mixin YnabAccessTokenMappable {
  String toJson() {
    return YnabAccessTokenMapper.ensureInitialized()
        .encodeJson<YnabAccessToken>(this as YnabAccessToken);
  }

  Map<String, dynamic> toMap() {
    return YnabAccessTokenMapper.ensureInitialized().encodeMap<YnabAccessToken>(
      this as YnabAccessToken,
    );
  }

  YnabAccessTokenCopyWith<YnabAccessToken, YnabAccessToken, YnabAccessToken>
  get copyWith =>
      _YnabAccessTokenCopyWithImpl<YnabAccessToken, YnabAccessToken>(
        this as YnabAccessToken,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return YnabAccessTokenMapper.ensureInitialized().stringifyValue(
      this as YnabAccessToken,
    );
  }

  @override
  bool operator ==(Object other) {
    return YnabAccessTokenMapper.ensureInitialized().equalsValue(
      this as YnabAccessToken,
      other,
    );
  }

  @override
  int get hashCode {
    return YnabAccessTokenMapper.ensureInitialized().hashValue(
      this as YnabAccessToken,
    );
  }
}

extension YnabAccessTokenValueCopy<$R, $Out>
    on ObjectCopyWith<$R, YnabAccessToken, $Out> {
  YnabAccessTokenCopyWith<$R, YnabAccessToken, $Out> get $asYnabAccessToken =>
      $base.as((v, t, t2) => _YnabAccessTokenCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class YnabAccessTokenCopyWith<$R, $In extends YnabAccessToken, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? accessToken,
    String? refreshToken,
    int? createdAt,
    int? expiresIn,
    String? scope,
  });
  YnabAccessTokenCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _YnabAccessTokenCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, YnabAccessToken, $Out>
    implements YnabAccessTokenCopyWith<$R, YnabAccessToken, $Out> {
  _YnabAccessTokenCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<YnabAccessToken> $mapper =
      YnabAccessTokenMapper.ensureInitialized();
  @override
  $R call({
    String? accessToken,
    String? refreshToken,
    int? createdAt,
    int? expiresIn,
    String? scope,
  }) => $apply(
    FieldCopyWithData({
      if (accessToken != null) #accessToken: accessToken,
      if (refreshToken != null) #refreshToken: refreshToken,
      if (createdAt != null) #createdAt: createdAt,
      if (expiresIn != null) #expiresIn: expiresIn,
      if (scope != null) #scope: scope,
    }),
  );
  @override
  YnabAccessToken $make(CopyWithData data) => YnabAccessToken(
    accessToken: data.get(#accessToken, or: $value.accessToken),
    refreshToken: data.get(#refreshToken, or: $value.refreshToken),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    expiresIn: data.get(#expiresIn, or: $value.expiresIn),
    scope: data.get(#scope, or: $value.scope),
  );

  @override
  YnabAccessTokenCopyWith<$R2, YnabAccessToken, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _YnabAccessTokenCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

