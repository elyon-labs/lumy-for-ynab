// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'payees_response.dart';

class PayeesResponseMapper extends ClassMapperBase<PayeesResponse> {
  PayeesResponseMapper._();

  static PayeesResponseMapper? _instance;
  static PayeesResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PayeesResponseMapper._());
      PayeesMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PayeesResponse';

  static Payees _$data(PayeesResponse v) => v.data;
  static const Field<PayeesResponse, Payees> _f$data = Field('data', _$data);

  @override
  final MappableFields<PayeesResponse> fields = const {#data: _f$data};

  static PayeesResponse _instantiate(DecodingData data) {
    return PayeesResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static PayeesResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PayeesResponse>(map);
  }

  static PayeesResponse fromJson(String json) {
    return ensureInitialized().decodeJson<PayeesResponse>(json);
  }
}

mixin PayeesResponseMappable {
  String toJson() {
    return PayeesResponseMapper.ensureInitialized().encodeJson<PayeesResponse>(
      this as PayeesResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return PayeesResponseMapper.ensureInitialized().encodeMap<PayeesResponse>(
      this as PayeesResponse,
    );
  }

  PayeesResponseCopyWith<PayeesResponse, PayeesResponse, PayeesResponse> get copyWith =>
      _PayeesResponseCopyWithImpl(this as PayeesResponse, $identity, $identity);
  @override
  String toString() {
    return PayeesResponseMapper.ensureInitialized().stringifyValue(this as PayeesResponse);
  }

  @override
  bool operator ==(Object other) {
    return PayeesResponseMapper.ensureInitialized().equalsValue(this as PayeesResponse, other);
  }

  @override
  int get hashCode {
    return PayeesResponseMapper.ensureInitialized().hashValue(this as PayeesResponse);
  }
}

extension PayeesResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, PayeesResponse, $Out> {
  PayeesResponseCopyWith<$R, PayeesResponse, $Out> get $asPayeesResponse =>
      $base.as((v, t, t2) => _PayeesResponseCopyWithImpl(v, t, t2));
}

abstract class PayeesResponseCopyWith<$R, $In extends PayeesResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PayeesCopyWith<$R, Payees, Payees> get data;
  $R call({Payees? data});
  PayeesResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PayeesResponseCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, PayeesResponse, $Out>
    implements PayeesResponseCopyWith<$R, PayeesResponse, $Out> {
  _PayeesResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PayeesResponse> $mapper = PayeesResponseMapper.ensureInitialized();
  @override
  PayeesCopyWith<$R, Payees, Payees> get data => $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Payees? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  PayeesResponse $make(CopyWithData data) => PayeesResponse(data: data.get(#data, or: $value.data));

  @override
  PayeesResponseCopyWith<$R2, PayeesResponse, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PayeesResponseCopyWithImpl($value, $cast, t);
}

class PayeesMapper extends ClassMapperBase<Payees> {
  PayeesMapper._();

  static PayeesMapper? _instance;
  static PayeesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PayeesMapper._());
      PayeeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Payees';

  static int _$serverKnowledge(Payees v) => v.serverKnowledge;
  static const Field<Payees, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );
  static List<Payee> _$payees(Payees v) => v.payees;
  static const Field<Payees, List<Payee>> _f$payees = Field('payees', _$payees);

  @override
  final MappableFields<Payees> fields = const {
    #serverKnowledge: _f$serverKnowledge,
    #payees: _f$payees,
  };

  static Payees _instantiate(DecodingData data) {
    return Payees(serverKnowledge: data.dec(_f$serverKnowledge), payees: data.dec(_f$payees));
  }

  @override
  final Function instantiate = _instantiate;

  static Payees fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Payees>(map);
  }

  static Payees fromJson(String json) {
    return ensureInitialized().decodeJson<Payees>(json);
  }
}

mixin PayeesMappable {
  String toJson() {
    return PayeesMapper.ensureInitialized().encodeJson<Payees>(this as Payees);
  }

  Map<String, dynamic> toMap() {
    return PayeesMapper.ensureInitialized().encodeMap<Payees>(this as Payees);
  }

  PayeesCopyWith<Payees, Payees, Payees> get copyWith =>
      _PayeesCopyWithImpl(this as Payees, $identity, $identity);
  @override
  String toString() {
    return PayeesMapper.ensureInitialized().stringifyValue(this as Payees);
  }

  @override
  bool operator ==(Object other) {
    return PayeesMapper.ensureInitialized().equalsValue(this as Payees, other);
  }

  @override
  int get hashCode {
    return PayeesMapper.ensureInitialized().hashValue(this as Payees);
  }
}

extension PayeesValueCopy<$R, $Out> on ObjectCopyWith<$R, Payees, $Out> {
  PayeesCopyWith<$R, Payees, $Out> get $asPayees =>
      $base.as((v, t, t2) => _PayeesCopyWithImpl(v, t, t2));
}

abstract class PayeesCopyWith<$R, $In extends Payees, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Payee, PayeeCopyWith<$R, Payee, Payee>> get payees;
  $R call({int? serverKnowledge, List<Payee>? payees});
  PayeesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PayeesCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Payees, $Out>
    implements PayeesCopyWith<$R, Payees, $Out> {
  _PayeesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Payees> $mapper = PayeesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Payee, PayeeCopyWith<$R, Payee, Payee>> get payees =>
      ListCopyWith($value.payees, (v, t) => v.copyWith.$chain(t), (v) => call(payees: v));
  @override
  $R call({int? serverKnowledge, List<Payee>? payees}) => $apply(
    FieldCopyWithData({
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
      if (payees != null) #payees: payees,
    }),
  );
  @override
  Payees $make(CopyWithData data) => Payees(
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
    payees: data.get(#payees, or: $value.payees),
  );

  @override
  PayeesCopyWith<$R2, Payees, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PayeesCopyWithImpl($value, $cast, t);
}

class PayeeMapper extends ClassMapperBase<Payee> {
  PayeeMapper._();

  static PayeeMapper? _instance;
  static PayeeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PayeeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Payee';

  static String _$id(Payee v) => v.id;
  static const Field<Payee, String> _f$id = Field('id', _$id);
  static String _$name(Payee v) => v.name;
  static const Field<Payee, String> _f$name = Field('name', _$name);
  static bool _$isDeleted(Payee v) => v.isDeleted;
  static const Field<Payee, bool> _f$isDeleted = Field('isDeleted', _$isDeleted, key: 'deleted');

  @override
  final MappableFields<Payee> fields = const {#id: _f$id, #name: _f$name, #isDeleted: _f$isDeleted};

  static Payee _instantiate(DecodingData data) {
    return Payee(id: data.dec(_f$id), name: data.dec(_f$name), isDeleted: data.dec(_f$isDeleted));
  }

  @override
  final Function instantiate = _instantiate;

  static Payee fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Payee>(map);
  }

  static Payee fromJson(String json) {
    return ensureInitialized().decodeJson<Payee>(json);
  }
}

mixin PayeeMappable {
  String toJson() {
    return PayeeMapper.ensureInitialized().encodeJson<Payee>(this as Payee);
  }

  Map<String, dynamic> toMap() {
    return PayeeMapper.ensureInitialized().encodeMap<Payee>(this as Payee);
  }

  PayeeCopyWith<Payee, Payee, Payee> get copyWith =>
      _PayeeCopyWithImpl(this as Payee, $identity, $identity);
  @override
  String toString() {
    return PayeeMapper.ensureInitialized().stringifyValue(this as Payee);
  }

  @override
  bool operator ==(Object other) {
    return PayeeMapper.ensureInitialized().equalsValue(this as Payee, other);
  }

  @override
  int get hashCode {
    return PayeeMapper.ensureInitialized().hashValue(this as Payee);
  }
}

extension PayeeValueCopy<$R, $Out> on ObjectCopyWith<$R, Payee, $Out> {
  PayeeCopyWith<$R, Payee, $Out> get $asPayee =>
      $base.as((v, t, t2) => _PayeeCopyWithImpl(v, t, t2));
}

abstract class PayeeCopyWith<$R, $In extends Payee, $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, bool? isDeleted});
  PayeeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PayeeCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Payee, $Out>
    implements PayeeCopyWith<$R, Payee, $Out> {
  _PayeeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Payee> $mapper = PayeeMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, bool? isDeleted}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (isDeleted != null) #isDeleted: isDeleted,
    }),
  );
  @override
  Payee $make(CopyWithData data) => Payee(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
  );

  @override
  PayeeCopyWith<$R2, Payee, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PayeeCopyWithImpl($value, $cast, t);
}
