// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'category_view_from_backend.dart';

class CategoryViewOnlyFromBackendMapper
    extends ClassMapperBase<CategoryViewOnlyFromBackend> {
  CategoryViewOnlyFromBackendMapper._();

  static CategoryViewOnlyFromBackendMapper? _instance;
  static CategoryViewOnlyFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = CategoryViewOnlyFromBackendMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'CategoryViewOnlyFromBackend';

  static String _$id(CategoryViewOnlyFromBackend v) => v.id;
  static const Field<CategoryViewOnlyFromBackend, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$name(CategoryViewOnlyFromBackend v) => v.name;
  static const Field<CategoryViewOnlyFromBackend, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$budgetId(CategoryViewOnlyFromBackend v) => v.budgetId;
  static const Field<CategoryViewOnlyFromBackend, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );

  @override
  final MappableFields<CategoryViewOnlyFromBackend> fields = const {
    #id: _f$id,
    #name: _f$name,
    #budgetId: _f$budgetId,
  };

  static CategoryViewOnlyFromBackend _instantiate(DecodingData data) {
    return CategoryViewOnlyFromBackend(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      budgetId: data.dec(_f$budgetId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CategoryViewOnlyFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CategoryViewOnlyFromBackend>(map);
  }

  static CategoryViewOnlyFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<CategoryViewOnlyFromBackend>(json);
  }
}

mixin CategoryViewOnlyFromBackendMappable {
  String toJson() {
    return CategoryViewOnlyFromBackendMapper.ensureInitialized()
        .encodeJson<CategoryViewOnlyFromBackend>(
          this as CategoryViewOnlyFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return CategoryViewOnlyFromBackendMapper.ensureInitialized()
        .encodeMap<CategoryViewOnlyFromBackend>(
          this as CategoryViewOnlyFromBackend,
        );
  }

  CategoryViewOnlyFromBackendCopyWith<
    CategoryViewOnlyFromBackend,
    CategoryViewOnlyFromBackend,
    CategoryViewOnlyFromBackend
  >
  get copyWith =>
      _CategoryViewOnlyFromBackendCopyWithImpl<
        CategoryViewOnlyFromBackend,
        CategoryViewOnlyFromBackend
      >(this as CategoryViewOnlyFromBackend, $identity, $identity);
  @override
  String toString() {
    return CategoryViewOnlyFromBackendMapper.ensureInitialized().stringifyValue(
      this as CategoryViewOnlyFromBackend,
    );
  }

  @override
  bool operator ==(Object other) {
    return CategoryViewOnlyFromBackendMapper.ensureInitialized().equalsValue(
      this as CategoryViewOnlyFromBackend,
      other,
    );
  }

  @override
  int get hashCode {
    return CategoryViewOnlyFromBackendMapper.ensureInitialized().hashValue(
      this as CategoryViewOnlyFromBackend,
    );
  }
}

extension CategoryViewOnlyFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CategoryViewOnlyFromBackend, $Out> {
  CategoryViewOnlyFromBackendCopyWith<$R, CategoryViewOnlyFromBackend, $Out>
  get $asCategoryViewOnlyFromBackend => $base.as(
    (v, t, t2) => _CategoryViewOnlyFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CategoryViewOnlyFromBackendCopyWith<
  $R,
  $In extends CategoryViewOnlyFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, String? budgetId});
  CategoryViewOnlyFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CategoryViewOnlyFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CategoryViewOnlyFromBackend, $Out>
    implements
        CategoryViewOnlyFromBackendCopyWith<
          $R,
          CategoryViewOnlyFromBackend,
          $Out
        > {
  _CategoryViewOnlyFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<CategoryViewOnlyFromBackend> $mapper =
      CategoryViewOnlyFromBackendMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? budgetId}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (budgetId != null) #budgetId: budgetId,
    }),
  );
  @override
  CategoryViewOnlyFromBackend $make(CopyWithData data) =>
      CategoryViewOnlyFromBackend(
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
        budgetId: data.get(#budgetId, or: $value.budgetId),
      );

  @override
  CategoryViewOnlyFromBackendCopyWith<$R2, CategoryViewOnlyFromBackend, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CategoryViewOnlyFromBackendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JoinedCategoryViewFromBackendMapper
    extends ClassMapperBase<JoinedCategoryViewFromBackend> {
  JoinedCategoryViewFromBackendMapper._();

  static JoinedCategoryViewFromBackendMapper? _instance;
  static JoinedCategoryViewFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = JoinedCategoryViewFromBackendMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'JoinedCategoryViewFromBackend';

  static String _$id(JoinedCategoryViewFromBackend v) => v.id;
  static const Field<JoinedCategoryViewFromBackend, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$name(JoinedCategoryViewFromBackend v) => v.name;
  static const Field<JoinedCategoryViewFromBackend, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$budgetId(JoinedCategoryViewFromBackend v) => v.budgetId;
  static const Field<JoinedCategoryViewFromBackend, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static DateTime _$createdAt(JoinedCategoryViewFromBackend v) => v.createdAt;
  static const Field<JoinedCategoryViewFromBackend, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static List<String> _$categories(JoinedCategoryViewFromBackend v) =>
      v.categories;
  static const Field<JoinedCategoryViewFromBackend, List<String>>
  _f$categories = Field('categories', _$categories);
  static List<String> _$categoryGroups(JoinedCategoryViewFromBackend v) =>
      v.categoryGroups;
  static const Field<JoinedCategoryViewFromBackend, List<String>>
  _f$categoryGroups = Field(
    'categoryGroups',
    _$categoryGroups,
    key: r'category_groups',
  );

  @override
  final MappableFields<JoinedCategoryViewFromBackend> fields = const {
    #id: _f$id,
    #name: _f$name,
    #budgetId: _f$budgetId,
    #createdAt: _f$createdAt,
    #categories: _f$categories,
    #categoryGroups: _f$categoryGroups,
  };

  static JoinedCategoryViewFromBackend _instantiate(DecodingData data) {
    return JoinedCategoryViewFromBackend(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      budgetId: data.dec(_f$budgetId),
      createdAt: data.dec(_f$createdAt),
      categories: data.dec(_f$categories),
      categoryGroups: data.dec(_f$categoryGroups),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JoinedCategoryViewFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JoinedCategoryViewFromBackend>(map);
  }

  static JoinedCategoryViewFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<JoinedCategoryViewFromBackend>(json);
  }
}

mixin JoinedCategoryViewFromBackendMappable {
  String toJson() {
    return JoinedCategoryViewFromBackendMapper.ensureInitialized()
        .encodeJson<JoinedCategoryViewFromBackend>(
          this as JoinedCategoryViewFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return JoinedCategoryViewFromBackendMapper.ensureInitialized()
        .encodeMap<JoinedCategoryViewFromBackend>(
          this as JoinedCategoryViewFromBackend,
        );
  }

  JoinedCategoryViewFromBackendCopyWith<
    JoinedCategoryViewFromBackend,
    JoinedCategoryViewFromBackend,
    JoinedCategoryViewFromBackend
  >
  get copyWith =>
      _JoinedCategoryViewFromBackendCopyWithImpl<
        JoinedCategoryViewFromBackend,
        JoinedCategoryViewFromBackend
      >(this as JoinedCategoryViewFromBackend, $identity, $identity);
  @override
  String toString() {
    return JoinedCategoryViewFromBackendMapper.ensureInitialized()
        .stringifyValue(this as JoinedCategoryViewFromBackend);
  }

  @override
  bool operator ==(Object other) {
    return JoinedCategoryViewFromBackendMapper.ensureInitialized().equalsValue(
      this as JoinedCategoryViewFromBackend,
      other,
    );
  }

  @override
  int get hashCode {
    return JoinedCategoryViewFromBackendMapper.ensureInitialized().hashValue(
      this as JoinedCategoryViewFromBackend,
    );
  }
}

extension JoinedCategoryViewFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JoinedCategoryViewFromBackend, $Out> {
  JoinedCategoryViewFromBackendCopyWith<$R, JoinedCategoryViewFromBackend, $Out>
  get $asJoinedCategoryViewFromBackend => $base.as(
    (v, t, t2) =>
        _JoinedCategoryViewFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JoinedCategoryViewFromBackendCopyWith<
  $R,
  $In extends JoinedCategoryViewFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categories;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroups;
  $R call({
    String? id,
    String? name,
    String? budgetId,
    DateTime? createdAt,
    List<String>? categories,
    List<String>? categoryGroups,
  });
  JoinedCategoryViewFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JoinedCategoryViewFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JoinedCategoryViewFromBackend, $Out>
    implements
        JoinedCategoryViewFromBackendCopyWith<
          $R,
          JoinedCategoryViewFromBackend,
          $Out
        > {
  _JoinedCategoryViewFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<JoinedCategoryViewFromBackend> $mapper =
      JoinedCategoryViewFromBackendMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categories =>
      ListCopyWith(
        $value.categories,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(categories: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryGroups => ListCopyWith(
    $value.categoryGroups,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryGroups: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    String? budgetId,
    DateTime? createdAt,
    List<String>? categories,
    List<String>? categoryGroups,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (budgetId != null) #budgetId: budgetId,
      if (createdAt != null) #createdAt: createdAt,
      if (categories != null) #categories: categories,
      if (categoryGroups != null) #categoryGroups: categoryGroups,
    }),
  );
  @override
  JoinedCategoryViewFromBackend $make(CopyWithData data) =>
      JoinedCategoryViewFromBackend(
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        createdAt: data.get(#createdAt, or: $value.createdAt),
        categories: data.get(#categories, or: $value.categories),
        categoryGroups: data.get(#categoryGroups, or: $value.categoryGroups),
      );

  @override
  JoinedCategoryViewFromBackendCopyWith<
    $R2,
    JoinedCategoryViewFromBackend,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _JoinedCategoryViewFromBackendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

