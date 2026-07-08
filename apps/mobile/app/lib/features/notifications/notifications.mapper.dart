// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notifications.dart';

class NotificationPayloadMapper extends ClassMapperBase<NotificationPayload> {
  NotificationPayloadMapper._();

  static NotificationPayloadMapper? _instance;
  static NotificationPayloadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationPayloadMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationPayload';

  static String _$destination(NotificationPayload v) => v.destination;
  static const Field<NotificationPayload, String> _f$destination = Field(
    'destination',
    _$destination,
  );

  @override
  final MappableFields<NotificationPayload> fields = const {
    #destination: _f$destination,
  };

  static NotificationPayload _instantiate(DecodingData data) {
    return NotificationPayload(destination: data.dec(_f$destination));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationPayload fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationPayload>(map);
  }

  static NotificationPayload fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationPayload>(json);
  }
}

mixin NotificationPayloadMappable {
  String toJson() {
    return NotificationPayloadMapper.ensureInitialized()
        .encodeJson<NotificationPayload>(this as NotificationPayload);
  }

  Map<String, dynamic> toMap() {
    return NotificationPayloadMapper.ensureInitialized()
        .encodeMap<NotificationPayload>(this as NotificationPayload);
  }

  NotificationPayloadCopyWith<
    NotificationPayload,
    NotificationPayload,
    NotificationPayload
  >
  get copyWith =>
      _NotificationPayloadCopyWithImpl<
        NotificationPayload,
        NotificationPayload
      >(this as NotificationPayload, $identity, $identity);
  @override
  String toString() {
    return NotificationPayloadMapper.ensureInitialized().stringifyValue(
      this as NotificationPayload,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotificationPayloadMapper.ensureInitialized().equalsValue(
      this as NotificationPayload,
      other,
    );
  }

  @override
  int get hashCode {
    return NotificationPayloadMapper.ensureInitialized().hashValue(
      this as NotificationPayload,
    );
  }
}

extension NotificationPayloadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationPayload, $Out> {
  NotificationPayloadCopyWith<$R, NotificationPayload, $Out>
  get $asNotificationPayload => $base.as(
    (v, t, t2) => _NotificationPayloadCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NotificationPayloadCopyWith<
  $R,
  $In extends NotificationPayload,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? destination});
  NotificationPayloadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotificationPayloadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationPayload, $Out>
    implements NotificationPayloadCopyWith<$R, NotificationPayload, $Out> {
  _NotificationPayloadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationPayload> $mapper =
      NotificationPayloadMapper.ensureInitialized();
  @override
  $R call({String? destination}) => $apply(
    FieldCopyWithData({if (destination != null) #destination: destination}),
  );
  @override
  NotificationPayload $make(CopyWithData data) => NotificationPayload(
    destination: data.get(#destination, or: $value.destination),
  );

  @override
  NotificationPayloadCopyWith<$R2, NotificationPayload, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NotificationPayloadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

