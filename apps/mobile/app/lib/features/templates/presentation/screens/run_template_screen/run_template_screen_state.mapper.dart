// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'run_template_screen_state.dart';

class RunTemplateScreenStateMapper
    extends ClassMapperBase<RunTemplateScreenState> {
  RunTemplateScreenStateMapper._();

  static RunTemplateScreenStateMapper? _instance;
  static RunTemplateScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RunTemplateScreenStateMapper._());
      TransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RunTemplateScreenState';

  static bool _$isReadyToBeCreated(RunTemplateScreenState v) =>
      v.isReadyToBeCreated;
  static const Field<RunTemplateScreenState, bool> _f$isReadyToBeCreated =
      Field(
        'isReadyToBeCreated',
        _$isReadyToBeCreated,
        key: r'is_ready_to_be_created',
      );
  static Async<TransactionTemplate> _$template(RunTemplateScreenState v) =>
      v.template;
  static const Field<RunTemplateScreenState, Async<TransactionTemplate>>
  _f$template = Field('template', _$template);
  static String _$templateId(RunTemplateScreenState v) => v.templateId;
  static const Field<RunTemplateScreenState, String> _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
  );

  @override
  final MappableFields<RunTemplateScreenState> fields = const {
    #isReadyToBeCreated: _f$isReadyToBeCreated,
    #template: _f$template,
    #templateId: _f$templateId,
  };

  static RunTemplateScreenState _instantiate(DecodingData data) {
    return RunTemplateScreenState(
      isReadyToBeCreated: data.dec(_f$isReadyToBeCreated),
      template: data.dec(_f$template),
      templateId: data.dec(_f$templateId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RunTemplateScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RunTemplateScreenState>(map);
  }

  static RunTemplateScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<RunTemplateScreenState>(json);
  }
}

mixin RunTemplateScreenStateMappable {
  String toJson() {
    return RunTemplateScreenStateMapper.ensureInitialized()
        .encodeJson<RunTemplateScreenState>(this as RunTemplateScreenState);
  }

  Map<String, dynamic> toMap() {
    return RunTemplateScreenStateMapper.ensureInitialized()
        .encodeMap<RunTemplateScreenState>(this as RunTemplateScreenState);
  }

  RunTemplateScreenStateCopyWith<
    RunTemplateScreenState,
    RunTemplateScreenState,
    RunTemplateScreenState
  >
  get copyWith =>
      _RunTemplateScreenStateCopyWithImpl<
        RunTemplateScreenState,
        RunTemplateScreenState
      >(this as RunTemplateScreenState, $identity, $identity);
  @override
  String toString() {
    return RunTemplateScreenStateMapper.ensureInitialized().stringifyValue(
      this as RunTemplateScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return RunTemplateScreenStateMapper.ensureInitialized().equalsValue(
      this as RunTemplateScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return RunTemplateScreenStateMapper.ensureInitialized().hashValue(
      this as RunTemplateScreenState,
    );
  }
}

extension RunTemplateScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RunTemplateScreenState, $Out> {
  RunTemplateScreenStateCopyWith<$R, RunTemplateScreenState, $Out>
  get $asRunTemplateScreenState => $base.as(
    (v, t, t2) => _RunTemplateScreenStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RunTemplateScreenStateCopyWith<
  $R,
  $In extends RunTemplateScreenState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? isReadyToBeCreated,
    Async<TransactionTemplate>? template,
    String? templateId,
  });
  RunTemplateScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RunTemplateScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RunTemplateScreenState, $Out>
    implements
        RunTemplateScreenStateCopyWith<$R, RunTemplateScreenState, $Out> {
  _RunTemplateScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RunTemplateScreenState> $mapper =
      RunTemplateScreenStateMapper.ensureInitialized();
  @override
  $R call({
    bool? isReadyToBeCreated,
    Async<TransactionTemplate>? template,
    String? templateId,
  }) => $apply(
    FieldCopyWithData({
      if (isReadyToBeCreated != null) #isReadyToBeCreated: isReadyToBeCreated,
      if (template != null) #template: template,
      if (templateId != null) #templateId: templateId,
    }),
  );
  @override
  RunTemplateScreenState $make(CopyWithData data) => RunTemplateScreenState(
    isReadyToBeCreated: data.get(
      #isReadyToBeCreated,
      or: $value.isReadyToBeCreated,
    ),
    template: data.get(#template, or: $value.template),
    templateId: data.get(#templateId, or: $value.templateId),
  );

  @override
  RunTemplateScreenStateCopyWith<$R2, RunTemplateScreenState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RunTemplateScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

