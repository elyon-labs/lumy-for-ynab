// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'get_token.dart';

class GetTokenMetaResponseMapper extends ClassMapperBase<GetTokenMetaResponse> {
  GetTokenMetaResponseMapper._();

  static GetTokenMetaResponseMapper? _instance;
  static GetTokenMetaResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GetTokenMetaResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GetTokenMetaResponse';

  static String _$accessToken(GetTokenMetaResponse v) => v.accessToken;
  static const Field<GetTokenMetaResponse, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
    key: 'access_token',
  );
  static String _$tokenType(GetTokenMetaResponse v) => v.tokenType;
  static const Field<GetTokenMetaResponse, String> _f$tokenType = Field(
    'tokenType',
    _$tokenType,
    key: 'token_type',
  );
  static int _$expiresIn(GetTokenMetaResponse v) => v.expiresIn;
  static const Field<GetTokenMetaResponse, int> _f$expiresIn = Field(
    'expiresIn',
    _$expiresIn,
    key: 'expires_in',
  );
  static String _$refreshToken(GetTokenMetaResponse v) => v.refreshToken;
  static const Field<GetTokenMetaResponse, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
    key: 'refresh_token',
  );
  static String _$scope(GetTokenMetaResponse v) => v.scope;
  static const Field<GetTokenMetaResponse, String> _f$scope = Field(
    'scope',
    _$scope,
  );
  static int _$createdAt(GetTokenMetaResponse v) => v.createdAt;
  static const Field<GetTokenMetaResponse, int> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: 'created_at',
  );

  @override
  final MappableFields<GetTokenMetaResponse> fields = const {
    #accessToken: _f$accessToken,
    #tokenType: _f$tokenType,
    #expiresIn: _f$expiresIn,
    #refreshToken: _f$refreshToken,
    #scope: _f$scope,
    #createdAt: _f$createdAt,
  };

  static GetTokenMetaResponse _instantiate(DecodingData data) {
    return GetTokenMetaResponse(
      accessToken: data.dec(_f$accessToken),
      tokenType: data.dec(_f$tokenType),
      expiresIn: data.dec(_f$expiresIn),
      refreshToken: data.dec(_f$refreshToken),
      scope: data.dec(_f$scope),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GetTokenMetaResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GetTokenMetaResponse>(map);
  }

  static GetTokenMetaResponse fromJson(String json) {
    return ensureInitialized().decodeJson<GetTokenMetaResponse>(json);
  }
}

mixin GetTokenMetaResponseMappable {
  String toJson() {
    return GetTokenMetaResponseMapper.ensureInitialized()
        .encodeJson<GetTokenMetaResponse>(this as GetTokenMetaResponse);
  }

  Map<String, dynamic> toMap() {
    return GetTokenMetaResponseMapper.ensureInitialized()
        .encodeMap<GetTokenMetaResponse>(this as GetTokenMetaResponse);
  }

  GetTokenMetaResponseCopyWith<
    GetTokenMetaResponse,
    GetTokenMetaResponse,
    GetTokenMetaResponse
  >
  get copyWith => _GetTokenMetaResponseCopyWithImpl(
    this as GetTokenMetaResponse,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return GetTokenMetaResponseMapper.ensureInitialized().stringifyValue(
      this as GetTokenMetaResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return GetTokenMetaResponseMapper.ensureInitialized().equalsValue(
      this as GetTokenMetaResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return GetTokenMetaResponseMapper.ensureInitialized().hashValue(
      this as GetTokenMetaResponse,
    );
  }
}

extension GetTokenMetaResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GetTokenMetaResponse, $Out> {
  GetTokenMetaResponseCopyWith<$R, GetTokenMetaResponse, $Out>
  get $asGetTokenMetaResponse =>
      $base.as((v, t, t2) => _GetTokenMetaResponseCopyWithImpl(v, t, t2));
}

abstract class GetTokenMetaResponseCopyWith<
  $R,
  $In extends GetTokenMetaResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
    String? scope,
    int? createdAt,
  });
  GetTokenMetaResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GetTokenMetaResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GetTokenMetaResponse, $Out>
    implements GetTokenMetaResponseCopyWith<$R, GetTokenMetaResponse, $Out> {
  _GetTokenMetaResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GetTokenMetaResponse> $mapper =
      GetTokenMetaResponseMapper.ensureInitialized();
  @override
  $R call({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
    String? scope,
    int? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (accessToken != null) #accessToken: accessToken,
      if (tokenType != null) #tokenType: tokenType,
      if (expiresIn != null) #expiresIn: expiresIn,
      if (refreshToken != null) #refreshToken: refreshToken,
      if (scope != null) #scope: scope,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  GetTokenMetaResponse $make(CopyWithData data) => GetTokenMetaResponse(
    accessToken: data.get(#accessToken, or: $value.accessToken),
    tokenType: data.get(#tokenType, or: $value.tokenType),
    expiresIn: data.get(#expiresIn, or: $value.expiresIn),
    refreshToken: data.get(#refreshToken, or: $value.refreshToken),
    scope: data.get(#scope, or: $value.scope),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  GetTokenMetaResponseCopyWith<$R2, GetTokenMetaResponse, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _GetTokenMetaResponseCopyWithImpl($value, $cast, t);
}
