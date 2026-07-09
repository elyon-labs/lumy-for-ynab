// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'home_screen_state.dart';

class HomeScreenStateMapper extends ClassMapperBase<HomeScreenState> {
  HomeScreenStateMapper._();

  static HomeScreenStateMapper? _instance;
  static HomeScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HomeScreenStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'HomeScreenState';

  static Async<Option<String>> _$budgetId(HomeScreenState v) => v.budgetId;
  static const Field<HomeScreenState, Async<Option<String>>> _f$budgetId =
      Field('budgetId', _$budgetId, key: r'budget_id');
  static bool _$hasUnsyncedData(HomeScreenState v) => v.hasUnsyncedData;
  static const Field<HomeScreenState, bool> _f$hasUnsyncedData = Field(
    'hasUnsyncedData',
    _$hasUnsyncedData,
    key: r'has_unsynced_data',
  );

  @override
  final MappableFields<HomeScreenState> fields = const {
    #budgetId: _f$budgetId,
    #hasUnsyncedData: _f$hasUnsyncedData,
  };

  static HomeScreenState _instantiate(DecodingData data) {
    return HomeScreenState(
      budgetId: data.dec(_f$budgetId),
      hasUnsyncedData: data.dec(_f$hasUnsyncedData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HomeScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HomeScreenState>(map);
  }

  static HomeScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<HomeScreenState>(json);
  }
}

mixin HomeScreenStateMappable {
  String toJson() {
    return HomeScreenStateMapper.ensureInitialized()
        .encodeJson<HomeScreenState>(this as HomeScreenState);
  }

  Map<String, dynamic> toMap() {
    return HomeScreenStateMapper.ensureInitialized().encodeMap<HomeScreenState>(
      this as HomeScreenState,
    );
  }

  HomeScreenStateCopyWith<HomeScreenState, HomeScreenState, HomeScreenState>
  get copyWith =>
      _HomeScreenStateCopyWithImpl<HomeScreenState, HomeScreenState>(
        this as HomeScreenState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HomeScreenStateMapper.ensureInitialized().stringifyValue(
      this as HomeScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return HomeScreenStateMapper.ensureInitialized().equalsValue(
      this as HomeScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return HomeScreenStateMapper.ensureInitialized().hashValue(
      this as HomeScreenState,
    );
  }
}

extension HomeScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HomeScreenState, $Out> {
  HomeScreenStateCopyWith<$R, HomeScreenState, $Out> get $asHomeScreenState =>
      $base.as((v, t, t2) => _HomeScreenStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HomeScreenStateCopyWith<$R, $In extends HomeScreenState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Async<Option<String>>? budgetId, bool? hasUnsyncedData});
  HomeScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _HomeScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HomeScreenState, $Out>
    implements HomeScreenStateCopyWith<$R, HomeScreenState, $Out> {
  _HomeScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HomeScreenState> $mapper =
      HomeScreenStateMapper.ensureInitialized();
  @override
  $R call({Async<Option<String>>? budgetId, bool? hasUnsyncedData}) => $apply(
    FieldCopyWithData({
      if (budgetId != null) #budgetId: budgetId,
      if (hasUnsyncedData != null) #hasUnsyncedData: hasUnsyncedData,
    }),
  );
  @override
  HomeScreenState $make(CopyWithData data) => HomeScreenState(
    budgetId: data.get(#budgetId, or: $value.budgetId),
    hasUnsyncedData: data.get(#hasUnsyncedData, or: $value.hasUnsyncedData),
  );

  @override
  HomeScreenStateCopyWith<$R2, HomeScreenState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HomeScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

