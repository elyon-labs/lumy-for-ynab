// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'categories_response.dart';

class TargetTypeMapper extends EnumMapper<TargetType> {
  TargetTypeMapper._();

  static TargetTypeMapper? _instance;
  static TargetTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TargetTypeMapper._());
    }
    return _instance!;
  }

  static TargetType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TargetType decode(dynamic value) {
    switch (value) {
      case 'TB':
        return TargetType.TB;
      case 'TBD':
        return TargetType.TBD;
      case 'MF':
        return TargetType.MF;
      case 'NEED':
        return TargetType.NEED;
      case 'DEBT':
        return TargetType.DEBT;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TargetType self) {
    switch (self) {
      case TargetType.TB:
        return 'TB';
      case TargetType.TBD:
        return 'TBD';
      case TargetType.MF:
        return 'MF';
      case TargetType.NEED:
        return 'NEED';
      case TargetType.DEBT:
        return 'DEBT';
    }
  }
}

extension TargetTypeMapperExtension on TargetType {
  String toValue() {
    TargetTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TargetType>(this) as String;
  }
}

class CategoriesResponseMapper extends ClassMapperBase<CategoriesResponse> {
  CategoriesResponseMapper._();

  static CategoriesResponseMapper? _instance;
  static CategoriesResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoriesResponseMapper._());
      CategoriesMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CategoriesResponse';

  static Categories _$data(CategoriesResponse v) => v.data;
  static const Field<CategoriesResponse, Categories> _f$data = Field('data', _$data);

  @override
  final MappableFields<CategoriesResponse> fields = const {#data: _f$data};

  static CategoriesResponse _instantiate(DecodingData data) {
    return CategoriesResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static CategoriesResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CategoriesResponse>(map);
  }

  static CategoriesResponse fromJson(String json) {
    return ensureInitialized().decodeJson<CategoriesResponse>(json);
  }
}

mixin CategoriesResponseMappable {
  String toJson() {
    return CategoriesResponseMapper.ensureInitialized().encodeJson<CategoriesResponse>(
      this as CategoriesResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return CategoriesResponseMapper.ensureInitialized().encodeMap<CategoriesResponse>(
      this as CategoriesResponse,
    );
  }

  CategoriesResponseCopyWith<CategoriesResponse, CategoriesResponse, CategoriesResponse>
  get copyWith => _CategoriesResponseCopyWithImpl(this as CategoriesResponse, $identity, $identity);
  @override
  String toString() {
    return CategoriesResponseMapper.ensureInitialized().stringifyValue(this as CategoriesResponse);
  }

  @override
  bool operator ==(Object other) {
    return CategoriesResponseMapper.ensureInitialized().equalsValue(
      this as CategoriesResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return CategoriesResponseMapper.ensureInitialized().hashValue(this as CategoriesResponse);
  }
}

extension CategoriesResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, CategoriesResponse, $Out> {
  CategoriesResponseCopyWith<$R, CategoriesResponse, $Out> get $asCategoriesResponse =>
      $base.as((v, t, t2) => _CategoriesResponseCopyWithImpl(v, t, t2));
}

abstract class CategoriesResponseCopyWith<$R, $In extends CategoriesResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CategoriesCopyWith<$R, Categories, Categories> get data;
  $R call({Categories? data});
  CategoriesResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoriesResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CategoriesResponse, $Out>
    implements CategoriesResponseCopyWith<$R, CategoriesResponse, $Out> {
  _CategoriesResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CategoriesResponse> $mapper =
      CategoriesResponseMapper.ensureInitialized();
  @override
  CategoriesCopyWith<$R, Categories, Categories> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Categories? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  CategoriesResponse $make(CopyWithData data) =>
      CategoriesResponse(data: data.get(#data, or: $value.data));

  @override
  CategoriesResponseCopyWith<$R2, CategoriesResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CategoriesResponseCopyWithImpl($value, $cast, t);
}

class CategoriesMapper extends ClassMapperBase<Categories> {
  CategoriesMapper._();

  static CategoriesMapper? _instance;
  static CategoriesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoriesMapper._());
      CategoryGroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Categories';

  static List<CategoryGroup> _$categoryGroups(Categories v) => v.categoryGroups;
  static const Field<Categories, List<CategoryGroup>> _f$categoryGroups = Field(
    'categoryGroups',
    _$categoryGroups,
    key: 'category_groups',
  );
  static int _$serverKnowledge(Categories v) => v.serverKnowledge;
  static const Field<Categories, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );

  @override
  final MappableFields<Categories> fields = const {
    #categoryGroups: _f$categoryGroups,
    #serverKnowledge: _f$serverKnowledge,
  };

  static Categories _instantiate(DecodingData data) {
    return Categories(
      categoryGroups: data.dec(_f$categoryGroups),
      serverKnowledge: data.dec(_f$serverKnowledge),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Categories fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Categories>(map);
  }

  static Categories fromJson(String json) {
    return ensureInitialized().decodeJson<Categories>(json);
  }
}

mixin CategoriesMappable {
  String toJson() {
    return CategoriesMapper.ensureInitialized().encodeJson<Categories>(this as Categories);
  }

  Map<String, dynamic> toMap() {
    return CategoriesMapper.ensureInitialized().encodeMap<Categories>(this as Categories);
  }

  CategoriesCopyWith<Categories, Categories, Categories> get copyWith =>
      _CategoriesCopyWithImpl(this as Categories, $identity, $identity);
  @override
  String toString() {
    return CategoriesMapper.ensureInitialized().stringifyValue(this as Categories);
  }

  @override
  bool operator ==(Object other) {
    return CategoriesMapper.ensureInitialized().equalsValue(this as Categories, other);
  }

  @override
  int get hashCode {
    return CategoriesMapper.ensureInitialized().hashValue(this as Categories);
  }
}

extension CategoriesValueCopy<$R, $Out> on ObjectCopyWith<$R, Categories, $Out> {
  CategoriesCopyWith<$R, Categories, $Out> get $asCategories =>
      $base.as((v, t, t2) => _CategoriesCopyWithImpl(v, t, t2));
}

abstract class CategoriesCopyWith<$R, $In extends Categories, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, CategoryGroup, CategoryGroupCopyWith<$R, CategoryGroup, CategoryGroup>>
  get categoryGroups;
  $R call({List<CategoryGroup>? categoryGroups, int? serverKnowledge});
  CategoriesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoriesCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Categories, $Out>
    implements CategoriesCopyWith<$R, Categories, $Out> {
  _CategoriesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Categories> $mapper = CategoriesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, CategoryGroup, CategoryGroupCopyWith<$R, CategoryGroup, CategoryGroup>>
  get categoryGroups => ListCopyWith(
    $value.categoryGroups,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(categoryGroups: v),
  );
  @override
  $R call({List<CategoryGroup>? categoryGroups, int? serverKnowledge}) => $apply(
    FieldCopyWithData({
      if (categoryGroups != null) #categoryGroups: categoryGroups,
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
    }),
  );
  @override
  Categories $make(CopyWithData data) => Categories(
    categoryGroups: data.get(#categoryGroups, or: $value.categoryGroups),
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
  );

  @override
  CategoriesCopyWith<$R2, Categories, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CategoriesCopyWithImpl($value, $cast, t);
}

class CategoryGroupMapper extends ClassMapperBase<CategoryGroup> {
  CategoryGroupMapper._();

  static CategoryGroupMapper? _instance;
  static CategoryGroupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoryGroupMapper._());
      CategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CategoryGroup';

  static String _$name(CategoryGroup v) => v.name;
  static const Field<CategoryGroup, String> _f$name = Field('name', _$name);
  static String _$id(CategoryGroup v) => v.id;
  static const Field<CategoryGroup, String> _f$id = Field('id', _$id);
  static bool _$isHidden(CategoryGroup v) => v.isHidden;
  static const Field<CategoryGroup, bool> _f$isHidden = Field(
    'isHidden',
    _$isHidden,
    key: 'hidden',
  );
  static bool _$isDeleted(CategoryGroup v) => v.isDeleted;
  static const Field<CategoryGroup, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );
  static List<Category> _$categories(CategoryGroup v) => v.categories;
  static const Field<CategoryGroup, List<Category>> _f$categories = Field(
    'categories',
    _$categories,
  );

  @override
  final MappableFields<CategoryGroup> fields = const {
    #name: _f$name,
    #id: _f$id,
    #isHidden: _f$isHidden,
    #isDeleted: _f$isDeleted,
    #categories: _f$categories,
  };

  static CategoryGroup _instantiate(DecodingData data) {
    return CategoryGroup(
      name: data.dec(_f$name),
      id: data.dec(_f$id),
      isHidden: data.dec(_f$isHidden),
      isDeleted: data.dec(_f$isDeleted),
      categories: data.dec(_f$categories),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CategoryGroup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CategoryGroup>(map);
  }

  static CategoryGroup fromJson(String json) {
    return ensureInitialized().decodeJson<CategoryGroup>(json);
  }
}

mixin CategoryGroupMappable {
  String toJson() {
    return CategoryGroupMapper.ensureInitialized().encodeJson<CategoryGroup>(this as CategoryGroup);
  }

  Map<String, dynamic> toMap() {
    return CategoryGroupMapper.ensureInitialized().encodeMap<CategoryGroup>(this as CategoryGroup);
  }

  CategoryGroupCopyWith<CategoryGroup, CategoryGroup, CategoryGroup> get copyWith =>
      _CategoryGroupCopyWithImpl(this as CategoryGroup, $identity, $identity);
  @override
  String toString() {
    return CategoryGroupMapper.ensureInitialized().stringifyValue(this as CategoryGroup);
  }

  @override
  bool operator ==(Object other) {
    return CategoryGroupMapper.ensureInitialized().equalsValue(this as CategoryGroup, other);
  }

  @override
  int get hashCode {
    return CategoryGroupMapper.ensureInitialized().hashValue(this as CategoryGroup);
  }
}

extension CategoryGroupValueCopy<$R, $Out> on ObjectCopyWith<$R, CategoryGroup, $Out> {
  CategoryGroupCopyWith<$R, CategoryGroup, $Out> get $asCategoryGroup =>
      $base.as((v, t, t2) => _CategoryGroupCopyWithImpl(v, t, t2));
}

abstract class CategoryGroupCopyWith<$R, $In extends CategoryGroup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Category, CategoryCopyWith<$R, Category, Category>> get categories;
  $R call({String? name, String? id, bool? isHidden, bool? isDeleted, List<Category>? categories});
  CategoryGroupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoryGroupCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, CategoryGroup, $Out>
    implements CategoryGroupCopyWith<$R, CategoryGroup, $Out> {
  _CategoryGroupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CategoryGroup> $mapper = CategoryGroupMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Category, CategoryCopyWith<$R, Category, Category>> get categories =>
      ListCopyWith($value.categories, (v, t) => v.copyWith.$chain(t), (v) => call(categories: v));
  @override
  $R call({
    String? name,
    String? id,
    bool? isHidden,
    bool? isDeleted,
    List<Category>? categories,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (id != null) #id: id,
      if (isHidden != null) #isHidden: isHidden,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (categories != null) #categories: categories,
    }),
  );
  @override
  CategoryGroup $make(CopyWithData data) => CategoryGroup(
    name: data.get(#name, or: $value.name),
    id: data.get(#id, or: $value.id),
    isHidden: data.get(#isHidden, or: $value.isHidden),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    categories: data.get(#categories, or: $value.categories),
  );

  @override
  CategoryGroupCopyWith<$R2, CategoryGroup, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CategoryGroupCopyWithImpl($value, $cast, t);
}

class CategoryMapper extends ClassMapperBase<Category> {
  CategoryMapper._();

  static CategoryMapper? _instance;
  static CategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CategoryMapper._());
      TargetTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Category';

  static String _$id(Category v) => v.id;
  static const Field<Category, String> _f$id = Field('id', _$id);
  static String _$name(Category v) => v.name;
  static const Field<Category, String> _f$name = Field('name', _$name);
  static String _$categoryGroupId(Category v) => v.categoryGroupId;
  static const Field<Category, String> _f$categoryGroupId = Field(
    'categoryGroupId',
    _$categoryGroupId,
    key: 'category_group_id',
  );
  static bool _$isHidden(Category v) => v.isHidden;
  static const Field<Category, bool> _f$isHidden = Field('isHidden', _$isHidden, key: 'hidden');
  static bool _$isDeleted(Category v) => v.isDeleted;
  static const Field<Category, bool> _f$isDeleted = Field('isDeleted', _$isDeleted, key: 'deleted');
  static int _$activity(Category v) => v.activity;
  static const Field<Category, int> _f$activity = Field('activity', _$activity);
  static int _$budgeted(Category v) => v.budgeted;
  static const Field<Category, int> _f$budgeted = Field('budgeted', _$budgeted);
  static int _$balance(Category v) => v.balance;
  static const Field<Category, int> _f$balance = Field('balance', _$balance);
  static TargetType? _$targetType(Category v) => v.targetType;
  static const Field<Category, TargetType> _f$targetType = Field(
    'targetType',
    _$targetType,
    key: 'goal_type',
  );
  static bool? _$targetNeedsWholeAmount(Category v) => v.targetNeedsWholeAmount;
  static const Field<Category, bool> _f$targetNeedsWholeAmount = Field(
    'targetNeedsWholeAmount',
    _$targetNeedsWholeAmount,
    key: 'goal_needs_whole_amount',
  );
  static int? _$targetDay(Category v) => v.targetDay;
  static const Field<Category, int> _f$targetDay = Field('targetDay', _$targetDay, key: 'goal_day');
  static int? _$targetCadence(Category v) => v.targetCadence;
  static const Field<Category, int> _f$targetCadence = Field(
    'targetCadence',
    _$targetCadence,
    key: 'goal_cadence',
  );
  static int? _$targetCadenceFrequency(Category v) => v.targetCadenceFrequency;
  static const Field<Category, int> _f$targetCadenceFrequency = Field(
    'targetCadenceFrequency',
    _$targetCadenceFrequency,
    key: 'goal_cadence_frequency',
  );
  static String? _$targetCreationMonth(Category v) => v.targetCreationMonth;
  static const Field<Category, String> _f$targetCreationMonth = Field(
    'targetCreationMonth',
    _$targetCreationMonth,
    key: 'goal_creation_month',
  );
  static int? _$targetBalance(Category v) => v.targetBalance;
  static const Field<Category, int> _f$targetBalance = Field(
    'targetBalance',
    _$targetBalance,
    key: 'goal_target',
  );
  static String? _$targetMonth(Category v) => v.targetMonth;
  static const Field<Category, String> _f$targetMonth = Field(
    'targetMonth',
    _$targetMonth,
    key: 'goal_target_month',
  );
  static int? _$targetPercentageComplete(Category v) => v.targetPercentageComplete;
  static const Field<Category, int> _f$targetPercentageComplete = Field(
    'targetPercentageComplete',
    _$targetPercentageComplete,
    key: 'goal_percentage_complete',
  );
  static int? _$targetMonthsToBudget(Category v) => v.targetMonthsToBudget;
  static const Field<Category, int> _f$targetMonthsToBudget = Field(
    'targetMonthsToBudget',
    _$targetMonthsToBudget,
    key: 'goal_months_to_budget',
  );
  static int? _$targetUnderFunded(Category v) => v.targetUnderFunded;
  static const Field<Category, int> _f$targetUnderFunded = Field(
    'targetUnderFunded',
    _$targetUnderFunded,
    key: 'goal_under_funded',
  );
  static int? _$targetOverallFunded(Category v) => v.targetOverallFunded;
  static const Field<Category, int> _f$targetOverallFunded = Field(
    'targetOverallFunded',
    _$targetOverallFunded,
    key: 'goal_overall_funded',
  );
  static int? _$targetOverallLeft(Category v) => v.targetOverallLeft;
  static const Field<Category, int> _f$targetOverallLeft = Field(
    'targetOverallLeft',
    _$targetOverallLeft,
    key: 'goal_overall_left',
  );

  @override
  final MappableFields<Category> fields = const {
    #id: _f$id,
    #name: _f$name,
    #categoryGroupId: _f$categoryGroupId,
    #isHidden: _f$isHidden,
    #isDeleted: _f$isDeleted,
    #activity: _f$activity,
    #budgeted: _f$budgeted,
    #balance: _f$balance,
    #targetType: _f$targetType,
    #targetNeedsWholeAmount: _f$targetNeedsWholeAmount,
    #targetDay: _f$targetDay,
    #targetCadence: _f$targetCadence,
    #targetCadenceFrequency: _f$targetCadenceFrequency,
    #targetCreationMonth: _f$targetCreationMonth,
    #targetBalance: _f$targetBalance,
    #targetMonth: _f$targetMonth,
    #targetPercentageComplete: _f$targetPercentageComplete,
    #targetMonthsToBudget: _f$targetMonthsToBudget,
    #targetUnderFunded: _f$targetUnderFunded,
    #targetOverallFunded: _f$targetOverallFunded,
    #targetOverallLeft: _f$targetOverallLeft,
  };

  static Category _instantiate(DecodingData data) {
    return Category(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      categoryGroupId: data.dec(_f$categoryGroupId),
      isHidden: data.dec(_f$isHidden),
      isDeleted: data.dec(_f$isDeleted),
      activity: data.dec(_f$activity),
      budgeted: data.dec(_f$budgeted),
      balance: data.dec(_f$balance),
      targetType: data.dec(_f$targetType),
      targetNeedsWholeAmount: data.dec(_f$targetNeedsWholeAmount),
      targetDay: data.dec(_f$targetDay),
      targetCadence: data.dec(_f$targetCadence),
      targetCadenceFrequency: data.dec(_f$targetCadenceFrequency),
      targetCreationMonth: data.dec(_f$targetCreationMonth),
      targetBalance: data.dec(_f$targetBalance),
      targetMonth: data.dec(_f$targetMonth),
      targetPercentageComplete: data.dec(_f$targetPercentageComplete),
      targetMonthsToBudget: data.dec(_f$targetMonthsToBudget),
      targetUnderFunded: data.dec(_f$targetUnderFunded),
      targetOverallFunded: data.dec(_f$targetOverallFunded),
      targetOverallLeft: data.dec(_f$targetOverallLeft),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Category fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Category>(map);
  }

  static Category fromJson(String json) {
    return ensureInitialized().decodeJson<Category>(json);
  }
}

mixin CategoryMappable {
  String toJson() {
    return CategoryMapper.ensureInitialized().encodeJson<Category>(this as Category);
  }

  Map<String, dynamic> toMap() {
    return CategoryMapper.ensureInitialized().encodeMap<Category>(this as Category);
  }

  CategoryCopyWith<Category, Category, Category> get copyWith =>
      _CategoryCopyWithImpl(this as Category, $identity, $identity);
  @override
  String toString() {
    return CategoryMapper.ensureInitialized().stringifyValue(this as Category);
  }

  @override
  bool operator ==(Object other) {
    return CategoryMapper.ensureInitialized().equalsValue(this as Category, other);
  }

  @override
  int get hashCode {
    return CategoryMapper.ensureInitialized().hashValue(this as Category);
  }
}

extension CategoryValueCopy<$R, $Out> on ObjectCopyWith<$R, Category, $Out> {
  CategoryCopyWith<$R, Category, $Out> get $asCategory =>
      $base.as((v, t, t2) => _CategoryCopyWithImpl(v, t, t2));
}

abstract class CategoryCopyWith<$R, $In extends Category, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? name,
    String? categoryGroupId,
    bool? isHidden,
    bool? isDeleted,
    int? activity,
    int? budgeted,
    int? balance,
    TargetType? targetType,
    bool? targetNeedsWholeAmount,
    int? targetDay,
    int? targetCadence,
    int? targetCadenceFrequency,
    String? targetCreationMonth,
    int? targetBalance,
    String? targetMonth,
    int? targetPercentageComplete,
    int? targetMonthsToBudget,
    int? targetUnderFunded,
    int? targetOverallFunded,
    int? targetOverallLeft,
  });
  CategoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CategoryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Category, $Out>
    implements CategoryCopyWith<$R, Category, $Out> {
  _CategoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Category> $mapper = CategoryMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    String? categoryGroupId,
    bool? isHidden,
    bool? isDeleted,
    int? activity,
    int? budgeted,
    int? balance,
    Object? targetType = $none,
    Object? targetNeedsWholeAmount = $none,
    Object? targetDay = $none,
    Object? targetCadence = $none,
    Object? targetCadenceFrequency = $none,
    Object? targetCreationMonth = $none,
    Object? targetBalance = $none,
    Object? targetMonth = $none,
    Object? targetPercentageComplete = $none,
    Object? targetMonthsToBudget = $none,
    Object? targetUnderFunded = $none,
    Object? targetOverallFunded = $none,
    Object? targetOverallLeft = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (categoryGroupId != null) #categoryGroupId: categoryGroupId,
      if (isHidden != null) #isHidden: isHidden,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (activity != null) #activity: activity,
      if (budgeted != null) #budgeted: budgeted,
      if (balance != null) #balance: balance,
      if (targetType != $none) #targetType: targetType,
      if (targetNeedsWholeAmount != $none) #targetNeedsWholeAmount: targetNeedsWholeAmount,
      if (targetDay != $none) #targetDay: targetDay,
      if (targetCadence != $none) #targetCadence: targetCadence,
      if (targetCadenceFrequency != $none) #targetCadenceFrequency: targetCadenceFrequency,
      if (targetCreationMonth != $none) #targetCreationMonth: targetCreationMonth,
      if (targetBalance != $none) #targetBalance: targetBalance,
      if (targetMonth != $none) #targetMonth: targetMonth,
      if (targetPercentageComplete != $none) #targetPercentageComplete: targetPercentageComplete,
      if (targetMonthsToBudget != $none) #targetMonthsToBudget: targetMonthsToBudget,
      if (targetUnderFunded != $none) #targetUnderFunded: targetUnderFunded,
      if (targetOverallFunded != $none) #targetOverallFunded: targetOverallFunded,
      if (targetOverallLeft != $none) #targetOverallLeft: targetOverallLeft,
    }),
  );
  @override
  Category $make(CopyWithData data) => Category(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    categoryGroupId: data.get(#categoryGroupId, or: $value.categoryGroupId),
    isHidden: data.get(#isHidden, or: $value.isHidden),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    activity: data.get(#activity, or: $value.activity),
    budgeted: data.get(#budgeted, or: $value.budgeted),
    balance: data.get(#balance, or: $value.balance),
    targetType: data.get(#targetType, or: $value.targetType),
    targetNeedsWholeAmount: data.get(#targetNeedsWholeAmount, or: $value.targetNeedsWholeAmount),
    targetDay: data.get(#targetDay, or: $value.targetDay),
    targetCadence: data.get(#targetCadence, or: $value.targetCadence),
    targetCadenceFrequency: data.get(#targetCadenceFrequency, or: $value.targetCadenceFrequency),
    targetCreationMonth: data.get(#targetCreationMonth, or: $value.targetCreationMonth),
    targetBalance: data.get(#targetBalance, or: $value.targetBalance),
    targetMonth: data.get(#targetMonth, or: $value.targetMonth),
    targetPercentageComplete: data.get(
      #targetPercentageComplete,
      or: $value.targetPercentageComplete,
    ),
    targetMonthsToBudget: data.get(#targetMonthsToBudget, or: $value.targetMonthsToBudget),
    targetUnderFunded: data.get(#targetUnderFunded, or: $value.targetUnderFunded),
    targetOverallFunded: data.get(#targetOverallFunded, or: $value.targetOverallFunded),
    targetOverallLeft: data.get(#targetOverallLeft, or: $value.targetOverallLeft),
  );

  @override
  CategoryCopyWith<$R2, Category, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CategoryCopyWithImpl($value, $cast, t);
}
