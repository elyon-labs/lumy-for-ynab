// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'create_frugal_month_flow.dart';

class CreateFrugalMonthStateMapper
    extends ClassMapperBase<CreateFrugalMonthState> {
  CreateFrugalMonthStateMapper._();

  static CreateFrugalMonthStateMapper? _instance;
  static CreateFrugalMonthStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateFrugalMonthStateMapper._());
      FlowStateMapper.ensureInitialized();
      FrugalMonthDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CreateFrugalMonthState';

  static FrugalMonthDraft _$draft(CreateFrugalMonthState v) => v.draft;
  static const Field<CreateFrugalMonthState, FrugalMonthDraft> _f$draft = Field(
    'draft',
    _$draft,
  );
  static String _$route(CreateFrugalMonthState v) => v.route;
  static const Field<CreateFrugalMonthState, String> _f$route = Field(
    'route',
    _$route,
  );
  static Async<List<LocalDate>> _$availableMonths(CreateFrugalMonthState v) =>
      v.availableMonths;
  static const Field<CreateFrugalMonthState, Async<List<LocalDate>>>
  _f$availableMonths = Field(
    'availableMonths',
    _$availableMonths,
    key: r'available_months',
  );
  static Async<String> _$frugalMonthId(CreateFrugalMonthState v) =>
      v.frugalMonthId;
  static const Field<CreateFrugalMonthState, Async<String>> _f$frugalMonthId =
      Field('frugalMonthId', _$frugalMonthId, key: r'frugal_month_id');
  static bool _$isFrugalMonthNotificationsEnabled(CreateFrugalMonthState v) =>
      v.isFrugalMonthNotificationsEnabled;
  static const Field<CreateFrugalMonthState, bool>
  _f$isFrugalMonthNotificationsEnabled = Field(
    'isFrugalMonthNotificationsEnabled',
    _$isFrugalMonthNotificationsEnabled,
    key: r'is_frugal_month_notifications_enabled',
  );

  @override
  final MappableFields<CreateFrugalMonthState> fields = const {
    #draft: _f$draft,
    #route: _f$route,
    #availableMonths: _f$availableMonths,
    #frugalMonthId: _f$frugalMonthId,
    #isFrugalMonthNotificationsEnabled: _f$isFrugalMonthNotificationsEnabled,
  };

  static CreateFrugalMonthState _instantiate(DecodingData data) {
    return CreateFrugalMonthState(
      draft: data.dec(_f$draft),
      route: data.dec(_f$route),
      availableMonths: data.dec(_f$availableMonths),
      frugalMonthId: data.dec(_f$frugalMonthId),
      isFrugalMonthNotificationsEnabled: data.dec(
        _f$isFrugalMonthNotificationsEnabled,
      ),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CreateFrugalMonthState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateFrugalMonthState>(map);
  }

  static CreateFrugalMonthState fromJson(String json) {
    return ensureInitialized().decodeJson<CreateFrugalMonthState>(json);
  }
}

mixin CreateFrugalMonthStateMappable {
  String toJson() {
    return CreateFrugalMonthStateMapper.ensureInitialized()
        .encodeJson<CreateFrugalMonthState>(this as CreateFrugalMonthState);
  }

  Map<String, dynamic> toMap() {
    return CreateFrugalMonthStateMapper.ensureInitialized()
        .encodeMap<CreateFrugalMonthState>(this as CreateFrugalMonthState);
  }

  CreateFrugalMonthStateCopyWith<
    CreateFrugalMonthState,
    CreateFrugalMonthState,
    CreateFrugalMonthState
  >
  get copyWith =>
      _CreateFrugalMonthStateCopyWithImpl<
        CreateFrugalMonthState,
        CreateFrugalMonthState
      >(this as CreateFrugalMonthState, $identity, $identity);
  @override
  String toString() {
    return CreateFrugalMonthStateMapper.ensureInitialized().stringifyValue(
      this as CreateFrugalMonthState,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateFrugalMonthStateMapper.ensureInitialized().equalsValue(
      this as CreateFrugalMonthState,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateFrugalMonthStateMapper.ensureInitialized().hashValue(
      this as CreateFrugalMonthState,
    );
  }
}

extension CreateFrugalMonthStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateFrugalMonthState, $Out> {
  CreateFrugalMonthStateCopyWith<$R, CreateFrugalMonthState, $Out>
  get $asCreateFrugalMonthState => $base.as(
    (v, t, t2) => _CreateFrugalMonthStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CreateFrugalMonthStateCopyWith<
  $R,
  $In extends CreateFrugalMonthState,
  $Out
>
    implements FlowStateCopyWith<$R, $In, $Out> {
  FrugalMonthDraftCopyWith<$R, FrugalMonthDraft, FrugalMonthDraft> get draft;
  @override
  $R call({
    FrugalMonthDraft? draft,
    String? route,
    Async<List<LocalDate>>? availableMonths,
    Async<String>? frugalMonthId,
    bool? isFrugalMonthNotificationsEnabled,
  });
  CreateFrugalMonthStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateFrugalMonthStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateFrugalMonthState, $Out>
    implements
        CreateFrugalMonthStateCopyWith<$R, CreateFrugalMonthState, $Out> {
  _CreateFrugalMonthStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateFrugalMonthState> $mapper =
      CreateFrugalMonthStateMapper.ensureInitialized();
  @override
  FrugalMonthDraftCopyWith<$R, FrugalMonthDraft, FrugalMonthDraft> get draft =>
      $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  $R call({
    FrugalMonthDraft? draft,
    String? route,
    Async<List<LocalDate>>? availableMonths,
    Async<String>? frugalMonthId,
    bool? isFrugalMonthNotificationsEnabled,
  }) => $apply(
    FieldCopyWithData({
      if (draft != null) #draft: draft,
      if (route != null) #route: route,
      if (availableMonths != null) #availableMonths: availableMonths,
      if (frugalMonthId != null) #frugalMonthId: frugalMonthId,
      if (isFrugalMonthNotificationsEnabled != null)
        #isFrugalMonthNotificationsEnabled: isFrugalMonthNotificationsEnabled,
    }),
  );
  @override
  CreateFrugalMonthState $make(CopyWithData data) => CreateFrugalMonthState(
    draft: data.get(#draft, or: $value.draft),
    route: data.get(#route, or: $value.route),
    availableMonths: data.get(#availableMonths, or: $value.availableMonths),
    frugalMonthId: data.get(#frugalMonthId, or: $value.frugalMonthId),
    isFrugalMonthNotificationsEnabled: data.get(
      #isFrugalMonthNotificationsEnabled,
      or: $value.isFrugalMonthNotificationsEnabled,
    ),
  );

  @override
  CreateFrugalMonthStateCopyWith<$R2, CreateFrugalMonthState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CreateFrugalMonthStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

