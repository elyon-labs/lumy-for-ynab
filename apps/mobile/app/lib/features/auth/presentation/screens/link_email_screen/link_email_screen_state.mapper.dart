// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'link_email_screen_state.dart';

class LinkEmailScreenStateMapper extends ClassMapperBase<LinkEmailScreenState> {
  LinkEmailScreenStateMapper._();

  static LinkEmailScreenStateMapper? _instance;
  static LinkEmailScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinkEmailScreenStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LinkEmailScreenState';

  static Async<Object> _$login(LinkEmailScreenState v) => v.login;
  static const Field<LinkEmailScreenState, Async<Object>> _f$login = Field(
    'login',
    _$login,
  );
  static bool _$isExistingUser(LinkEmailScreenState v) => v.isExistingUser;
  static const Field<LinkEmailScreenState, bool> _f$isExistingUser = Field(
    'isExistingUser',
    _$isExistingUser,
    key: r'is_existing_user',
  );
  static bool _$isUserLoggedIn(LinkEmailScreenState v) => v.isUserLoggedIn;
  static const Field<LinkEmailScreenState, bool> _f$isUserLoggedIn = Field(
    'isUserLoggedIn',
    _$isUserLoggedIn,
    key: r'is_user_logged_in',
  );
  static bool _$isUserAnonymous(LinkEmailScreenState v) => v.isUserAnonymous;
  static const Field<LinkEmailScreenState, bool> _f$isUserAnonymous = Field(
    'isUserAnonymous',
    _$isUserAnonymous,
    key: r'is_user_anonymous',
  );
  static Duration _$timeUntilMagicLinkResend(LinkEmailScreenState v) =>
      v.timeUntilMagicLinkResend;
  static const Field<LinkEmailScreenState, Duration>
  _f$timeUntilMagicLinkResend = Field(
    'timeUntilMagicLinkResend',
    _$timeUntilMagicLinkResend,
    key: r'time_until_magic_link_resend',
  );

  @override
  final MappableFields<LinkEmailScreenState> fields = const {
    #login: _f$login,
    #isExistingUser: _f$isExistingUser,
    #isUserLoggedIn: _f$isUserLoggedIn,
    #isUserAnonymous: _f$isUserAnonymous,
    #timeUntilMagicLinkResend: _f$timeUntilMagicLinkResend,
  };

  static LinkEmailScreenState _instantiate(DecodingData data) {
    return LinkEmailScreenState(
      login: data.dec(_f$login),
      isExistingUser: data.dec(_f$isExistingUser),
      isUserLoggedIn: data.dec(_f$isUserLoggedIn),
      isUserAnonymous: data.dec(_f$isUserAnonymous),
      timeUntilMagicLinkResend: data.dec(_f$timeUntilMagicLinkResend),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinkEmailScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinkEmailScreenState>(map);
  }

  static LinkEmailScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<LinkEmailScreenState>(json);
  }
}

mixin LinkEmailScreenStateMappable {
  String toJson() {
    return LinkEmailScreenStateMapper.ensureInitialized()
        .encodeJson<LinkEmailScreenState>(this as LinkEmailScreenState);
  }

  Map<String, dynamic> toMap() {
    return LinkEmailScreenStateMapper.ensureInitialized()
        .encodeMap<LinkEmailScreenState>(this as LinkEmailScreenState);
  }

  LinkEmailScreenStateCopyWith<
    LinkEmailScreenState,
    LinkEmailScreenState,
    LinkEmailScreenState
  >
  get copyWith =>
      _LinkEmailScreenStateCopyWithImpl<
        LinkEmailScreenState,
        LinkEmailScreenState
      >(this as LinkEmailScreenState, $identity, $identity);
  @override
  String toString() {
    return LinkEmailScreenStateMapper.ensureInitialized().stringifyValue(
      this as LinkEmailScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinkEmailScreenStateMapper.ensureInitialized().equalsValue(
      this as LinkEmailScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return LinkEmailScreenStateMapper.ensureInitialized().hashValue(
      this as LinkEmailScreenState,
    );
  }
}

extension LinkEmailScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinkEmailScreenState, $Out> {
  LinkEmailScreenStateCopyWith<$R, LinkEmailScreenState, $Out>
  get $asLinkEmailScreenState => $base.as(
    (v, t, t2) => _LinkEmailScreenStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LinkEmailScreenStateCopyWith<
  $R,
  $In extends LinkEmailScreenState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Async<Object>? login,
    bool? isExistingUser,
    bool? isUserLoggedIn,
    bool? isUserAnonymous,
    Duration? timeUntilMagicLinkResend,
  });
  LinkEmailScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LinkEmailScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinkEmailScreenState, $Out>
    implements LinkEmailScreenStateCopyWith<$R, LinkEmailScreenState, $Out> {
  _LinkEmailScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinkEmailScreenState> $mapper =
      LinkEmailScreenStateMapper.ensureInitialized();
  @override
  $R call({
    Async<Object>? login,
    bool? isExistingUser,
    bool? isUserLoggedIn,
    bool? isUserAnonymous,
    Duration? timeUntilMagicLinkResend,
  }) => $apply(
    FieldCopyWithData({
      if (login != null) #login: login,
      if (isExistingUser != null) #isExistingUser: isExistingUser,
      if (isUserLoggedIn != null) #isUserLoggedIn: isUserLoggedIn,
      if (isUserAnonymous != null) #isUserAnonymous: isUserAnonymous,
      if (timeUntilMagicLinkResend != null)
        #timeUntilMagicLinkResend: timeUntilMagicLinkResend,
    }),
  );
  @override
  LinkEmailScreenState $make(CopyWithData data) => LinkEmailScreenState(
    login: data.get(#login, or: $value.login),
    isExistingUser: data.get(#isExistingUser, or: $value.isExistingUser),
    isUserLoggedIn: data.get(#isUserLoggedIn, or: $value.isUserLoggedIn),
    isUserAnonymous: data.get(#isUserAnonymous, or: $value.isUserAnonymous),
    timeUntilMagicLinkResend: data.get(
      #timeUntilMagicLinkResend,
      or: $value.timeUntilMagicLinkResend,
    ),
  );

  @override
  LinkEmailScreenStateCopyWith<$R2, LinkEmailScreenState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LinkEmailScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

