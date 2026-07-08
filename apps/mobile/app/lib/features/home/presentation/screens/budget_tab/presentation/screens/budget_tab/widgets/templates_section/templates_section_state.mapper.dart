// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'templates_section_state.dart';

class TemplatesSectionStateMapper
    extends ClassMapperBase<TemplatesSectionState> {
  TemplatesSectionStateMapper._();

  static TemplatesSectionStateMapper? _instance;
  static TemplatesSectionStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TemplatesSectionStateMapper._());
      TransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TemplatesSectionState';

  static List<TransactionTemplate> _$templates(TemplatesSectionState v) =>
      v.templates;
  static const Field<TemplatesSectionState, List<TransactionTemplate>>
  _f$templates = Field('templates', _$templates);
  static Map<String, Async<void>> _$templateStatus(TemplatesSectionState v) =>
      v.templateStatus;
  static const Field<TemplatesSectionState, Map<String, Async<void>>>
  _f$templateStatus = Field(
    'templateStatus',
    _$templateStatus,
    key: r'template_status',
  );

  @override
  final MappableFields<TemplatesSectionState> fields = const {
    #templates: _f$templates,
    #templateStatus: _f$templateStatus,
  };

  static TemplatesSectionState _instantiate(DecodingData data) {
    return TemplatesSectionState(
      templates: data.dec(_f$templates),
      templateStatus: data.dec(_f$templateStatus),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TemplatesSectionState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TemplatesSectionState>(map);
  }

  static TemplatesSectionState fromJson(String json) {
    return ensureInitialized().decodeJson<TemplatesSectionState>(json);
  }
}

mixin TemplatesSectionStateMappable {
  String toJson() {
    return TemplatesSectionStateMapper.ensureInitialized()
        .encodeJson<TemplatesSectionState>(this as TemplatesSectionState);
  }

  Map<String, dynamic> toMap() {
    return TemplatesSectionStateMapper.ensureInitialized()
        .encodeMap<TemplatesSectionState>(this as TemplatesSectionState);
  }

  TemplatesSectionStateCopyWith<
    TemplatesSectionState,
    TemplatesSectionState,
    TemplatesSectionState
  >
  get copyWith =>
      _TemplatesSectionStateCopyWithImpl<
        TemplatesSectionState,
        TemplatesSectionState
      >(this as TemplatesSectionState, $identity, $identity);
  @override
  String toString() {
    return TemplatesSectionStateMapper.ensureInitialized().stringifyValue(
      this as TemplatesSectionState,
    );
  }

  @override
  bool operator ==(Object other) {
    return TemplatesSectionStateMapper.ensureInitialized().equalsValue(
      this as TemplatesSectionState,
      other,
    );
  }

  @override
  int get hashCode {
    return TemplatesSectionStateMapper.ensureInitialized().hashValue(
      this as TemplatesSectionState,
    );
  }
}

extension TemplatesSectionStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TemplatesSectionState, $Out> {
  TemplatesSectionStateCopyWith<$R, TemplatesSectionState, $Out>
  get $asTemplatesSectionState => $base.as(
    (v, t, t2) => _TemplatesSectionStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TemplatesSectionStateCopyWith<
  $R,
  $In extends TemplatesSectionState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    TransactionTemplate,
    TransactionTemplateCopyWith<$R, TransactionTemplate, TransactionTemplate>
  >
  get templates;
  MapCopyWith<
    $R,
    String,
    Async<void>,
    ObjectCopyWith<$R, Async<void>, Async<void>>
  >
  get templateStatus;
  $R call({
    List<TransactionTemplate>? templates,
    Map<String, Async<void>>? templateStatus,
  });
  TemplatesSectionStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TemplatesSectionStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TemplatesSectionState, $Out>
    implements TemplatesSectionStateCopyWith<$R, TemplatesSectionState, $Out> {
  _TemplatesSectionStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TemplatesSectionState> $mapper =
      TemplatesSectionStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    TransactionTemplate,
    TransactionTemplateCopyWith<$R, TransactionTemplate, TransactionTemplate>
  >
  get templates => ListCopyWith(
    $value.templates,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(templates: v),
  );
  @override
  MapCopyWith<
    $R,
    String,
    Async<void>,
    ObjectCopyWith<$R, Async<void>, Async<void>>
  >
  get templateStatus => MapCopyWith(
    $value.templateStatus,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(templateStatus: v),
  );
  @override
  $R call({
    List<TransactionTemplate>? templates,
    Map<String, Async<void>>? templateStatus,
  }) => $apply(
    FieldCopyWithData({
      if (templates != null) #templates: templates,
      if (templateStatus != null) #templateStatus: templateStatus,
    }),
  );
  @override
  TemplatesSectionState $make(CopyWithData data) => TemplatesSectionState(
    templates: data.get(#templates, or: $value.templates),
    templateStatus: data.get(#templateStatus, or: $value.templateStatus),
  );

  @override
  TemplatesSectionStateCopyWith<$R2, TemplatesSectionState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TemplatesSectionStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

