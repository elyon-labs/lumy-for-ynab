// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insert_category_view_request.dart';

class InsertCategoryViewRequestMapper
    extends ClassMapperBase<InsertCategoryViewRequest> {
  InsertCategoryViewRequestMapper._();

  static InsertCategoryViewRequestMapper? _instance;
  static InsertCategoryViewRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsertCategoryViewRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'InsertCategoryViewRequest';

  static String _$userId(InsertCategoryViewRequest v) => v.userId;
  static const Field<InsertCategoryViewRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$name(InsertCategoryViewRequest v) => v.name;
  static const Field<InsertCategoryViewRequest, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$budgetId(InsertCategoryViewRequest v) => v.budgetId;
  static const Field<InsertCategoryViewRequest, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static List<String> _$categoryIds(InsertCategoryViewRequest v) =>
      v.categoryIds;
  static const Field<InsertCategoryViewRequest, List<String>> _f$categoryIds =
      Field('categoryIds', _$categoryIds, key: r'category_ids');
  static List<String> _$categoryGroupIds(InsertCategoryViewRequest v) =>
      v.categoryGroupIds;
  static const Field<InsertCategoryViewRequest, List<String>>
  _f$categoryGroupIds = Field(
    'categoryGroupIds',
    _$categoryGroupIds,
    key: r'category_group_ids',
  );

  @override
  final MappableFields<InsertCategoryViewRequest> fields = const {
    #userId: _f$userId,
    #name: _f$name,
    #budgetId: _f$budgetId,
    #categoryIds: _f$categoryIds,
    #categoryGroupIds: _f$categoryGroupIds,
  };

  static InsertCategoryViewRequest _instantiate(DecodingData data) {
    return InsertCategoryViewRequest(
      userId: data.dec(_f$userId),
      name: data.dec(_f$name),
      budgetId: data.dec(_f$budgetId),
      categoryIds: data.dec(_f$categoryIds),
      categoryGroupIds: data.dec(_f$categoryGroupIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertCategoryViewRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsertCategoryViewRequest>(map);
  }

  static InsertCategoryViewRequest fromJson(String json) {
    return ensureInitialized().decodeJson<InsertCategoryViewRequest>(json);
  }
}

mixin InsertCategoryViewRequestMappable {
  String toJson() {
    return InsertCategoryViewRequestMapper.ensureInitialized()
        .encodeJson<InsertCategoryViewRequest>(
          this as InsertCategoryViewRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return InsertCategoryViewRequestMapper.ensureInitialized()
        .encodeMap<InsertCategoryViewRequest>(
          this as InsertCategoryViewRequest,
        );
  }

  InsertCategoryViewRequestCopyWith<
    InsertCategoryViewRequest,
    InsertCategoryViewRequest,
    InsertCategoryViewRequest
  >
  get copyWith =>
      _InsertCategoryViewRequestCopyWithImpl<
        InsertCategoryViewRequest,
        InsertCategoryViewRequest
      >(this as InsertCategoryViewRequest, $identity, $identity);
  @override
  String toString() {
    return InsertCategoryViewRequestMapper.ensureInitialized().stringifyValue(
      this as InsertCategoryViewRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsertCategoryViewRequestMapper.ensureInitialized().equalsValue(
      this as InsertCategoryViewRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return InsertCategoryViewRequestMapper.ensureInitialized().hashValue(
      this as InsertCategoryViewRequest,
    );
  }
}

extension InsertCategoryViewRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertCategoryViewRequest, $Out> {
  InsertCategoryViewRequestCopyWith<$R, InsertCategoryViewRequest, $Out>
  get $asInsertCategoryViewRequest => $base.as(
    (v, t, t2) => _InsertCategoryViewRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsertCategoryViewRequestCopyWith<
  $R,
  $In extends InsertCategoryViewRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroupIds;
  $R call({
    String? userId,
    String? name,
    String? budgetId,
    List<String>? categoryIds,
    List<String>? categoryGroupIds,
  });
  InsertCategoryViewRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsertCategoryViewRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertCategoryViewRequest, $Out>
    implements
        InsertCategoryViewRequestCopyWith<$R, InsertCategoryViewRequest, $Out> {
  _InsertCategoryViewRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsertCategoryViewRequest> $mapper =
      InsertCategoryViewRequestMapper.ensureInitialized();
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
    String? name,
    String? budgetId,
    List<String>? categoryIds,
    List<String>? categoryGroupIds,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (name != null) #name: name,
      if (budgetId != null) #budgetId: budgetId,
      if (categoryIds != null) #categoryIds: categoryIds,
      if (categoryGroupIds != null) #categoryGroupIds: categoryGroupIds,
    }),
  );
  @override
  InsertCategoryViewRequest $make(CopyWithData data) =>
      InsertCategoryViewRequest(
        userId: data.get(#userId, or: $value.userId),
        name: data.get(#name, or: $value.name),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        categoryIds: data.get(#categoryIds, or: $value.categoryIds),
        categoryGroupIds: data.get(
          #categoryGroupIds,
          or: $value.categoryGroupIds,
        ),
      );

  @override
  InsertCategoryViewRequestCopyWith<$R2, InsertCategoryViewRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertCategoryViewRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

