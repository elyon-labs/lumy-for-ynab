// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_tab_state.dart';

class SettingsTabStateMapper extends ClassMapperBase<SettingsTabState> {
  SettingsTabStateMapper._();

  static SettingsTabStateMapper? _instance;
  static SettingsTabStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsTabStateMapper._());
      BudgetMapper.ensureInitialized();
      SpendTrackerMapper.ensureInitialized();
      FrugalMonthMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsTabState';

  static Option<Budget> _$selectedBudget(SettingsTabState v) =>
      v.selectedBudget;
  static const Field<SettingsTabState, Option<Budget>> _f$selectedBudget =
      Field('selectedBudget', _$selectedBudget, key: r'selected_budget');
  static List<Budget> _$allBudgets(SettingsTabState v) => v.allBudgets;
  static const Field<SettingsTabState, List<Budget>> _f$allBudgets = Field(
    'allBudgets',
    _$allBudgets,
    key: r'all_budgets',
  );
  static List<SpendTracker> _$spendTrackers(SettingsTabState v) =>
      v.spendTrackers;
  static const Field<SettingsTabState, List<SpendTracker>> _f$spendTrackers =
      Field('spendTrackers', _$spendTrackers, key: r'spend_trackers');
  static bool _$shouldShowNullCurrencyTile(SettingsTabState v) =>
      v.shouldShowNullCurrencyTile;
  static const Field<SettingsTabState, bool> _f$shouldShowNullCurrencyTile =
      Field(
        'shouldShowNullCurrencyTile',
        _$shouldShowNullCurrencyTile,
        key: r'should_show_null_currency_tile',
      );
  static ThemeMode _$themeMode(SettingsTabState v) => v.themeMode;
  static const Field<SettingsTabState, ThemeMode> _f$themeMode = Field(
    'themeMode',
    _$themeMode,
    key: r'theme_mode',
  );
  static List<FrugalMonth> _$pastFrugalMonths(SettingsTabState v) =>
      v.pastFrugalMonths;
  static const Field<SettingsTabState, List<FrugalMonth>> _f$pastFrugalMonths =
      Field('pastFrugalMonths', _$pastFrugalMonths, key: r'past_frugal_months');
  static bool _$isLoading(SettingsTabState v) => v.isLoading;
  static const Field<SettingsTabState, bool> _f$isLoading = Field(
    'isLoading',
    _$isLoading,
    key: r'is_loading',
  );
  static bool _$isUserAnonymous(SettingsTabState v) => v.isUserAnonymous;
  static const Field<SettingsTabState, bool> _f$isUserAnonymous = Field(
    'isUserAnonymous',
    _$isUserAnonymous,
    key: r'is_user_anonymous',
  );

  @override
  final MappableFields<SettingsTabState> fields = const {
    #selectedBudget: _f$selectedBudget,
    #allBudgets: _f$allBudgets,
    #spendTrackers: _f$spendTrackers,
    #shouldShowNullCurrencyTile: _f$shouldShowNullCurrencyTile,
    #themeMode: _f$themeMode,
    #pastFrugalMonths: _f$pastFrugalMonths,
    #isLoading: _f$isLoading,
    #isUserAnonymous: _f$isUserAnonymous,
  };

  static SettingsTabState _instantiate(DecodingData data) {
    return SettingsTabState(
      selectedBudget: data.dec(_f$selectedBudget),
      allBudgets: data.dec(_f$allBudgets),
      spendTrackers: data.dec(_f$spendTrackers),
      shouldShowNullCurrencyTile: data.dec(_f$shouldShowNullCurrencyTile),
      themeMode: data.dec(_f$themeMode),
      pastFrugalMonths: data.dec(_f$pastFrugalMonths),
      isLoading: data.dec(_f$isLoading),
      isUserAnonymous: data.dec(_f$isUserAnonymous),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsTabState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsTabState>(map);
  }

  static SettingsTabState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsTabState>(json);
  }
}

mixin SettingsTabStateMappable {
  String toJson() {
    return SettingsTabStateMapper.ensureInitialized()
        .encodeJson<SettingsTabState>(this as SettingsTabState);
  }

  Map<String, dynamic> toMap() {
    return SettingsTabStateMapper.ensureInitialized()
        .encodeMap<SettingsTabState>(this as SettingsTabState);
  }

  SettingsTabStateCopyWith<SettingsTabState, SettingsTabState, SettingsTabState>
  get copyWith =>
      _SettingsTabStateCopyWithImpl<SettingsTabState, SettingsTabState>(
        this as SettingsTabState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SettingsTabStateMapper.ensureInitialized().stringifyValue(
      this as SettingsTabState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsTabStateMapper.ensureInitialized().equalsValue(
      this as SettingsTabState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsTabStateMapper.ensureInitialized().hashValue(
      this as SettingsTabState,
    );
  }
}

extension SettingsTabStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsTabState, $Out> {
  SettingsTabStateCopyWith<$R, SettingsTabState, $Out>
  get $asSettingsTabState =>
      $base.as((v, t, t2) => _SettingsTabStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsTabStateCopyWith<$R, $In extends SettingsTabState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Budget, BudgetCopyWith<$R, Budget, Budget>> get allBudgets;
  ListCopyWith<
    $R,
    SpendTracker,
    SpendTrackerCopyWith<$R, SpendTracker, SpendTracker>
  >
  get spendTrackers;
  ListCopyWith<
    $R,
    FrugalMonth,
    FrugalMonthCopyWith<$R, FrugalMonth, FrugalMonth>
  >
  get pastFrugalMonths;
  $R call({
    Option<Budget>? selectedBudget,
    List<Budget>? allBudgets,
    List<SpendTracker>? spendTrackers,
    bool? shouldShowNullCurrencyTile,
    ThemeMode? themeMode,
    List<FrugalMonth>? pastFrugalMonths,
    bool? isLoading,
    bool? isUserAnonymous,
  });
  SettingsTabStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsTabStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsTabState, $Out>
    implements SettingsTabStateCopyWith<$R, SettingsTabState, $Out> {
  _SettingsTabStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsTabState> $mapper =
      SettingsTabStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Budget, BudgetCopyWith<$R, Budget, Budget>> get allBudgets =>
      ListCopyWith(
        $value.allBudgets,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(allBudgets: v),
      );
  @override
  ListCopyWith<
    $R,
    SpendTracker,
    SpendTrackerCopyWith<$R, SpendTracker, SpendTracker>
  >
  get spendTrackers => ListCopyWith(
    $value.spendTrackers,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(spendTrackers: v),
  );
  @override
  ListCopyWith<
    $R,
    FrugalMonth,
    FrugalMonthCopyWith<$R, FrugalMonth, FrugalMonth>
  >
  get pastFrugalMonths => ListCopyWith(
    $value.pastFrugalMonths,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(pastFrugalMonths: v),
  );
  @override
  $R call({
    Option<Budget>? selectedBudget,
    List<Budget>? allBudgets,
    List<SpendTracker>? spendTrackers,
    bool? shouldShowNullCurrencyTile,
    ThemeMode? themeMode,
    List<FrugalMonth>? pastFrugalMonths,
    bool? isLoading,
    bool? isUserAnonymous,
  }) => $apply(
    FieldCopyWithData({
      if (selectedBudget != null) #selectedBudget: selectedBudget,
      if (allBudgets != null) #allBudgets: allBudgets,
      if (spendTrackers != null) #spendTrackers: spendTrackers,
      if (shouldShowNullCurrencyTile != null)
        #shouldShowNullCurrencyTile: shouldShowNullCurrencyTile,
      if (themeMode != null) #themeMode: themeMode,
      if (pastFrugalMonths != null) #pastFrugalMonths: pastFrugalMonths,
      if (isLoading != null) #isLoading: isLoading,
      if (isUserAnonymous != null) #isUserAnonymous: isUserAnonymous,
    }),
  );
  @override
  SettingsTabState $make(CopyWithData data) => SettingsTabState(
    selectedBudget: data.get(#selectedBudget, or: $value.selectedBudget),
    allBudgets: data.get(#allBudgets, or: $value.allBudgets),
    spendTrackers: data.get(#spendTrackers, or: $value.spendTrackers),
    shouldShowNullCurrencyTile: data.get(
      #shouldShowNullCurrencyTile,
      or: $value.shouldShowNullCurrencyTile,
    ),
    themeMode: data.get(#themeMode, or: $value.themeMode),
    pastFrugalMonths: data.get(#pastFrugalMonths, or: $value.pastFrugalMonths),
    isLoading: data.get(#isLoading, or: $value.isLoading),
    isUserAnonymous: data.get(#isUserAnonymous, or: $value.isUserAnonymous),
  );

  @override
  SettingsTabStateCopyWith<$R2, SettingsTabState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsTabStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

typedef _t$_R0<A, B, C> = ({A groups, B parent, C txn});

class _t$_R0Mapper extends RecordMapperBase<_t$_R0> {
  static _t$_R0Mapper? _instance;
  _t$_R0Mapper._();

  static _t$_R0Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = _t$_R0Mapper._());
      MapperBase.addType(<A, B, C>(f) => f<({A groups, B parent, C txn})>());
    }
    return _instance!;
  }

  static dynamic _$groups(_t$_R0 v) => v.groups;
  static dynamic _arg$groups<A, B, C>(f) => f<A>();
  static const Field<_t$_R0, dynamic> _f$groups = Field(
    'groups',
    _$groups,
    arg: _arg$groups,
  );
  static dynamic _$parent(_t$_R0 v) => v.parent;
  static dynamic _arg$parent<A, B, C>(f) => f<B>();
  static const Field<_t$_R0, dynamic> _f$parent = Field(
    'parent',
    _$parent,
    arg: _arg$parent,
  );
  static dynamic _$txn(_t$_R0 v) => v.txn;
  static dynamic _arg$txn<A, B, C>(f) => f<C>();
  static const Field<_t$_R0, dynamic> _f$txn = Field(
    'txn',
    _$txn,
    arg: _arg$txn,
  );

  @override
  final MappableFields<_t$_R0> fields = const {
    #groups: _f$groups,
    #parent: _f$parent,
    #txn: _f$txn,
  };

  @override
  Function get typeFactory =>
      <A, B, C>(f) => f<_t$_R0<A, B, C>>();

  static _t$_R0<A, B, C> _instantiate<A, B, C>(DecodingData<_t$_R0> data) {
    return (
      groups: data.dec(_f$groups),
      parent: data.dec(_f$parent),
      txn: data.dec(_f$txn),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static _t$_R0<A, B, C> fromMap<A, B, C>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<_t$_R0<A, B, C>>(map);
  }

  static _t$_R0<A, B, C> fromJson<A, B, C>(String json) {
    return ensureInitialized().decodeJson<_t$_R0<A, B, C>>(json);
  }
}

