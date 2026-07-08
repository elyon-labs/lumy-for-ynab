// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'update_category_view_request.dart';

class UpdateCategoryViewRequestMapper
    extends ClassMapperBase<UpdateCategoryViewRequest> {
  UpdateCategoryViewRequestMapper._();

  static UpdateCategoryViewRequestMapper? _instance;
  static UpdateCategoryViewRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = UpdateCategoryViewRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'UpdateCategoryViewRequest';

  static String _$userId(UpdateCategoryViewRequest v) => v.userId;
  static const Field<UpdateCategoryViewRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$id(UpdateCategoryViewRequest v) => v.id;
  static const Field<UpdateCategoryViewRequest, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$name(UpdateCategoryViewRequest v) => v.name;
  static const Field<UpdateCategoryViewRequest, String> _f$name = Field(
    'name',
    _$name,
  );
  static List<String> _$categoryIds(UpdateCategoryViewRequest v) =>
      v.categoryIds;
  static const Field<UpdateCategoryViewRequest, List<String>> _f$categoryIds =
      Field('categoryIds', _$categoryIds, key: r'category_ids');
  static List<String> _$categoryGroupIds(UpdateCategoryViewRequest v) =>
      v.categoryGroupIds;
  static const Field<UpdateCategoryViewRequest, List<String>>
  _f$categoryGroupIds = Field(
    'categoryGroupIds',
    _$categoryGroupIds,
    key: r'category_group_ids',
  );

  @override
  final MappableFields<UpdateCategoryViewRequest> fields = const {
    #userId: _f$userId,
    #id: _f$id,
    #name: _f$name,
    #categoryIds: _f$categoryIds,
    #categoryGroupIds: _f$categoryGroupIds,
  };

  static UpdateCategoryViewRequest _instantiate(DecodingData data) {
    return UpdateCategoryViewRequest(
      userId: data.dec(_f$userId),
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      categoryIds: data.dec(_f$categoryIds),
      categoryGroupIds: data.dec(_f$categoryGroupIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpdateCategoryViewRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpdateCategoryViewRequest>(map);
  }

  static UpdateCategoryViewRequest fromJson(String json) {
    return ensureInitialized().decodeJson<UpdateCategoryViewRequest>(json);
  }
}

mixin UpdateCategoryViewRequestMappable {
  String toJson() {
    return UpdateCategoryViewRequestMapper.ensureInitialized()
        .encodeJson<UpdateCategoryViewRequest>(
          this as UpdateCategoryViewRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return UpdateCategoryViewRequestMapper.ensureInitialized()
        .encodeMap<UpdateCategoryViewRequest>(
          this as UpdateCategoryViewRequest,
        );
  }

  UpdateCategoryViewRequestCopyWith<
    UpdateCategoryViewRequest,
    UpdateCategoryViewRequest,
    UpdateCategoryViewRequest
  >
  get copyWith =>
      _UpdateCategoryViewRequestCopyWithImpl<
        UpdateCategoryViewRequest,
        UpdateCategoryViewRequest
      >(this as UpdateCategoryViewRequest, $identity, $identity);
  @override
  String toString() {
    return UpdateCategoryViewRequestMapper.ensureInitialized().stringifyValue(
      this as UpdateCategoryViewRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpdateCategoryViewRequestMapper.ensureInitialized().equalsValue(
      this as UpdateCategoryViewRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return UpdateCategoryViewRequestMapper.ensureInitialized().hashValue(
      this as UpdateCategoryViewRequest,
    );
  }
}

extension UpdateCategoryViewRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpdateCategoryViewRequest, $Out> {
  UpdateCategoryViewRequestCopyWith<$R, UpdateCategoryViewRequest, $Out>
  get $asUpdateCategoryViewRequest => $base.as(
    (v, t, t2) => _UpdateCategoryViewRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UpdateCategoryViewRequestCopyWith<
  $R,
  $In extends UpdateCategoryViewRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroupIds;
  $R call({
    String? userId,
    String? id,
    String? name,
    List<String>? categoryIds,
    List<String>? categoryGroupIds,
  });
  UpdateCategoryViewRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UpdateCategoryViewRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpdateCategoryViewRequest, $Out>
    implements
        UpdateCategoryViewRequestCopyWith<$R, UpdateCategoryViewRequest, $Out> {
  _UpdateCategoryViewRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpdateCategoryViewRequest> $mapper =
      UpdateCategoryViewRequestMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryIds => ListCopyWith(
    $value.categoryIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryIds: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroupIds => ListCopyWith(
    $value.categoryGroupIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryGroupIds: v),
  );
  @override
  $R call({
    String? userId,
    String? id,
    String? name,
    List<String>? categoryIds,
    List<String>? categoryGroupIds,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (categoryIds != null) #categoryIds: categoryIds,
      if (categoryGroupIds != null) #categoryGroupIds: categoryGroupIds,
    }),
  );
  @override
  UpdateCategoryViewRequest $make(CopyWithData data) =>
      UpdateCategoryViewRequest(
        userId: data.get(#userId, or: $value.userId),
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
        categoryIds: data.get(#categoryIds, or: $value.categoryIds),
        categoryGroupIds: data.get(
          #categoryGroupIds,
          or: $value.categoryGroupIds,
        ),
      );

  @override
  UpdateCategoryViewRequestCopyWith<$R2, UpdateCategoryViewRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UpdateCategoryViewRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

