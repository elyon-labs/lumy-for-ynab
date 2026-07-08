// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'category_view_draft.dart';

class CategoryViewDraftMapper extends ClassMapperBase<CategoryViewDraft> {
  CategoryViewDraftMapper._();

  static CategoryViewDraftMapper? _instance;
  static CategoryViewDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoryViewDraftMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CategoryViewDraft';

  static List<String>? _$categoryIds(CategoryViewDraft v) => v.categoryIds;
  static const Field<CategoryViewDraft, List<String>> _f$categoryIds = Field(
    'categoryIds',
    _$categoryIds,
    key: r'category_ids',
    opt: true,
  );
  static List<String>? _$categoryGroupIds(CategoryViewDraft v) =>
      v.categoryGroupIds;
  static const Field<CategoryViewDraft, List<String>> _f$categoryGroupIds =
      Field(
        'categoryGroupIds',
        _$categoryGroupIds,
        key: r'category_group_ids',
        opt: true,
      );
  static String? _$name(CategoryViewDraft v) => v.name;
  static const Field<CategoryViewDraft, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );

  @override
  final MappableFields<CategoryViewDraft> fields = const {
    #categoryIds: _f$categoryIds,
    #categoryGroupIds: _f$categoryGroupIds,
    #name: _f$name,
  };

  static CategoryViewDraft _instantiate(DecodingData data) {
    return CategoryViewDraft(
      categoryIds: data.dec(_f$categoryIds),
      categoryGroupIds: data.dec(_f$categoryGroupIds),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CategoryViewDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CategoryViewDraft>(map);
  }

  static CategoryViewDraft fromJson(String json) {
    return ensureInitialized().decodeJson<CategoryViewDraft>(json);
  }
}

mixin CategoryViewDraftMappable {
  String toJson() {
    return CategoryViewDraftMapper.ensureInitialized()
        .encodeJson<CategoryViewDraft>(this as CategoryViewDraft);
  }

  Map<String, dynamic> toMap() {
    return CategoryViewDraftMapper.ensureInitialized()
        .encodeMap<CategoryViewDraft>(this as CategoryViewDraft);
  }

  CategoryViewDraftCopyWith<
    CategoryViewDraft,
    CategoryViewDraft,
    CategoryViewDraft
  >
  get copyWith =>
      _CategoryViewDraftCopyWithImpl<CategoryViewDraft, CategoryViewDraft>(
        this as CategoryViewDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CategoryViewDraftMapper.ensureInitialized().stringifyValue(
      this as CategoryViewDraft,
    );
  }

  @override
  bool operator ==(Object other) {
    return CategoryViewDraftMapper.ensureInitialized().equalsValue(
      this as CategoryViewDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return CategoryViewDraftMapper.ensureInitialized().hashValue(
      this as CategoryViewDraft,
    );
  }
}

extension CategoryViewDraftValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CategoryViewDraft, $Out> {
  CategoryViewDraftCopyWith<$R, CategoryViewDraft, $Out>
  get $asCategoryViewDraft => $base.as(
    (v, t, t2) => _CategoryViewDraftCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CategoryViewDraftCopyWith<
  $R,
  $In extends CategoryViewDraft,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get categoryGroupIds;
  $R call({
    List<String>? categoryIds,
    List<String>? categoryGroupIds,
    String? name,
  });
  CategoryViewDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CategoryViewDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CategoryViewDraft, $Out>
    implements CategoryViewDraftCopyWith<$R, CategoryViewDraft, $Out> {
  _CategoryViewDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CategoryViewDraft> $mapper =
      CategoryViewDraftMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get categoryIds => $value.categoryIds != null
      ? ListCopyWith(
          $value.categoryIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categoryIds: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get categoryGroupIds => $value.categoryGroupIds != null
      ? ListCopyWith(
          $value.categoryGroupIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categoryGroupIds: v),
        )
      : null;
  @override
  $R call({
    Object? categoryIds = $none,
    Object? categoryGroupIds = $none,
    Object? name = $none,
  }) => $apply(
    FieldCopyWithData({
      if (categoryIds != $none) #categoryIds: categoryIds,
      if (categoryGroupIds != $none) #categoryGroupIds: categoryGroupIds,
      if (name != $none) #name: name,
    }),
  );
  @override
  CategoryViewDraft $make(CopyWithData data) => CategoryViewDraft(
    categoryIds: data.get(#categoryIds, or: $value.categoryIds),
    categoryGroupIds: data.get(#categoryGroupIds, or: $value.categoryGroupIds),
    name: data.get(#name, or: $value.name),
  );

  @override
  CategoryViewDraftCopyWith<$R2, CategoryViewDraft, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CategoryViewDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

