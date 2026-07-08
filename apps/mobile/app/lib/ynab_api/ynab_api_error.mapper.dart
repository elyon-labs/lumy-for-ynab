// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ynab_api_error.dart';

class YnabApiErrorMapper extends ClassMapperBase<YnabApiError> {
  YnabApiErrorMapper._();

  static YnabApiErrorMapper? _instance;
  static YnabApiErrorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = YnabApiErrorMapper._());
      BadRequestMapper.ensureInitialized();
      NotAuthorizedMapper.ensureInitialized();
      SubscriptionLapsedMapper.ensureInitialized();
      TrialExpiredMapper.ensureInitialized();
      UnauthorizedScopeMapper.ensureInitialized();
      DataLimitReachedMapper.ensureInitialized();
      NotFoundMapper.ensureInitialized();
      ResourceNotFoundMapper.ensureInitialized();
      ConflictMapper.ensureInitialized();
      TooManyRequestsMapper.ensureInitialized();
      InternalServerErrorMapper.ensureInitialized();
      ServiceUnavailableMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'YnabApiError';

  static String _$id(YnabApiError v) => v.id;
  static const Field<YnabApiError, String> _f$id = Field('id', _$id);
  static String _$name(YnabApiError v) => v.name;
  static const Field<YnabApiError, String> _f$name = Field('name', _$name);
  static String _$detail(YnabApiError v) => v.detail;
  static const Field<YnabApiError, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<YnabApiError> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  static YnabApiError _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'YnabApiError',
      'id',
      '${data.value['id']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static YnabApiError fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<YnabApiError>(map);
  }

  static YnabApiError fromJson(String json) {
    return ensureInitialized().decodeJson<YnabApiError>(json);
  }
}

mixin YnabApiErrorMappable {
  String toJson();
  Map<String, dynamic> toMap();
  YnabApiErrorCopyWith<YnabApiError, YnabApiError, YnabApiError> get copyWith;
}

abstract class YnabApiErrorCopyWith<$R, $In extends YnabApiError, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, String? detail});
  YnabApiErrorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BadRequestMapper extends SubClassMapperBase<BadRequest> {
  BadRequestMapper._();

  static BadRequestMapper? _instance;
  static BadRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BadRequestMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BadRequest';

  static String _$id(BadRequest v) => v.id;
  static const Field<BadRequest, String> _f$id = Field('id', _$id);
  static String _$name(BadRequest v) => v.name;
  static const Field<BadRequest, String> _f$name = Field('name', _$name);
  static String _$detail(BadRequest v) => v.detail;
  static const Field<BadRequest, String> _f$detail = Field('detail', _$detail);

  @override
  final MappableFields<BadRequest> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '400';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static BadRequest _instantiate(DecodingData data) {
    return BadRequest(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BadRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BadRequest>(map);
  }

  static BadRequest fromJson(String json) {
    return ensureInitialized().decodeJson<BadRequest>(json);
  }
}

mixin BadRequestMappable {
  String toJson() {
    return BadRequestMapper.ensureInitialized().encodeJson<BadRequest>(
      this as BadRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return BadRequestMapper.ensureInitialized().encodeMap<BadRequest>(
      this as BadRequest,
    );
  }

  BadRequestCopyWith<BadRequest, BadRequest, BadRequest> get copyWith =>
      _BadRequestCopyWithImpl<BadRequest, BadRequest>(
        this as BadRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BadRequestMapper.ensureInitialized().stringifyValue(
      this as BadRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return BadRequestMapper.ensureInitialized().equalsValue(
      this as BadRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return BadRequestMapper.ensureInitialized().hashValue(this as BadRequest);
  }
}

extension BadRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BadRequest, $Out> {
  BadRequestCopyWith<$R, BadRequest, $Out> get $asBadRequest =>
      $base.as((v, t, t2) => _BadRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BadRequestCopyWith<$R, $In extends BadRequest, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  BadRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BadRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BadRequest, $Out>
    implements BadRequestCopyWith<$R, BadRequest, $Out> {
  _BadRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BadRequest> $mapper =
      BadRequestMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  BadRequest $make(CopyWithData data) => BadRequest(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  BadRequestCopyWith<$R2, BadRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BadRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotAuthorizedMapper extends SubClassMapperBase<NotAuthorized> {
  NotAuthorizedMapper._();

  static NotAuthorizedMapper? _instance;
  static NotAuthorizedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotAuthorizedMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NotAuthorized';

  static String _$id(NotAuthorized v) => v.id;
  static const Field<NotAuthorized, String> _f$id = Field('id', _$id);
  static String _$name(NotAuthorized v) => v.name;
  static const Field<NotAuthorized, String> _f$name = Field('name', _$name);
  static String _$detail(NotAuthorized v) => v.detail;
  static const Field<NotAuthorized, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<NotAuthorized> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '401';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static NotAuthorized _instantiate(DecodingData data) {
    return NotAuthorized(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotAuthorized fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotAuthorized>(map);
  }

  static NotAuthorized fromJson(String json) {
    return ensureInitialized().decodeJson<NotAuthorized>(json);
  }
}

mixin NotAuthorizedMappable {
  String toJson() {
    return NotAuthorizedMapper.ensureInitialized().encodeJson<NotAuthorized>(
      this as NotAuthorized,
    );
  }

  Map<String, dynamic> toMap() {
    return NotAuthorizedMapper.ensureInitialized().encodeMap<NotAuthorized>(
      this as NotAuthorized,
    );
  }

  NotAuthorizedCopyWith<NotAuthorized, NotAuthorized, NotAuthorized>
  get copyWith => _NotAuthorizedCopyWithImpl<NotAuthorized, NotAuthorized>(
    this as NotAuthorized,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NotAuthorizedMapper.ensureInitialized().stringifyValue(
      this as NotAuthorized,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotAuthorizedMapper.ensureInitialized().equalsValue(
      this as NotAuthorized,
      other,
    );
  }

  @override
  int get hashCode {
    return NotAuthorizedMapper.ensureInitialized().hashValue(
      this as NotAuthorized,
    );
  }
}

extension NotAuthorizedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotAuthorized, $Out> {
  NotAuthorizedCopyWith<$R, NotAuthorized, $Out> get $asNotAuthorized =>
      $base.as((v, t, t2) => _NotAuthorizedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotAuthorizedCopyWith<$R, $In extends NotAuthorized, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  NotAuthorizedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NotAuthorizedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotAuthorized, $Out>
    implements NotAuthorizedCopyWith<$R, NotAuthorized, $Out> {
  _NotAuthorizedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotAuthorized> $mapper =
      NotAuthorizedMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  NotAuthorized $make(CopyWithData data) => NotAuthorized(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  NotAuthorizedCopyWith<$R2, NotAuthorized, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotAuthorizedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubscriptionLapsedMapper extends SubClassMapperBase<SubscriptionLapsed> {
  SubscriptionLapsedMapper._();

  static SubscriptionLapsedMapper? _instance;
  static SubscriptionLapsedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubscriptionLapsedMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SubscriptionLapsed';

  static String _$id(SubscriptionLapsed v) => v.id;
  static const Field<SubscriptionLapsed, String> _f$id = Field('id', _$id);
  static String _$name(SubscriptionLapsed v) => v.name;
  static const Field<SubscriptionLapsed, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$detail(SubscriptionLapsed v) => v.detail;
  static const Field<SubscriptionLapsed, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<SubscriptionLapsed> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '403.1';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static SubscriptionLapsed _instantiate(DecodingData data) {
    return SubscriptionLapsed(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubscriptionLapsed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubscriptionLapsed>(map);
  }

  static SubscriptionLapsed fromJson(String json) {
    return ensureInitialized().decodeJson<SubscriptionLapsed>(json);
  }
}

mixin SubscriptionLapsedMappable {
  String toJson() {
    return SubscriptionLapsedMapper.ensureInitialized()
        .encodeJson<SubscriptionLapsed>(this as SubscriptionLapsed);
  }

  Map<String, dynamic> toMap() {
    return SubscriptionLapsedMapper.ensureInitialized()
        .encodeMap<SubscriptionLapsed>(this as SubscriptionLapsed);
  }

  SubscriptionLapsedCopyWith<
    SubscriptionLapsed,
    SubscriptionLapsed,
    SubscriptionLapsed
  >
  get copyWith =>
      _SubscriptionLapsedCopyWithImpl<SubscriptionLapsed, SubscriptionLapsed>(
        this as SubscriptionLapsed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubscriptionLapsedMapper.ensureInitialized().stringifyValue(
      this as SubscriptionLapsed,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubscriptionLapsedMapper.ensureInitialized().equalsValue(
      this as SubscriptionLapsed,
      other,
    );
  }

  @override
  int get hashCode {
    return SubscriptionLapsedMapper.ensureInitialized().hashValue(
      this as SubscriptionLapsed,
    );
  }
}

extension SubscriptionLapsedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubscriptionLapsed, $Out> {
  SubscriptionLapsedCopyWith<$R, SubscriptionLapsed, $Out>
  get $asSubscriptionLapsed => $base.as(
    (v, t, t2) => _SubscriptionLapsedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubscriptionLapsedCopyWith<
  $R,
  $In extends SubscriptionLapsed,
  $Out
>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  SubscriptionLapsedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubscriptionLapsedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubscriptionLapsed, $Out>
    implements SubscriptionLapsedCopyWith<$R, SubscriptionLapsed, $Out> {
  _SubscriptionLapsedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubscriptionLapsed> $mapper =
      SubscriptionLapsedMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  SubscriptionLapsed $make(CopyWithData data) => SubscriptionLapsed(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  SubscriptionLapsedCopyWith<$R2, SubscriptionLapsed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubscriptionLapsedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TrialExpiredMapper extends SubClassMapperBase<TrialExpired> {
  TrialExpiredMapper._();

  static TrialExpiredMapper? _instance;
  static TrialExpiredMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TrialExpiredMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TrialExpired';

  static String _$id(TrialExpired v) => v.id;
  static const Field<TrialExpired, String> _f$id = Field('id', _$id);
  static String _$name(TrialExpired v) => v.name;
  static const Field<TrialExpired, String> _f$name = Field('name', _$name);
  static String _$detail(TrialExpired v) => v.detail;
  static const Field<TrialExpired, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<TrialExpired> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '403.2';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static TrialExpired _instantiate(DecodingData data) {
    return TrialExpired(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TrialExpired fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TrialExpired>(map);
  }

  static TrialExpired fromJson(String json) {
    return ensureInitialized().decodeJson<TrialExpired>(json);
  }
}

mixin TrialExpiredMappable {
  String toJson() {
    return TrialExpiredMapper.ensureInitialized().encodeJson<TrialExpired>(
      this as TrialExpired,
    );
  }

  Map<String, dynamic> toMap() {
    return TrialExpiredMapper.ensureInitialized().encodeMap<TrialExpired>(
      this as TrialExpired,
    );
  }

  TrialExpiredCopyWith<TrialExpired, TrialExpired, TrialExpired> get copyWith =>
      _TrialExpiredCopyWithImpl<TrialExpired, TrialExpired>(
        this as TrialExpired,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TrialExpiredMapper.ensureInitialized().stringifyValue(
      this as TrialExpired,
    );
  }

  @override
  bool operator ==(Object other) {
    return TrialExpiredMapper.ensureInitialized().equalsValue(
      this as TrialExpired,
      other,
    );
  }

  @override
  int get hashCode {
    return TrialExpiredMapper.ensureInitialized().hashValue(
      this as TrialExpired,
    );
  }
}

extension TrialExpiredValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TrialExpired, $Out> {
  TrialExpiredCopyWith<$R, TrialExpired, $Out> get $asTrialExpired =>
      $base.as((v, t, t2) => _TrialExpiredCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TrialExpiredCopyWith<$R, $In extends TrialExpired, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  TrialExpiredCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TrialExpiredCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TrialExpired, $Out>
    implements TrialExpiredCopyWith<$R, TrialExpired, $Out> {
  _TrialExpiredCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TrialExpired> $mapper =
      TrialExpiredMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  TrialExpired $make(CopyWithData data) => TrialExpired(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  TrialExpiredCopyWith<$R2, TrialExpired, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TrialExpiredCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UnauthorizedScopeMapper extends SubClassMapperBase<UnauthorizedScope> {
  UnauthorizedScopeMapper._();

  static UnauthorizedScopeMapper? _instance;
  static UnauthorizedScopeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnauthorizedScopeMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UnauthorizedScope';

  static String _$id(UnauthorizedScope v) => v.id;
  static const Field<UnauthorizedScope, String> _f$id = Field('id', _$id);
  static String _$name(UnauthorizedScope v) => v.name;
  static const Field<UnauthorizedScope, String> _f$name = Field('name', _$name);
  static String _$detail(UnauthorizedScope v) => v.detail;
  static const Field<UnauthorizedScope, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<UnauthorizedScope> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '403.3';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static UnauthorizedScope _instantiate(DecodingData data) {
    return UnauthorizedScope(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UnauthorizedScope fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UnauthorizedScope>(map);
  }

  static UnauthorizedScope fromJson(String json) {
    return ensureInitialized().decodeJson<UnauthorizedScope>(json);
  }
}

mixin UnauthorizedScopeMappable {
  String toJson() {
    return UnauthorizedScopeMapper.ensureInitialized()
        .encodeJson<UnauthorizedScope>(this as UnauthorizedScope);
  }

  Map<String, dynamic> toMap() {
    return UnauthorizedScopeMapper.ensureInitialized()
        .encodeMap<UnauthorizedScope>(this as UnauthorizedScope);
  }

  UnauthorizedScopeCopyWith<
    UnauthorizedScope,
    UnauthorizedScope,
    UnauthorizedScope
  >
  get copyWith =>
      _UnauthorizedScopeCopyWithImpl<UnauthorizedScope, UnauthorizedScope>(
        this as UnauthorizedScope,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UnauthorizedScopeMapper.ensureInitialized().stringifyValue(
      this as UnauthorizedScope,
    );
  }

  @override
  bool operator ==(Object other) {
    return UnauthorizedScopeMapper.ensureInitialized().equalsValue(
      this as UnauthorizedScope,
      other,
    );
  }

  @override
  int get hashCode {
    return UnauthorizedScopeMapper.ensureInitialized().hashValue(
      this as UnauthorizedScope,
    );
  }
}

extension UnauthorizedScopeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UnauthorizedScope, $Out> {
  UnauthorizedScopeCopyWith<$R, UnauthorizedScope, $Out>
  get $asUnauthorizedScope => $base.as(
    (v, t, t2) => _UnauthorizedScopeCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UnauthorizedScopeCopyWith<
  $R,
  $In extends UnauthorizedScope,
  $Out
>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  UnauthorizedScopeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UnauthorizedScopeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UnauthorizedScope, $Out>
    implements UnauthorizedScopeCopyWith<$R, UnauthorizedScope, $Out> {
  _UnauthorizedScopeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UnauthorizedScope> $mapper =
      UnauthorizedScopeMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  UnauthorizedScope $make(CopyWithData data) => UnauthorizedScope(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  UnauthorizedScopeCopyWith<$R2, UnauthorizedScope, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UnauthorizedScopeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DataLimitReachedMapper extends SubClassMapperBase<DataLimitReached> {
  DataLimitReachedMapper._();

  static DataLimitReachedMapper? _instance;
  static DataLimitReachedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DataLimitReachedMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'DataLimitReached';

  static String _$id(DataLimitReached v) => v.id;
  static const Field<DataLimitReached, String> _f$id = Field('id', _$id);
  static String _$name(DataLimitReached v) => v.name;
  static const Field<DataLimitReached, String> _f$name = Field('name', _$name);
  static String _$detail(DataLimitReached v) => v.detail;
  static const Field<DataLimitReached, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<DataLimitReached> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '403.4';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static DataLimitReached _instantiate(DecodingData data) {
    return DataLimitReached(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DataLimitReached fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DataLimitReached>(map);
  }

  static DataLimitReached fromJson(String json) {
    return ensureInitialized().decodeJson<DataLimitReached>(json);
  }
}

mixin DataLimitReachedMappable {
  String toJson() {
    return DataLimitReachedMapper.ensureInitialized()
        .encodeJson<DataLimitReached>(this as DataLimitReached);
  }

  Map<String, dynamic> toMap() {
    return DataLimitReachedMapper.ensureInitialized()
        .encodeMap<DataLimitReached>(this as DataLimitReached);
  }

  DataLimitReachedCopyWith<DataLimitReached, DataLimitReached, DataLimitReached>
  get copyWith =>
      _DataLimitReachedCopyWithImpl<DataLimitReached, DataLimitReached>(
        this as DataLimitReached,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DataLimitReachedMapper.ensureInitialized().stringifyValue(
      this as DataLimitReached,
    );
  }

  @override
  bool operator ==(Object other) {
    return DataLimitReachedMapper.ensureInitialized().equalsValue(
      this as DataLimitReached,
      other,
    );
  }

  @override
  int get hashCode {
    return DataLimitReachedMapper.ensureInitialized().hashValue(
      this as DataLimitReached,
    );
  }
}

extension DataLimitReachedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DataLimitReached, $Out> {
  DataLimitReachedCopyWith<$R, DataLimitReached, $Out>
  get $asDataLimitReached =>
      $base.as((v, t, t2) => _DataLimitReachedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DataLimitReachedCopyWith<$R, $In extends DataLimitReached, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  DataLimitReachedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DataLimitReachedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DataLimitReached, $Out>
    implements DataLimitReachedCopyWith<$R, DataLimitReached, $Out> {
  _DataLimitReachedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DataLimitReached> $mapper =
      DataLimitReachedMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  DataLimitReached $make(CopyWithData data) => DataLimitReached(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  DataLimitReachedCopyWith<$R2, DataLimitReached, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DataLimitReachedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotFoundMapper extends SubClassMapperBase<NotFound> {
  NotFoundMapper._();

  static NotFoundMapper? _instance;
  static NotFoundMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotFoundMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NotFound';

  static String _$id(NotFound v) => v.id;
  static const Field<NotFound, String> _f$id = Field('id', _$id);
  static String _$name(NotFound v) => v.name;
  static const Field<NotFound, String> _f$name = Field('name', _$name);
  static String _$detail(NotFound v) => v.detail;
  static const Field<NotFound, String> _f$detail = Field('detail', _$detail);

  @override
  final MappableFields<NotFound> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '404.1';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static NotFound _instantiate(DecodingData data) {
    return NotFound(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotFound fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotFound>(map);
  }

  static NotFound fromJson(String json) {
    return ensureInitialized().decodeJson<NotFound>(json);
  }
}

mixin NotFoundMappable {
  String toJson() {
    return NotFoundMapper.ensureInitialized().encodeJson<NotFound>(
      this as NotFound,
    );
  }

  Map<String, dynamic> toMap() {
    return NotFoundMapper.ensureInitialized().encodeMap<NotFound>(
      this as NotFound,
    );
  }

  NotFoundCopyWith<NotFound, NotFound, NotFound> get copyWith =>
      _NotFoundCopyWithImpl<NotFound, NotFound>(
        this as NotFound,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotFoundMapper.ensureInitialized().stringifyValue(this as NotFound);
  }

  @override
  bool operator ==(Object other) {
    return NotFoundMapper.ensureInitialized().equalsValue(
      this as NotFound,
      other,
    );
  }

  @override
  int get hashCode {
    return NotFoundMapper.ensureInitialized().hashValue(this as NotFound);
  }
}

extension NotFoundValueCopy<$R, $Out> on ObjectCopyWith<$R, NotFound, $Out> {
  NotFoundCopyWith<$R, NotFound, $Out> get $asNotFound =>
      $base.as((v, t, t2) => _NotFoundCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotFoundCopyWith<$R, $In extends NotFound, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  NotFoundCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NotFoundCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotFound, $Out>
    implements NotFoundCopyWith<$R, NotFound, $Out> {
  _NotFoundCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotFound> $mapper =
      NotFoundMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  NotFound $make(CopyWithData data) => NotFound(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  NotFoundCopyWith<$R2, NotFound, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotFoundCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ResourceNotFoundMapper extends SubClassMapperBase<ResourceNotFound> {
  ResourceNotFoundMapper._();

  static ResourceNotFoundMapper? _instance;
  static ResourceNotFoundMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ResourceNotFoundMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ResourceNotFound';

  static String _$id(ResourceNotFound v) => v.id;
  static const Field<ResourceNotFound, String> _f$id = Field('id', _$id);
  static String _$name(ResourceNotFound v) => v.name;
  static const Field<ResourceNotFound, String> _f$name = Field('name', _$name);
  static String _$detail(ResourceNotFound v) => v.detail;
  static const Field<ResourceNotFound, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<ResourceNotFound> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '404.2';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static ResourceNotFound _instantiate(DecodingData data) {
    return ResourceNotFound(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ResourceNotFound fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ResourceNotFound>(map);
  }

  static ResourceNotFound fromJson(String json) {
    return ensureInitialized().decodeJson<ResourceNotFound>(json);
  }
}

mixin ResourceNotFoundMappable {
  String toJson() {
    return ResourceNotFoundMapper.ensureInitialized()
        .encodeJson<ResourceNotFound>(this as ResourceNotFound);
  }

  Map<String, dynamic> toMap() {
    return ResourceNotFoundMapper.ensureInitialized()
        .encodeMap<ResourceNotFound>(this as ResourceNotFound);
  }

  ResourceNotFoundCopyWith<ResourceNotFound, ResourceNotFound, ResourceNotFound>
  get copyWith =>
      _ResourceNotFoundCopyWithImpl<ResourceNotFound, ResourceNotFound>(
        this as ResourceNotFound,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ResourceNotFoundMapper.ensureInitialized().stringifyValue(
      this as ResourceNotFound,
    );
  }

  @override
  bool operator ==(Object other) {
    return ResourceNotFoundMapper.ensureInitialized().equalsValue(
      this as ResourceNotFound,
      other,
    );
  }

  @override
  int get hashCode {
    return ResourceNotFoundMapper.ensureInitialized().hashValue(
      this as ResourceNotFound,
    );
  }
}

extension ResourceNotFoundValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ResourceNotFound, $Out> {
  ResourceNotFoundCopyWith<$R, ResourceNotFound, $Out>
  get $asResourceNotFound =>
      $base.as((v, t, t2) => _ResourceNotFoundCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ResourceNotFoundCopyWith<$R, $In extends ResourceNotFound, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  ResourceNotFoundCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ResourceNotFoundCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ResourceNotFound, $Out>
    implements ResourceNotFoundCopyWith<$R, ResourceNotFound, $Out> {
  _ResourceNotFoundCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ResourceNotFound> $mapper =
      ResourceNotFoundMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  ResourceNotFound $make(CopyWithData data) => ResourceNotFound(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  ResourceNotFoundCopyWith<$R2, ResourceNotFound, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ResourceNotFoundCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ConflictMapper extends SubClassMapperBase<Conflict> {
  ConflictMapper._();

  static ConflictMapper? _instance;
  static ConflictMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConflictMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Conflict';

  static String _$id(Conflict v) => v.id;
  static const Field<Conflict, String> _f$id = Field('id', _$id);
  static String _$name(Conflict v) => v.name;
  static const Field<Conflict, String> _f$name = Field('name', _$name);
  static String _$detail(Conflict v) => v.detail;
  static const Field<Conflict, String> _f$detail = Field('detail', _$detail);

  @override
  final MappableFields<Conflict> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '409';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static Conflict _instantiate(DecodingData data) {
    return Conflict(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Conflict fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Conflict>(map);
  }

  static Conflict fromJson(String json) {
    return ensureInitialized().decodeJson<Conflict>(json);
  }
}

mixin ConflictMappable {
  String toJson() {
    return ConflictMapper.ensureInitialized().encodeJson<Conflict>(
      this as Conflict,
    );
  }

  Map<String, dynamic> toMap() {
    return ConflictMapper.ensureInitialized().encodeMap<Conflict>(
      this as Conflict,
    );
  }

  ConflictCopyWith<Conflict, Conflict, Conflict> get copyWith =>
      _ConflictCopyWithImpl<Conflict, Conflict>(
        this as Conflict,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConflictMapper.ensureInitialized().stringifyValue(this as Conflict);
  }

  @override
  bool operator ==(Object other) {
    return ConflictMapper.ensureInitialized().equalsValue(
      this as Conflict,
      other,
    );
  }

  @override
  int get hashCode {
    return ConflictMapper.ensureInitialized().hashValue(this as Conflict);
  }
}

extension ConflictValueCopy<$R, $Out> on ObjectCopyWith<$R, Conflict, $Out> {
  ConflictCopyWith<$R, Conflict, $Out> get $asConflict =>
      $base.as((v, t, t2) => _ConflictCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConflictCopyWith<$R, $In extends Conflict, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  ConflictCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ConflictCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Conflict, $Out>
    implements ConflictCopyWith<$R, Conflict, $Out> {
  _ConflictCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Conflict> $mapper =
      ConflictMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  Conflict $make(CopyWithData data) => Conflict(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  ConflictCopyWith<$R2, Conflict, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConflictCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TooManyRequestsMapper extends SubClassMapperBase<TooManyRequests> {
  TooManyRequestsMapper._();

  static TooManyRequestsMapper? _instance;
  static TooManyRequestsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TooManyRequestsMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TooManyRequests';

  static String _$id(TooManyRequests v) => v.id;
  static const Field<TooManyRequests, String> _f$id = Field('id', _$id);
  static String _$name(TooManyRequests v) => v.name;
  static const Field<TooManyRequests, String> _f$name = Field('name', _$name);
  static String _$detail(TooManyRequests v) => v.detail;
  static const Field<TooManyRequests, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<TooManyRequests> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '429';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static TooManyRequests _instantiate(DecodingData data) {
    return TooManyRequests(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TooManyRequests fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TooManyRequests>(map);
  }

  static TooManyRequests fromJson(String json) {
    return ensureInitialized().decodeJson<TooManyRequests>(json);
  }
}

mixin TooManyRequestsMappable {
  String toJson() {
    return TooManyRequestsMapper.ensureInitialized()
        .encodeJson<TooManyRequests>(this as TooManyRequests);
  }

  Map<String, dynamic> toMap() {
    return TooManyRequestsMapper.ensureInitialized().encodeMap<TooManyRequests>(
      this as TooManyRequests,
    );
  }

  TooManyRequestsCopyWith<TooManyRequests, TooManyRequests, TooManyRequests>
  get copyWith =>
      _TooManyRequestsCopyWithImpl<TooManyRequests, TooManyRequests>(
        this as TooManyRequests,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TooManyRequestsMapper.ensureInitialized().stringifyValue(
      this as TooManyRequests,
    );
  }

  @override
  bool operator ==(Object other) {
    return TooManyRequestsMapper.ensureInitialized().equalsValue(
      this as TooManyRequests,
      other,
    );
  }

  @override
  int get hashCode {
    return TooManyRequestsMapper.ensureInitialized().hashValue(
      this as TooManyRequests,
    );
  }
}

extension TooManyRequestsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TooManyRequests, $Out> {
  TooManyRequestsCopyWith<$R, TooManyRequests, $Out> get $asTooManyRequests =>
      $base.as((v, t, t2) => _TooManyRequestsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TooManyRequestsCopyWith<$R, $In extends TooManyRequests, $Out>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  TooManyRequestsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TooManyRequestsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TooManyRequests, $Out>
    implements TooManyRequestsCopyWith<$R, TooManyRequests, $Out> {
  _TooManyRequestsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TooManyRequests> $mapper =
      TooManyRequestsMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  TooManyRequests $make(CopyWithData data) => TooManyRequests(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  TooManyRequestsCopyWith<$R2, TooManyRequests, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TooManyRequestsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InternalServerErrorMapper
    extends SubClassMapperBase<InternalServerError> {
  InternalServerErrorMapper._();

  static InternalServerErrorMapper? _instance;
  static InternalServerErrorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InternalServerErrorMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'InternalServerError';

  static String _$id(InternalServerError v) => v.id;
  static const Field<InternalServerError, String> _f$id = Field('id', _$id);
  static String _$name(InternalServerError v) => v.name;
  static const Field<InternalServerError, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$detail(InternalServerError v) => v.detail;
  static const Field<InternalServerError, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<InternalServerError> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '500';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static InternalServerError _instantiate(DecodingData data) {
    return InternalServerError(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InternalServerError fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InternalServerError>(map);
  }

  static InternalServerError fromJson(String json) {
    return ensureInitialized().decodeJson<InternalServerError>(json);
  }
}

mixin InternalServerErrorMappable {
  String toJson() {
    return InternalServerErrorMapper.ensureInitialized()
        .encodeJson<InternalServerError>(this as InternalServerError);
  }

  Map<String, dynamic> toMap() {
    return InternalServerErrorMapper.ensureInitialized()
        .encodeMap<InternalServerError>(this as InternalServerError);
  }

  InternalServerErrorCopyWith<
    InternalServerError,
    InternalServerError,
    InternalServerError
  >
  get copyWith =>
      _InternalServerErrorCopyWithImpl<
        InternalServerError,
        InternalServerError
      >(this as InternalServerError, $identity, $identity);
  @override
  String toString() {
    return InternalServerErrorMapper.ensureInitialized().stringifyValue(
      this as InternalServerError,
    );
  }

  @override
  bool operator ==(Object other) {
    return InternalServerErrorMapper.ensureInitialized().equalsValue(
      this as InternalServerError,
      other,
    );
  }

  @override
  int get hashCode {
    return InternalServerErrorMapper.ensureInitialized().hashValue(
      this as InternalServerError,
    );
  }
}

extension InternalServerErrorValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InternalServerError, $Out> {
  InternalServerErrorCopyWith<$R, InternalServerError, $Out>
  get $asInternalServerError => $base.as(
    (v, t, t2) => _InternalServerErrorCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InternalServerErrorCopyWith<
  $R,
  $In extends InternalServerError,
  $Out
>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  InternalServerErrorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InternalServerErrorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InternalServerError, $Out>
    implements InternalServerErrorCopyWith<$R, InternalServerError, $Out> {
  _InternalServerErrorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InternalServerError> $mapper =
      InternalServerErrorMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  InternalServerError $make(CopyWithData data) => InternalServerError(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  InternalServerErrorCopyWith<$R2, InternalServerError, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InternalServerErrorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ServiceUnavailableMapper extends SubClassMapperBase<ServiceUnavailable> {
  ServiceUnavailableMapper._();

  static ServiceUnavailableMapper? _instance;
  static ServiceUnavailableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ServiceUnavailableMapper._());
      YnabApiErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ServiceUnavailable';

  static String _$id(ServiceUnavailable v) => v.id;
  static const Field<ServiceUnavailable, String> _f$id = Field('id', _$id);
  static String _$name(ServiceUnavailable v) => v.name;
  static const Field<ServiceUnavailable, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$detail(ServiceUnavailable v) => v.detail;
  static const Field<ServiceUnavailable, String> _f$detail = Field(
    'detail',
    _$detail,
  );

  @override
  final MappableFields<ServiceUnavailable> fields = const {
    #id: _f$id,
    #name: _f$name,
    #detail: _f$detail,
  };

  @override
  final String discriminatorKey = 'id';
  @override
  final dynamic discriminatorValue = '503';
  @override
  late final ClassMapperBase superMapper =
      YnabApiErrorMapper.ensureInitialized();

  static ServiceUnavailable _instantiate(DecodingData data) {
    return ServiceUnavailable(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      detail: data.dec(_f$detail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ServiceUnavailable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ServiceUnavailable>(map);
  }

  static ServiceUnavailable fromJson(String json) {
    return ensureInitialized().decodeJson<ServiceUnavailable>(json);
  }
}

mixin ServiceUnavailableMappable {
  String toJson() {
    return ServiceUnavailableMapper.ensureInitialized()
        .encodeJson<ServiceUnavailable>(this as ServiceUnavailable);
  }

  Map<String, dynamic> toMap() {
    return ServiceUnavailableMapper.ensureInitialized()
        .encodeMap<ServiceUnavailable>(this as ServiceUnavailable);
  }

  ServiceUnavailableCopyWith<
    ServiceUnavailable,
    ServiceUnavailable,
    ServiceUnavailable
  >
  get copyWith =>
      _ServiceUnavailableCopyWithImpl<ServiceUnavailable, ServiceUnavailable>(
        this as ServiceUnavailable,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ServiceUnavailableMapper.ensureInitialized().stringifyValue(
      this as ServiceUnavailable,
    );
  }

  @override
  bool operator ==(Object other) {
    return ServiceUnavailableMapper.ensureInitialized().equalsValue(
      this as ServiceUnavailable,
      other,
    );
  }

  @override
  int get hashCode {
    return ServiceUnavailableMapper.ensureInitialized().hashValue(
      this as ServiceUnavailable,
    );
  }
}

extension ServiceUnavailableValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ServiceUnavailable, $Out> {
  ServiceUnavailableCopyWith<$R, ServiceUnavailable, $Out>
  get $asServiceUnavailable => $base.as(
    (v, t, t2) => _ServiceUnavailableCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ServiceUnavailableCopyWith<
  $R,
  $In extends ServiceUnavailable,
  $Out
>
    implements YnabApiErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, String? detail});
  ServiceUnavailableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ServiceUnavailableCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ServiceUnavailable, $Out>
    implements ServiceUnavailableCopyWith<$R, ServiceUnavailable, $Out> {
  _ServiceUnavailableCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ServiceUnavailable> $mapper =
      ServiceUnavailableMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? detail}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (detail != null) #detail: detail,
    }),
  );
  @override
  ServiceUnavailable $make(CopyWithData data) => ServiceUnavailable(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    detail: data.get(#detail, or: $value.detail),
  );

  @override
  ServiceUnavailableCopyWith<$R2, ServiceUnavailable, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ServiceUnavailableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

