// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'delete_spend_tracker_request.dart';

class DeleteSpendTrackerRequestMapper
    extends ClassMapperBase<DeleteSpendTrackerRequest> {
  DeleteSpendTrackerRequestMapper._();

  static DeleteSpendTrackerRequestMapper? _instance;
  static DeleteSpendTrackerRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = DeleteSpendTrackerRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'DeleteSpendTrackerRequest';

  static String _$spendTrackerId(DeleteSpendTrackerRequest v) =>
      v.spendTrackerId;
  static const Field<DeleteSpendTrackerRequest, String> _f$spendTrackerId =
      Field('spendTrackerId', _$spendTrackerId, key: r'spend_tracker_id');
  static String _$userId(DeleteSpendTrackerRequest v) => v.userId;
  static const Field<DeleteSpendTrackerRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );

  @override
  final MappableFields<DeleteSpendTrackerRequest> fields = const {
    #spendTrackerId: _f$spendTrackerId,
    #userId: _f$userId,
  };

  static DeleteSpendTrackerRequest _instantiate(DecodingData data) {
    return DeleteSpendTrackerRequest(
      spendTrackerId: data.dec(_f$spendTrackerId),
      userId: data.dec(_f$userId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeleteSpendTrackerRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeleteSpendTrackerRequest>(map);
  }

  static DeleteSpendTrackerRequest fromJson(String json) {
    return ensureInitialized().decodeJson<DeleteSpendTrackerRequest>(json);
  }
}

mixin DeleteSpendTrackerRequestMappable {
  String toJson() {
    return DeleteSpendTrackerRequestMapper.ensureInitialized()
        .encodeJson<DeleteSpendTrackerRequest>(
          this as DeleteSpendTrackerRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return DeleteSpendTrackerRequestMapper.ensureInitialized()
        .encodeMap<DeleteSpendTrackerRequest>(
          this as DeleteSpendTrackerRequest,
        );
  }

  DeleteSpendTrackerRequestCopyWith<
    DeleteSpendTrackerRequest,
    DeleteSpendTrackerRequest,
    DeleteSpendTrackerRequest
  >
  get copyWith =>
      _DeleteSpendTrackerRequestCopyWithImpl<
        DeleteSpendTrackerRequest,
        DeleteSpendTrackerRequest
      >(this as DeleteSpendTrackerRequest, $identity, $identity);
  @override
  String toString() {
    return DeleteSpendTrackerRequestMapper.ensureInitialized().stringifyValue(
      this as DeleteSpendTrackerRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeleteSpendTrackerRequestMapper.ensureInitialized().equalsValue(
      this as DeleteSpendTrackerRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return DeleteSpendTrackerRequestMapper.ensureInitialized().hashValue(
      this as DeleteSpendTrackerRequest,
    );
  }
}

extension DeleteSpendTrackerRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeleteSpendTrackerRequest, $Out> {
  DeleteSpendTrackerRequestCopyWith<$R, DeleteSpendTrackerRequest, $Out>
  get $asDeleteSpendTrackerRequest => $base.as(
    (v, t, t2) => _DeleteSpendTrackerRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeleteSpendTrackerRequestCopyWith<
  $R,
  $In extends DeleteSpendTrackerRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? spendTrackerId, String? userId});
  DeleteSpendTrackerRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeleteSpendTrackerRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeleteSpendTrackerRequest, $Out>
    implements
        DeleteSpendTrackerRequestCopyWith<$R, DeleteSpendTrackerRequest, $Out> {
  _DeleteSpendTrackerRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeleteSpendTrackerRequest> $mapper =
      DeleteSpendTrackerRequestMapper.ensureInitialized();
  @override
  $R call({String? spendTrackerId, String? userId}) => $apply(
    FieldCopyWithData({
      if (spendTrackerId != null) #spendTrackerId: spendTrackerId,
      if (userId != null) #userId: userId,
    }),
  );
  @override
  DeleteSpendTrackerRequest $make(CopyWithData data) =>
      DeleteSpendTrackerRequest(
        spendTrackerId: data.get(#spendTrackerId, or: $value.spendTrackerId),
        userId: data.get(#userId, or: $value.userId),
      );

  @override
  DeleteSpendTrackerRequestCopyWith<$R2, DeleteSpendTrackerRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeleteSpendTrackerRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

