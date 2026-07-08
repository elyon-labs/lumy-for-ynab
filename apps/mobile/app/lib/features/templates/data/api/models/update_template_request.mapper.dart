// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'update_template_request.dart';

class UpdateTemplateRequestMapper
    extends ClassMapperBase<UpdateTemplateRequest> {
  UpdateTemplateRequestMapper._();

  static UpdateTemplateRequestMapper? _instance;
  static UpdateTemplateRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpdateTemplateRequestMapper._());
      TransactionTemplateDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UpdateTemplateRequest';

  static String _$id(UpdateTemplateRequest v) => v.id;
  static const Field<UpdateTemplateRequest, String> _f$id = Field('id', _$id);
  static TransactionTemplateDraft _$draft(UpdateTemplateRequest v) => v.draft;
  static const Field<UpdateTemplateRequest, TransactionTemplateDraft> _f$draft =
      Field('draft', _$draft);

  @override
  final MappableFields<UpdateTemplateRequest> fields = const {
    #id: _f$id,
    #draft: _f$draft,
  };

  static UpdateTemplateRequest _instantiate(DecodingData data) {
    return UpdateTemplateRequest(
      id: data.dec(_f$id),
      draft: data.dec(_f$draft),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpdateTemplateRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpdateTemplateRequest>(map);
  }

  static UpdateTemplateRequest fromJson(String json) {
    return ensureInitialized().decodeJson<UpdateTemplateRequest>(json);
  }
}

mixin UpdateTemplateRequestMappable {
  String toJson() {
    return UpdateTemplateRequestMapper.ensureInitialized()
        .encodeJson<UpdateTemplateRequest>(this as UpdateTemplateRequest);
  }

  Map<String, dynamic> toMap() {
    return UpdateTemplateRequestMapper.ensureInitialized()
        .encodeMap<UpdateTemplateRequest>(this as UpdateTemplateRequest);
  }

  UpdateTemplateRequestCopyWith<
    UpdateTemplateRequest,
    UpdateTemplateRequest,
    UpdateTemplateRequest
  >
  get copyWith =>
      _UpdateTemplateRequestCopyWithImpl<
        UpdateTemplateRequest,
        UpdateTemplateRequest
      >(this as UpdateTemplateRequest, $identity, $identity);
  @override
  String toString() {
    return UpdateTemplateRequestMapper.ensureInitialized().stringifyValue(
      this as UpdateTemplateRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpdateTemplateRequestMapper.ensureInitialized().equalsValue(
      this as UpdateTemplateRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return UpdateTemplateRequestMapper.ensureInitialized().hashValue(
      this as UpdateTemplateRequest,
    );
  }
}

extension UpdateTemplateRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpdateTemplateRequest, $Out> {
  UpdateTemplateRequestCopyWith<$R, UpdateTemplateRequest, $Out>
  get $asUpdateTemplateRequest => $base.as(
    (v, t, t2) => _UpdateTemplateRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UpdateTemplateRequestCopyWith<
  $R,
  $In extends UpdateTemplateRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  TransactionTemplateDraftCopyWith<
    $R,
    TransactionTemplateDraft,
    TransactionTemplateDraft
  >
  get draft;
  $R call({String? id, TransactionTemplateDraft? draft});
  UpdateTemplateRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UpdateTemplateRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpdateTemplateRequest, $Out>
    implements UpdateTemplateRequestCopyWith<$R, UpdateTemplateRequest, $Out> {
  _UpdateTemplateRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpdateTemplateRequest> $mapper =
      UpdateTemplateRequestMapper.ensureInitialized();
  @override
  TransactionTemplateDraftCopyWith<
    $R,
    TransactionTemplateDraft,
    TransactionTemplateDraft
  >
  get draft => $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  $R call({String? id, TransactionTemplateDraft? draft}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (draft != null) #draft: draft,
    }),
  );
  @override
  UpdateTemplateRequest $make(CopyWithData data) => UpdateTemplateRequest(
    id: data.get(#id, or: $value.id),
    draft: data.get(#draft, or: $value.draft),
  );

  @override
  UpdateTemplateRequestCopyWith<$R2, UpdateTemplateRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UpdateTemplateRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

