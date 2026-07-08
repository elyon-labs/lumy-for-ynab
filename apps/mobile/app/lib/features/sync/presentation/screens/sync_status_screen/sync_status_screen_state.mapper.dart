// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sync_status_screen_state.dart';

class SyncStatusScreenStateMapper
    extends ClassMapperBase<SyncStatusScreenState> {
  SyncStatusScreenStateMapper._();

  static SyncStatusScreenStateMapper? _instance;
  static SyncStatusScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyncStatusScreenStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SyncStatusScreenState';

  static Async<User> _$user(SyncStatusScreenState v) => v.user;
  static const Field<SyncStatusScreenState, Async<User>> _f$user = Field(
    'user',
    _$user,
  );
  static bool _$hasUnsyncedData(SyncStatusScreenState v) => v.hasUnsyncedData;
  static const Field<SyncStatusScreenState, bool> _f$hasUnsyncedData = Field(
    'hasUnsyncedData',
    _$hasUnsyncedData,
    key: r'has_unsynced_data',
  );
  static bool _$hasSyncedData(SyncStatusScreenState v) => v.hasSyncedData;
  static const Field<SyncStatusScreenState, bool> _f$hasSyncedData = Field(
    'hasSyncedData',
    _$hasSyncedData,
    key: r'has_synced_data',
  );

  @override
  final MappableFields<SyncStatusScreenState> fields = const {
    #user: _f$user,
    #hasUnsyncedData: _f$hasUnsyncedData,
    #hasSyncedData: _f$hasSyncedData,
  };

  static SyncStatusScreenState _instantiate(DecodingData data) {
    return SyncStatusScreenState(
      user: data.dec(_f$user),
      hasUnsyncedData: data.dec(_f$hasUnsyncedData),
      hasSyncedData: data.dec(_f$hasSyncedData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SyncStatusScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyncStatusScreenState>(map);
  }

  static SyncStatusScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<SyncStatusScreenState>(json);
  }
}

mixin SyncStatusScreenStateMappable {
  String toJson() {
    return SyncStatusScreenStateMapper.ensureInitialized()
        .encodeJson<SyncStatusScreenState>(this as SyncStatusScreenState);
  }

  Map<String, dynamic> toMap() {
    return SyncStatusScreenStateMapper.ensureInitialized()
        .encodeMap<SyncStatusScreenState>(this as SyncStatusScreenState);
  }

  SyncStatusScreenStateCopyWith<
    SyncStatusScreenState,
    SyncStatusScreenState,
    SyncStatusScreenState
  >
  get copyWith =>
      _SyncStatusScreenStateCopyWithImpl<
        SyncStatusScreenState,
        SyncStatusScreenState
      >(this as SyncStatusScreenState, $identity, $identity);
  @override
  String toString() {
    return SyncStatusScreenStateMapper.ensureInitialized().stringifyValue(
      this as SyncStatusScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SyncStatusScreenStateMapper.ensureInitialized().equalsValue(
      this as SyncStatusScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return SyncStatusScreenStateMapper.ensureInitialized().hashValue(
      this as SyncStatusScreenState,
    );
  }
}

extension SyncStatusScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyncStatusScreenState, $Out> {
  SyncStatusScreenStateCopyWith<$R, SyncStatusScreenState, $Out>
  get $asSyncStatusScreenState => $base.as(
    (v, t, t2) => _SyncStatusScreenStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SyncStatusScreenStateCopyWith<
  $R,
  $In extends SyncStatusScreenState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Async<User>? user, bool? hasUnsyncedData, bool? hasSyncedData});
  SyncStatusScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SyncStatusScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyncStatusScreenState, $Out>
    implements SyncStatusScreenStateCopyWith<$R, SyncStatusScreenState, $Out> {
  _SyncStatusScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyncStatusScreenState> $mapper =
      SyncStatusScreenStateMapper.ensureInitialized();
  @override
  $R call({Async<User>? user, bool? hasUnsyncedData, bool? hasSyncedData}) =>
      $apply(
        FieldCopyWithData({
          if (user != null) #user: user,
          if (hasUnsyncedData != null) #hasUnsyncedData: hasUnsyncedData,
          if (hasSyncedData != null) #hasSyncedData: hasSyncedData,
        }),
      );
  @override
  SyncStatusScreenState $make(CopyWithData data) => SyncStatusScreenState(
    user: data.get(#user, or: $value.user),
    hasUnsyncedData: data.get(#hasUnsyncedData, or: $value.hasUnsyncedData),
    hasSyncedData: data.get(#hasSyncedData, or: $value.hasSyncedData),
  );

  @override
  SyncStatusScreenStateCopyWith<$R2, SyncStatusScreenState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SyncStatusScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

