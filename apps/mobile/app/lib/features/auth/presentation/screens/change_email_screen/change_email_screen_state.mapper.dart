// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'change_email_screen_state.dart';

class ChangeEmailScreenStateMapper
    extends ClassMapperBase<ChangeEmailScreenState> {
  ChangeEmailScreenStateMapper._();

  static ChangeEmailScreenStateMapper? _instance;
  static ChangeEmailScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChangeEmailScreenStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChangeEmailScreenState';

  static Async<Object> _$changeEmail(ChangeEmailScreenState v) => v.changeEmail;
  static const Field<ChangeEmailScreenState, Async<Object>> _f$changeEmail =
      Field('changeEmail', _$changeEmail, key: r'change_email');
  static String? _$currentEmail(ChangeEmailScreenState v) => v.currentEmail;
  static const Field<ChangeEmailScreenState, String> _f$currentEmail = Field(
    'currentEmail',
    _$currentEmail,
    key: r'current_email',
  );
  static String? _$pendingEmail(ChangeEmailScreenState v) => v.pendingEmail;
  static const Field<ChangeEmailScreenState, String> _f$pendingEmail = Field(
    'pendingEmail',
    _$pendingEmail,
    key: r'pending_email',
  );
  static Duration _$timeUntilEmailChangeResend(ChangeEmailScreenState v) =>
      v.timeUntilEmailChangeResend;
  static const Field<ChangeEmailScreenState, Duration>
  _f$timeUntilEmailChangeResend = Field(
    'timeUntilEmailChangeResend',
    _$timeUntilEmailChangeResend,
    key: r'time_until_email_change_resend',
  );

  @override
  final MappableFields<ChangeEmailScreenState> fields = const {
    #changeEmail: _f$changeEmail,
    #currentEmail: _f$currentEmail,
    #pendingEmail: _f$pendingEmail,
    #timeUntilEmailChangeResend: _f$timeUntilEmailChangeResend,
  };

  static ChangeEmailScreenState _instantiate(DecodingData data) {
    return ChangeEmailScreenState(
      changeEmail: data.dec(_f$changeEmail),
      currentEmail: data.dec(_f$currentEmail),
      pendingEmail: data.dec(_f$pendingEmail),
      timeUntilEmailChangeResend: data.dec(_f$timeUntilEmailChangeResend),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChangeEmailScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChangeEmailScreenState>(map);
  }

  static ChangeEmailScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<ChangeEmailScreenState>(json);
  }
}

mixin ChangeEmailScreenStateMappable {
  String toJson() {
    return ChangeEmailScreenStateMapper.ensureInitialized()
        .encodeJson<ChangeEmailScreenState>(this as ChangeEmailScreenState);
  }

  Map<String, dynamic> toMap() {
    return ChangeEmailScreenStateMapper.ensureInitialized()
        .encodeMap<ChangeEmailScreenState>(this as ChangeEmailScreenState);
  }

  ChangeEmailScreenStateCopyWith<
    ChangeEmailScreenState,
    ChangeEmailScreenState,
    ChangeEmailScreenState
  >
  get copyWith =>
      _ChangeEmailScreenStateCopyWithImpl<
        ChangeEmailScreenState,
        ChangeEmailScreenState
      >(this as ChangeEmailScreenState, $identity, $identity);
  @override
  String toString() {
    return ChangeEmailScreenStateMapper.ensureInitialized().stringifyValue(
      this as ChangeEmailScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChangeEmailScreenStateMapper.ensureInitialized().equalsValue(
      this as ChangeEmailScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChangeEmailScreenStateMapper.ensureInitialized().hashValue(
      this as ChangeEmailScreenState,
    );
  }
}

extension ChangeEmailScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChangeEmailScreenState, $Out> {
  ChangeEmailScreenStateCopyWith<$R, ChangeEmailScreenState, $Out>
  get $asChangeEmailScreenState => $base.as(
    (v, t, t2) => _ChangeEmailScreenStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ChangeEmailScreenStateCopyWith<
  $R,
  $In extends ChangeEmailScreenState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Async<Object>? changeEmail,
    String? currentEmail,
    String? pendingEmail,
    Duration? timeUntilEmailChangeResend,
  });
  ChangeEmailScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChangeEmailScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChangeEmailScreenState, $Out>
    implements
        ChangeEmailScreenStateCopyWith<$R, ChangeEmailScreenState, $Out> {
  _ChangeEmailScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChangeEmailScreenState> $mapper =
      ChangeEmailScreenStateMapper.ensureInitialized();
  @override
  $R call({
    Async<Object>? changeEmail,
    Object? currentEmail = $none,
    Object? pendingEmail = $none,
    Duration? timeUntilEmailChangeResend,
  }) => $apply(
    FieldCopyWithData({
      if (changeEmail != null) #changeEmail: changeEmail,
      if (currentEmail != $none) #currentEmail: currentEmail,
      if (pendingEmail != $none) #pendingEmail: pendingEmail,
      if (timeUntilEmailChangeResend != null)
        #timeUntilEmailChangeResend: timeUntilEmailChangeResend,
    }),
  );
  @override
  ChangeEmailScreenState $make(CopyWithData data) => ChangeEmailScreenState(
    changeEmail: data.get(#changeEmail, or: $value.changeEmail),
    currentEmail: data.get(#currentEmail, or: $value.currentEmail),
    pendingEmail: data.get(#pendingEmail, or: $value.pendingEmail),
    timeUntilEmailChangeResend: data.get(
      #timeUntilEmailChangeResend,
      or: $value.timeUntilEmailChangeResend,
    ),
  );

  @override
  ChangeEmailScreenStateCopyWith<$R2, ChangeEmailScreenState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChangeEmailScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

