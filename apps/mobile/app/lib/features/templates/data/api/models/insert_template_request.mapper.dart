// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insert_template_request.dart';

class InsertTemplateRequestMapper
    extends ClassMapperBase<InsertTemplateRequest> {
  InsertTemplateRequestMapper._();

  static InsertTemplateRequestMapper? _instance;
  static InsertTemplateRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsertTemplateRequestMapper._());
      TransactionTemplateDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsertTemplateRequest';

  static String _$userId(InsertTemplateRequest v) => v.userId;
  static const Field<InsertTemplateRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$budgetId(InsertTemplateRequest v) => v.budgetId;
  static const Field<InsertTemplateRequest, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static TransactionTemplateDraft _$draft(InsertTemplateRequest v) => v.draft;
  static const Field<InsertTemplateRequest, TransactionTemplateDraft> _f$draft =
      Field('draft', _$draft);

  @override
  final MappableFields<InsertTemplateRequest> fields = const {
    #userId: _f$userId,
    #budgetId: _f$budgetId,
    #draft: _f$draft,
  };

  static InsertTemplateRequest _instantiate(DecodingData data) {
    return InsertTemplateRequest(
      userId: data.dec(_f$userId),
      budgetId: data.dec(_f$budgetId),
      draft: data.dec(_f$draft),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertTemplateRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsertTemplateRequest>(map);
  }

  static InsertTemplateRequest fromJson(String json) {
    return ensureInitialized().decodeJson<InsertTemplateRequest>(json);
  }
}

mixin InsertTemplateRequestMappable {
  String toJson() {
    return InsertTemplateRequestMapper.ensureInitialized()
        .encodeJson<InsertTemplateRequest>(this as InsertTemplateRequest);
  }

  Map<String, dynamic> toMap() {
    return InsertTemplateRequestMapper.ensureInitialized()
        .encodeMap<InsertTemplateRequest>(this as InsertTemplateRequest);
  }

  InsertTemplateRequestCopyWith<
    InsertTemplateRequest,
    InsertTemplateRequest,
    InsertTemplateRequest
  >
  get copyWith =>
      _InsertTemplateRequestCopyWithImpl<
        InsertTemplateRequest,
        InsertTemplateRequest
      >(this as InsertTemplateRequest, $identity, $identity);
  @override
  String toString() {
    return InsertTemplateRequestMapper.ensureInitialized().stringifyValue(
      this as InsertTemplateRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsertTemplateRequestMapper.ensureInitialized().equalsValue(
      this as InsertTemplateRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return InsertTemplateRequestMapper.ensureInitialized().hashValue(
      this as InsertTemplateRequest,
    );
  }
}

extension InsertTemplateRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertTemplateRequest, $Out> {
  InsertTemplateRequestCopyWith<$R, InsertTemplateRequest, $Out>
  get $asInsertTemplateRequest => $base.as(
    (v, t, t2) => _InsertTemplateRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsertTemplateRequestCopyWith<
  $R,
  $In extends InsertTemplateRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  TransactionTemplateDraftCopyWith<
    $R,
    TransactionTemplateDraft,
    TransactionTemplateDraft
  >
  get draft;
  $R call({String? userId, String? budgetId, TransactionTemplateDraft? draft});
  InsertTemplateRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsertTemplateRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertTemplateRequest, $Out>
    implements InsertTemplateRequestCopyWith<$R, InsertTemplateRequest, $Out> {
  _InsertTemplateRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsertTemplateRequest> $mapper =
      InsertTemplateRequestMapper.ensureInitialized();
  @override
  TransactionTemplateDraftCopyWith<
    $R,
    TransactionTemplateDraft,
    TransactionTemplateDraft
  >
  get draft => $value.draft.copyWith.$chain((v) => call(draft: v));
  @override
  $R call({
    String? userId,
    String? budgetId,
    TransactionTemplateDraft? draft,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (budgetId != null) #budgetId: budgetId,
      if (draft != null) #draft: draft,
    }),
  );
  @override
  InsertTemplateRequest $make(CopyWithData data) => InsertTemplateRequest(
    userId: data.get(#userId, or: $value.userId),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    draft: data.get(#draft, or: $value.draft),
  );

  @override
  InsertTemplateRequestCopyWith<$R2, InsertTemplateRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertTemplateRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

