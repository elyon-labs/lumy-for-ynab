// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'write_access_screen_state.dart';

class WriteAccessScreenStateMapper
    extends ClassMapperBase<WriteAccessScreenState> {
  WriteAccessScreenStateMapper._();

  static WriteAccessScreenStateMapper? _instance;
  static WriteAccessScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WriteAccessScreenStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'WriteAccessScreenState';

  static Async<bool> _$accessRequest(WriteAccessScreenState v) =>
      v.accessRequest;
  static const Field<WriteAccessScreenState, Async<bool>> _f$accessRequest =
      Field('accessRequest', _$accessRequest, key: r'access_request');

  @override
  final MappableFields<WriteAccessScreenState> fields = const {
    #accessRequest: _f$accessRequest,
  };

  static WriteAccessScreenState _instantiate(DecodingData data) {
    return WriteAccessScreenState(accessRequest: data.dec(_f$accessRequest));
  }

  @override
  final Function instantiate = _instantiate;

  static WriteAccessScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WriteAccessScreenState>(map);
  }

  static WriteAccessScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<WriteAccessScreenState>(json);
  }
}

mixin WriteAccessScreenStateMappable {
  String toJson() {
    return WriteAccessScreenStateMapper.ensureInitialized()
        .encodeJson<WriteAccessScreenState>(this as WriteAccessScreenState);
  }

  Map<String, dynamic> toMap() {
    return WriteAccessScreenStateMapper.ensureInitialized()
        .encodeMap<WriteAccessScreenState>(this as WriteAccessScreenState);
  }

  WriteAccessScreenStateCopyWith<
    WriteAccessScreenState,
    WriteAccessScreenState,
    WriteAccessScreenState
  >
  get copyWith =>
      _WriteAccessScreenStateCopyWithImpl<
        WriteAccessScreenState,
        WriteAccessScreenState
      >(this as WriteAccessScreenState, $identity, $identity);
  @override
  String toString() {
    return WriteAccessScreenStateMapper.ensureInitialized().stringifyValue(
      this as WriteAccessScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return WriteAccessScreenStateMapper.ensureInitialized().equalsValue(
      this as WriteAccessScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return WriteAccessScreenStateMapper.ensureInitialized().hashValue(
      this as WriteAccessScreenState,
    );
  }
}

extension WriteAccessScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WriteAccessScreenState, $Out> {
  WriteAccessScreenStateCopyWith<$R, WriteAccessScreenState, $Out>
  get $asWriteAccessScreenState => $base.as(
    (v, t, t2) => _WriteAccessScreenStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class WriteAccessScreenStateCopyWith<
  $R,
  $In extends WriteAccessScreenState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Async<bool>? accessRequest});
  WriteAccessScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _WriteAccessScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WriteAccessScreenState, $Out>
    implements
        WriteAccessScreenStateCopyWith<$R, WriteAccessScreenState, $Out> {
  _WriteAccessScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WriteAccessScreenState> $mapper =
      WriteAccessScreenStateMapper.ensureInitialized();
  @override
  $R call({Async<bool>? accessRequest}) => $apply(
    FieldCopyWithData({
      if (accessRequest != null) #accessRequest: accessRequest,
    }),
  );
  @override
  WriteAccessScreenState $make(CopyWithData data) => WriteAccessScreenState(
    accessRequest: data.get(#accessRequest, or: $value.accessRequest),
  );

  @override
  WriteAccessScreenStateCopyWith<$R2, WriteAccessScreenState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _WriteAccessScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

