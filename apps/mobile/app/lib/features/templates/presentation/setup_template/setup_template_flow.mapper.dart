// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'setup_template_flow.dart';

class SetupTemplateFlowStateMapper
    extends ClassMapperBase<SetupTemplateFlowState> {
  SetupTemplateFlowStateMapper._();

  static SetupTemplateFlowStateMapper? _instance;
  static SetupTemplateFlowStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetupTemplateFlowStateMapper._());
      FlowStateMapper.ensureInitialized();
      TransactionTemplateDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetupTemplateFlowState';

  static String _$route(SetupTemplateFlowState v) => v.route;
  static const Field<SetupTemplateFlowState, String> _f$route = Field(
    'route',
    _$route,
  );
  static Async<TransactionTemplateDraft> _$template(SetupTemplateFlowState v) =>
      v.template;
  static const Field<SetupTemplateFlowState, Async<TransactionTemplateDraft>>
  _f$template = Field('template', _$template);
  static bool _$canSave(SetupTemplateFlowState v) => v.canSave;
  static const Field<SetupTemplateFlowState, bool> _f$canSave = Field(
    'canSave',
    _$canSave,
    key: r'can_save',
  );
  static bool _$canEnableFireImmediately(SetupTemplateFlowState v) =>
      v.canEnableFireImmediately;
  static const Field<SetupTemplateFlowState, bool> _f$canEnableFireImmediately =
      Field(
        'canEnableFireImmediately',
        _$canEnableFireImmediately,
        key: r'can_enable_fire_immediately',
      );

  @override
  final MappableFields<SetupTemplateFlowState> fields = const {
    #route: _f$route,
    #template: _f$template,
    #canSave: _f$canSave,
    #canEnableFireImmediately: _f$canEnableFireImmediately,
  };

  static SetupTemplateFlowState _instantiate(DecodingData data) {
    return SetupTemplateFlowState(
      route: data.dec(_f$route),
      template: data.dec(_f$template),
      canSave: data.dec(_f$canSave),
      canEnableFireImmediately: data.dec(_f$canEnableFireImmediately),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SetupTemplateFlowState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetupTemplateFlowState>(map);
  }

  static SetupTemplateFlowState fromJson(String json) {
    return ensureInitialized().decodeJson<SetupTemplateFlowState>(json);
  }
}

mixin SetupTemplateFlowStateMappable {
  String toJson() {
    return SetupTemplateFlowStateMapper.ensureInitialized()
        .encodeJson<SetupTemplateFlowState>(this as SetupTemplateFlowState);
  }

  Map<String, dynamic> toMap() {
    return SetupTemplateFlowStateMapper.ensureInitialized()
        .encodeMap<SetupTemplateFlowState>(this as SetupTemplateFlowState);
  }

  SetupTemplateFlowStateCopyWith<
    SetupTemplateFlowState,
    SetupTemplateFlowState,
    SetupTemplateFlowState
  >
  get copyWith =>
      _SetupTemplateFlowStateCopyWithImpl<
        SetupTemplateFlowState,
        SetupTemplateFlowState
      >(this as SetupTemplateFlowState, $identity, $identity);
  @override
  String toString() {
    return SetupTemplateFlowStateMapper.ensureInitialized().stringifyValue(
      this as SetupTemplateFlowState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SetupTemplateFlowStateMapper.ensureInitialized().equalsValue(
      this as SetupTemplateFlowState,
      other,
    );
  }

  @override
  int get hashCode {
    return SetupTemplateFlowStateMapper.ensureInitialized().hashValue(
      this as SetupTemplateFlowState,
    );
  }
}

extension SetupTemplateFlowStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetupTemplateFlowState, $Out> {
  SetupTemplateFlowStateCopyWith<$R, SetupTemplateFlowState, $Out>
  get $asSetupTemplateFlowState => $base.as(
    (v, t, t2) => _SetupTemplateFlowStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SetupTemplateFlowStateCopyWith<
  $R,
  $In extends SetupTemplateFlowState,
  $Out
>
    implements FlowStateCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? route,
    Async<TransactionTemplateDraft>? template,
    bool? canSave,
    bool? canEnableFireImmediately,
  });
  SetupTemplateFlowStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SetupTemplateFlowStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetupTemplateFlowState, $Out>
    implements
        SetupTemplateFlowStateCopyWith<$R, SetupTemplateFlowState, $Out> {
  _SetupTemplateFlowStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetupTemplateFlowState> $mapper =
      SetupTemplateFlowStateMapper.ensureInitialized();
  @override
  $R call({
    String? route,
    Async<TransactionTemplateDraft>? template,
    bool? canSave,
    bool? canEnableFireImmediately,
  }) => $apply(
    FieldCopyWithData({
      if (route != null) #route: route,
      if (template != null) #template: template,
      if (canSave != null) #canSave: canSave,
      if (canEnableFireImmediately != null)
        #canEnableFireImmediately: canEnableFireImmediately,
    }),
  );
  @override
  SetupTemplateFlowState $make(CopyWithData data) => SetupTemplateFlowState(
    route: data.get(#route, or: $value.route),
    template: data.get(#template, or: $value.template),
    canSave: data.get(#canSave, or: $value.canSave),
    canEnableFireImmediately: data.get(
      #canEnableFireImmediately,
      or: $value.canEnableFireImmediately,
    ),
  );

  @override
  SetupTemplateFlowStateCopyWith<$R2, SetupTemplateFlowState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SetupTemplateFlowStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

