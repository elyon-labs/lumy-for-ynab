// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upsert_user.dart';

class UpsertUserMapper extends ClassMapperBase<UpsertUser> {
  UpsertUserMapper._();

  static UpsertUserMapper? _instance;
  static UpsertUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpsertUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UpsertUser';

  static String _$id(UpsertUser v) => v.id;
  static const Field<UpsertUser, String> _f$id = Field('id', _$id);
  static String? _$ynabUserId(UpsertUser v) => v.ynabUserId;
  static const Field<UpsertUser, String> _f$ynabUserId = Field(
    'ynabUserId',
    _$ynabUserId,
    key: r'ynab_user_id',
  );
  static String? _$email(UpsertUser v) => v.email;
  static const Field<UpsertUser, String> _f$email = Field('email', _$email);

  @override
  final MappableFields<UpsertUser> fields = const {
    #id: _f$id,
    #ynabUserId: _f$ynabUserId,
    #email: _f$email,
  };
  @override
  final bool ignoreNull = true;

  static UpsertUser _instantiate(DecodingData data) {
    return UpsertUser(
      id: data.dec(_f$id),
      ynabUserId: data.dec(_f$ynabUserId),
      email: data.dec(_f$email),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpsertUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpsertUser>(map);
  }

  static UpsertUser fromJson(String json) {
    return ensureInitialized().decodeJson<UpsertUser>(json);
  }
}

mixin UpsertUserMappable {
  String toJson() {
    return UpsertUserMapper.ensureInitialized().encodeJson<UpsertUser>(
      this as UpsertUser,
    );
  }

  Map<String, dynamic> toMap() {
    return UpsertUserMapper.ensureInitialized().encodeMap<UpsertUser>(
      this as UpsertUser,
    );
  }

  UpsertUserCopyWith<UpsertUser, UpsertUser, UpsertUser> get copyWith =>
      _UpsertUserCopyWithImpl<UpsertUser, UpsertUser>(
        this as UpsertUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UpsertUserMapper.ensureInitialized().stringifyValue(
      this as UpsertUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpsertUserMapper.ensureInitialized().equalsValue(
      this as UpsertUser,
      other,
    );
  }

  @override
  int get hashCode {
    return UpsertUserMapper.ensureInitialized().hashValue(this as UpsertUser);
  }
}

extension UpsertUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpsertUser, $Out> {
  UpsertUserCopyWith<$R, UpsertUser, $Out> get $asUpsertUser =>
      $base.as((v, t, t2) => _UpsertUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UpsertUserCopyWith<$R, $In extends UpsertUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? ynabUserId, String? email});
  UpsertUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UpsertUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpsertUser, $Out>
    implements UpsertUserCopyWith<$R, UpsertUser, $Out> {
  _UpsertUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpsertUser> $mapper =
      UpsertUserMapper.ensureInitialized();
  @override
  $R call({String? id, Object? ynabUserId = $none, Object? email = $none}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (ynabUserId != $none) #ynabUserId: ynabUserId,
          if (email != $none) #email: email,
        }),
      );
  @override
  UpsertUser $make(CopyWithData data) => UpsertUser(
    id: data.get(#id, or: $value.id),
    ynabUserId: data.get(#ynabUserId, or: $value.ynabUserId),
    email: data.get(#email, or: $value.email),
  );

  @override
  UpsertUserCopyWith<$R2, UpsertUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UpsertUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

