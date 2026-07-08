// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'category_view.dart';

class CategoryViewMapper extends ClassMapperBase<CategoryView> {
  CategoryViewMapper._();

  static CategoryViewMapper? _instance;
  static CategoryViewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoryViewMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CategoryView';

  static String _$id(CategoryView v) => v.id;
  static const Field<CategoryView, String> _f$id = Field('id', _$id);
  static String _$name(CategoryView v) => v.name;
  static const Field<CategoryView, String> _f$name = Field('name', _$name);
  static String _$budgetId(CategoryView v) => v.budgetId;
  static const Field<CategoryView, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static bool _$isDeleted(CategoryView v) => v.isDeleted;
  static const Field<CategoryView, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: r'is_deleted',
  );
  static List<String> _$categoryGroupIds(CategoryView v) => v.categoryGroupIds;
  static const Field<CategoryView, List<String>> _f$categoryGroupIds = Field(
    'categoryGroupIds',
    _$categoryGroupIds,
    key: r'category_group_ids',
  );
  static List<String> _$categoryIds(CategoryView v) => v.categoryIds;
  static const Field<CategoryView, List<String>> _f$categoryIds = Field(
    'categoryIds',
    _$categoryIds,
    key: r'category_ids',
  );
  static List<Object?> _$props(CategoryView v) => v.props;
  static const Field<CategoryView, List<Object?>> _f$props = Field(
    'props',
    _$props,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<CategoryView> fields = const {
    #id: _f$id,
    #name: _f$name,
    #budgetId: _f$budgetId,
    #isDeleted: _f$isDeleted,
    #categoryGroupIds: _f$categoryGroupIds,
    #categoryIds: _f$categoryIds,
    #props: _f$props,
  };

  static CategoryView _instantiate(DecodingData data) {
    return CategoryView(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      budgetId: data.dec(_f$budgetId),
      isDeleted: data.dec(_f$isDeleted),
      categoryGroupIds: data.dec(_f$categoryGroupIds),
      categoryIds: data.dec(_f$categoryIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CategoryView fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CategoryView>(map);
  }

  static CategoryView fromJson(String json) {
    return ensureInitialized().decodeJson<CategoryView>(json);
  }
}

mixin CategoryViewMappable {
  String toJson() {
    return CategoryViewMapper.ensureInitialized().encodeJson<CategoryView>(
      this as CategoryView,
    );
  }

  Map<String, dynamic> toMap() {
    return CategoryViewMapper.ensureInitialized().encodeMap<CategoryView>(
      this as CategoryView,
    );
  }

  CategoryViewCopyWith<CategoryView, CategoryView, CategoryView> get copyWith =>
      _CategoryViewCopyWithImpl<CategoryView, CategoryView>(
        this as CategoryView,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CategoryViewMapper.ensureInitialized().stringifyValue(
      this as CategoryView,
    );
  }

  @override
  bool operator ==(Object other) {
    return CategoryViewMapper.ensureInitialized().equalsValue(
      this as CategoryView,
      other,
    );
  }

  @override
  int get hashCode {
    return CategoryViewMapper.ensureInitialized().hashValue(
      this as CategoryView,
    );
  }
}

extension CategoryViewValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CategoryView, $Out> {
  CategoryViewCopyWith<$R, CategoryView, $Out> get $asCategoryView =>
      $base.as((v, t, t2) => _CategoryViewCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CategoryViewCopyWith<$R, $In extends CategoryView, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroupIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  $R call({
    String? id,
    String? name,
    String? budgetId,
    bool? isDeleted,
    List<String>? categoryGroupIds,
    List<String>? categoryIds,
  });
  CategoryViewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoryViewCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CategoryView, $Out>
    implements CategoryViewCopyWith<$R, CategoryView, $Out> {
  _CategoryViewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CategoryView> $mapper =
      CategoryViewMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroupIds => ListCopyWith(
    $value.categoryGroupIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryGroupIds: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryIds => ListCopyWith(
    $value.categoryIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryIds: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    String? budgetId,
    bool? isDeleted,
    List<String>? categoryGroupIds,
    List<String>? categoryIds,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (budgetId != null) #budgetId: budgetId,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (categoryGroupIds != null) #categoryGroupIds: categoryGroupIds,
      if (categoryIds != null) #categoryIds: categoryIds,
    }),
  );
  @override
  CategoryView $make(CopyWithData data) => CategoryView(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    categoryGroupIds: data.get(#categoryGroupIds, or: $value.categoryGroupIds),
    categoryIds: data.get(#categoryIds, or: $value.categoryIds),
  );

  @override
  CategoryViewCopyWith<$R2, CategoryView, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CategoryViewCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

