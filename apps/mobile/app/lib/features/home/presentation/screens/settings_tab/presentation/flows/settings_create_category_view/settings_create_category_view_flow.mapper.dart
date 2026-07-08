// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_create_category_view_flow.dart';

class SettingsCreateCategoryViewStateMapper
    extends ClassMapperBase<SettingsCreateCategoryViewState> {
  SettingsCreateCategoryViewStateMapper._();

  static SettingsCreateCategoryViewStateMapper? _instance;
  static SettingsCreateCategoryViewStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsCreateCategoryViewStateMapper._(),
      );
      FlowStateMapper.ensureInitialized();
      CategoryViewDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsCreateCategoryViewState';

  static String _$route(SettingsCreateCategoryViewState v) => v.route;
  static const Field<SettingsCreateCategoryViewState, String> _f$route = Field(
    'route',
    _$route,
  );
  static CategoryViewDraft _$draft(SettingsCreateCategoryViewState v) =>
      v.draft;
  static const Field<SettingsCreateCategoryViewState, CategoryViewDraft>
  _f$draft = Field('draft', _$draft);

  @override
  final MappableFields<SettingsCreateCategoryViewState> fields = const {
    #route: _f$route,
    #draft: _f$draft,
  };

  static SettingsCreateCategoryViewState _instantiate(DecodingData data) {
    return SettingsCreateCategoryViewState(
      route: data.dec(_f$route),
      draft: data.dec(_f$draft),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsCreateCategoryViewState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsCreateCategoryViewState>(map);
  }

  static SettingsCreateCategoryViewState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsCreateCategoryViewState>(
      json,
    );
  }
}

mixin SettingsCreateCategoryViewStateMappable {
  String toJson() {
    return SettingsCreateCategoryViewStateMapper.ensureInitialized()
        .encodeJson<SettingsCreateCategoryViewState>(
          this as SettingsCreateCategoryViewState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsCreateCategoryViewStateMapper.ensureInitialized()
        .encodeMap<SettingsCreateCategoryViewState>(
          this as SettingsCreateCategoryViewState,
        );
  }

  SettingsCreateCategoryViewStateCopyWith<
    SettingsCreateCategoryViewState,
    SettingsCreateCategoryViewState,
    SettingsCreateCategoryViewState
  >
  get copyWith =>
      _SettingsCreateCategoryViewStateCopyWithImpl<
        SettingsCreateCategoryViewState,
        SettingsCreateCategoryViewState
      >(this as SettingsCreateCategoryViewState, $identity, $identity);
  @override
  String toString() {
    return SettingsCreateCategoryViewStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsCreateCategoryViewState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsCreateCategoryViewStateMapper.ensureInitialized()
        .equalsValue(this as SettingsCreateCategoryViewState, other);
  }

  @override
  int get hashCode {
    return SettingsCreateCategoryViewStateMapper.ensureInitialized().hashValue(
      this as SettingsCreateCategoryViewState,
    );
  }
}

extension SettingsCreateCategoryViewStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsCreateCategoryViewState, $Out> {
  SettingsCreateCategoryViewStateCopyWith<
    $R,
    SettingsCreateCategoryViewState,
    $Out
  >
  get $asSettingsCreateCategoryViewState => $base.as(
    (v, t, t2) =>
        _SettingsCreateCategoryViewStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsCreateCategoryViewStateCopyWith<
  $R,
  $In extends SettingsCreateCategoryViewState,
  $Out
>
    implements FlowStateCopyWith<$R, $In, $Out> {
  CategoryViewDraftCopyWith<$R, CategoryViewDraft, CategoryViewDraft> get draft;
  @override
  $R call({String? route, CategoryViewDraft? draft});
  SettingsCreateCategoryViewStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsCreateCategoryViewStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsCreateCategoryViewState, $Out>
    implements
        SettingsCreateCategoryViewStateCopyWith<
          $R,
          SettingsCreateCategoryViewState,
          $Out
        > {
  _SettingsCreateCategoryViewStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsCreateCategoryViewState> $mapper =
      SettingsCreateCategoryViewStateMapper.ensureInitialized();
  @override
  CategoryViewDraftCopyWith<$R, CategoryViewDraft, CategoryViewDraft>
  get draft => $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  $R call({String? route, CategoryViewDraft? draft}) => $apply(
    FieldCopyWithData({
      if (route != null) #route: route,
      if (draft != null) #draft: draft,
    }),
  );
  @override
  SettingsCreateCategoryViewState $make(CopyWithData data) =>
      SettingsCreateCategoryViewState(
        route: data.get(#route, or: $value.route),
        draft: data.get(#draft, or: $value.draft),
      );

  @override
  SettingsCreateCategoryViewStateCopyWith<
    $R2,
    SettingsCreateCategoryViewState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsCreateCategoryViewStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

