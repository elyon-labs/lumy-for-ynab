// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insert_transaction_template.dart';

class InsertTransactionTemplateMapper
    extends ClassMapperBase<InsertTransactionTemplate> {
  InsertTransactionTemplateMapper._();

  static InsertTransactionTemplateMapper? _instance;
  static InsertTransactionTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsertTransactionTemplateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'InsertTransactionTemplate';

  static String _$budgetId(InsertTransactionTemplate v) => v.budgetId;
  static const Field<InsertTransactionTemplate, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static String _$userId(InsertTransactionTemplate v) => v.userId;
  static const Field<InsertTransactionTemplate, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$name(InsertTransactionTemplate v) => v.name;
  static const Field<InsertTransactionTemplate, String> _f$name = Field(
    'name',
    _$name,
  );
  static int _$amount(InsertTransactionTemplate v) => v.amount;
  static const Field<InsertTransactionTemplate, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static bool _$isInflow(InsertTransactionTemplate v) => v.isInflow;
  static const Field<InsertTransactionTemplate, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
  );
  static String? _$accountId(InsertTransactionTemplate v) => v.accountId;
  static const Field<InsertTransactionTemplate, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
  );
  static String? _$payeeId(InsertTransactionTemplate v) => v.payeeId;
  static const Field<InsertTransactionTemplate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
  );
  static String? _$categoryId(InsertTransactionTemplate v) => v.categoryId;
  static const Field<InsertTransactionTemplate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
  );
  static String? _$memo(InsertTransactionTemplate v) => v.memo;
  static const Field<InsertTransactionTemplate, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static String? _$flag(InsertTransactionTemplate v) => v.flag;
  static const Field<InsertTransactionTemplate, String> _f$flag = Field(
    'flag',
    _$flag,
  );
  static bool _$fireImmediately(InsertTransactionTemplate v) =>
      v.fireImmediately;
  static const Field<InsertTransactionTemplate, bool> _f$fireImmediately =
      Field('fireImmediately', _$fireImmediately, key: r'fire_immediately');

  @override
  final MappableFields<InsertTransactionTemplate> fields = const {
    #budgetId: _f$budgetId,
    #userId: _f$userId,
    #name: _f$name,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #accountId: _f$accountId,
    #payeeId: _f$payeeId,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #flag: _f$flag,
    #fireImmediately: _f$fireImmediately,
  };

  static InsertTransactionTemplate _instantiate(DecodingData data) {
    return InsertTransactionTemplate(
      budgetId: data.dec(_f$budgetId),
      userId: data.dec(_f$userId),
      name: data.dec(_f$name),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      accountId: data.dec(_f$accountId),
      payeeId: data.dec(_f$payeeId),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      flag: data.dec(_f$flag),
      fireImmediately: data.dec(_f$fireImmediately),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertTransactionTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsertTransactionTemplate>(map);
  }

  static InsertTransactionTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<InsertTransactionTemplate>(json);
  }
}

mixin InsertTransactionTemplateMappable {
  String toJson() {
    return InsertTransactionTemplateMapper.ensureInitialized()
        .encodeJson<InsertTransactionTemplate>(
          this as InsertTransactionTemplate,
        );
  }

  Map<String, dynamic> toMap() {
    return InsertTransactionTemplateMapper.ensureInitialized()
        .encodeMap<InsertTransactionTemplate>(
          this as InsertTransactionTemplate,
        );
  }

  InsertTransactionTemplateCopyWith<
    InsertTransactionTemplate,
    InsertTransactionTemplate,
    InsertTransactionTemplate
  >
  get copyWith =>
      _InsertTransactionTemplateCopyWithImpl<
        InsertTransactionTemplate,
        InsertTransactionTemplate
      >(this as InsertTransactionTemplate, $identity, $identity);
  @override
  String toString() {
    return InsertTransactionTemplateMapper.ensureInitialized().stringifyValue(
      this as InsertTransactionTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsertTransactionTemplateMapper.ensureInitialized().equalsValue(
      this as InsertTransactionTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return InsertTransactionTemplateMapper.ensureInitialized().hashValue(
      this as InsertTransactionTemplate,
    );
  }
}

extension InsertTransactionTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertTransactionTemplate, $Out> {
  InsertTransactionTemplateCopyWith<$R, InsertTransactionTemplate, $Out>
  get $asInsertTransactionTemplate => $base.as(
    (v, t, t2) => _InsertTransactionTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsertTransactionTemplateCopyWith<
  $R,
  $In extends InsertTransactionTemplate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? budgetId,
    String? userId,
    String? name,
    int? amount,
    bool? isInflow,
    String? accountId,
    String? payeeId,
    String? categoryId,
    String? memo,
    String? flag,
    bool? fireImmediately,
  });
  InsertTransactionTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsertTransactionTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertTransactionTemplate, $Out>
    implements
        InsertTransactionTemplateCopyWith<$R, InsertTransactionTemplate, $Out> {
  _InsertTransactionTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsertTransactionTemplate> $mapper =
      InsertTransactionTemplateMapper.ensureInitialized();
  @override
  $R call({
    String? budgetId,
    String? userId,
    String? name,
    int? amount,
    bool? isInflow,
    Object? accountId = $none,
    Object? payeeId = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? flag = $none,
    bool? fireImmediately,
  }) => $apply(
    FieldCopyWithData({
      if (budgetId != null) #budgetId: budgetId,
      if (userId != null) #userId: userId,
      if (name != null) #name: name,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (accountId != $none) #accountId: accountId,
      if (payeeId != $none) #payeeId: payeeId,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (flag != $none) #flag: flag,
      if (fireImmediately != null) #fireImmediately: fireImmediately,
    }),
  );
  @override
  InsertTransactionTemplate $make(CopyWithData data) =>
      InsertTransactionTemplate(
        budgetId: data.get(#budgetId, or: $value.budgetId),
        userId: data.get(#userId, or: $value.userId),
        name: data.get(#name, or: $value.name),
        amount: data.get(#amount, or: $value.amount),
        isInflow: data.get(#isInflow, or: $value.isInflow),
        accountId: data.get(#accountId, or: $value.accountId),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        memo: data.get(#memo, or: $value.memo),
        flag: data.get(#flag, or: $value.flag),
        fireImmediately: data.get(#fireImmediately, or: $value.fireImmediately),
      );

  @override
  InsertTransactionTemplateCopyWith<$R2, InsertTransactionTemplate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertTransactionTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UpdateTransactionTemplateMapper
    extends ClassMapperBase<UpdateTransactionTemplate> {
  UpdateTransactionTemplateMapper._();

  static UpdateTransactionTemplateMapper? _instance;
  static UpdateTransactionTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = UpdateTransactionTemplateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'UpdateTransactionTemplate';

  static String _$name(UpdateTransactionTemplate v) => v.name;
  static const Field<UpdateTransactionTemplate, String> _f$name = Field(
    'name',
    _$name,
  );
  static int _$amount(UpdateTransactionTemplate v) => v.amount;
  static const Field<UpdateTransactionTemplate, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static bool _$isInflow(UpdateTransactionTemplate v) => v.isInflow;
  static const Field<UpdateTransactionTemplate, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
  );
  static String? _$accountId(UpdateTransactionTemplate v) => v.accountId;
  static const Field<UpdateTransactionTemplate, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
  );
  static String? _$payeeId(UpdateTransactionTemplate v) => v.payeeId;
  static const Field<UpdateTransactionTemplate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
  );
  static String? _$categoryId(UpdateTransactionTemplate v) => v.categoryId;
  static const Field<UpdateTransactionTemplate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
  );
  static String? _$memo(UpdateTransactionTemplate v) => v.memo;
  static const Field<UpdateTransactionTemplate, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static String? _$flag(UpdateTransactionTemplate v) => v.flag;
  static const Field<UpdateTransactionTemplate, String> _f$flag = Field(
    'flag',
    _$flag,
  );
  static bool _$fireImmediately(UpdateTransactionTemplate v) =>
      v.fireImmediately;
  static const Field<UpdateTransactionTemplate, bool> _f$fireImmediately =
      Field('fireImmediately', _$fireImmediately, key: r'fire_immediately');

  @override
  final MappableFields<UpdateTransactionTemplate> fields = const {
    #name: _f$name,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #accountId: _f$accountId,
    #payeeId: _f$payeeId,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #flag: _f$flag,
    #fireImmediately: _f$fireImmediately,
  };

  static UpdateTransactionTemplate _instantiate(DecodingData data) {
    return UpdateTransactionTemplate(
      name: data.dec(_f$name),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      accountId: data.dec(_f$accountId),
      payeeId: data.dec(_f$payeeId),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      flag: data.dec(_f$flag),
      fireImmediately: data.dec(_f$fireImmediately),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpdateTransactionTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpdateTransactionTemplate>(map);
  }

  static UpdateTransactionTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<UpdateTransactionTemplate>(json);
  }
}

mixin UpdateTransactionTemplateMappable {
  String toJson() {
    return UpdateTransactionTemplateMapper.ensureInitialized()
        .encodeJson<UpdateTransactionTemplate>(
          this as UpdateTransactionTemplate,
        );
  }

  Map<String, dynamic> toMap() {
    return UpdateTransactionTemplateMapper.ensureInitialized()
        .encodeMap<UpdateTransactionTemplate>(
          this as UpdateTransactionTemplate,
        );
  }

  UpdateTransactionTemplateCopyWith<
    UpdateTransactionTemplate,
    UpdateTransactionTemplate,
    UpdateTransactionTemplate
  >
  get copyWith =>
      _UpdateTransactionTemplateCopyWithImpl<
        UpdateTransactionTemplate,
        UpdateTransactionTemplate
      >(this as UpdateTransactionTemplate, $identity, $identity);
  @override
  String toString() {
    return UpdateTransactionTemplateMapper.ensureInitialized().stringifyValue(
      this as UpdateTransactionTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpdateTransactionTemplateMapper.ensureInitialized().equalsValue(
      this as UpdateTransactionTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return UpdateTransactionTemplateMapper.ensureInitialized().hashValue(
      this as UpdateTransactionTemplate,
    );
  }
}

extension UpdateTransactionTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpdateTransactionTemplate, $Out> {
  UpdateTransactionTemplateCopyWith<$R, UpdateTransactionTemplate, $Out>
  get $asUpdateTransactionTemplate => $base.as(
    (v, t, t2) => _UpdateTransactionTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UpdateTransactionTemplateCopyWith<
  $R,
  $In extends UpdateTransactionTemplate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    int? amount,
    bool? isInflow,
    String? accountId,
    String? payeeId,
    String? categoryId,
    String? memo,
    String? flag,
    bool? fireImmediately,
  });
  UpdateTransactionTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UpdateTransactionTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpdateTransactionTemplate, $Out>
    implements
        UpdateTransactionTemplateCopyWith<$R, UpdateTransactionTemplate, $Out> {
  _UpdateTransactionTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpdateTransactionTemplate> $mapper =
      UpdateTransactionTemplateMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    int? amount,
    bool? isInflow,
    Object? accountId = $none,
    Object? payeeId = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? flag = $none,
    bool? fireImmediately,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (accountId != $none) #accountId: accountId,
      if (payeeId != $none) #payeeId: payeeId,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (flag != $none) #flag: flag,
      if (fireImmediately != null) #fireImmediately: fireImmediately,
    }),
  );
  @override
  UpdateTransactionTemplate $make(CopyWithData data) =>
      UpdateTransactionTemplate(
        name: data.get(#name, or: $value.name),
        amount: data.get(#amount, or: $value.amount),
        isInflow: data.get(#isInflow, or: $value.isInflow),
        accountId: data.get(#accountId, or: $value.accountId),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        memo: data.get(#memo, or: $value.memo),
        flag: data.get(#flag, or: $value.flag),
        fireImmediately: data.get(#fireImmediately, or: $value.fireImmediately),
      );

  @override
  UpdateTransactionTemplateCopyWith<$R2, UpdateTransactionTemplate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UpdateTransactionTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InsertTransactionTemplateSubTransactionMapper
    extends ClassMapperBase<InsertTransactionTemplateSubTransaction> {
  InsertTransactionTemplateSubTransactionMapper._();

  static InsertTransactionTemplateSubTransactionMapper? _instance;
  static InsertTransactionTemplateSubTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsertTransactionTemplateSubTransactionMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'InsertTransactionTemplateSubTransaction';

  static String _$templateId(InsertTransactionTemplateSubTransaction v) =>
      v.templateId;
  static const Field<InsertTransactionTemplateSubTransaction, String>
  _f$templateId = Field('templateId', _$templateId, key: r'template_id');
  static String? _$categoryId(InsertTransactionTemplateSubTransaction v) =>
      v.categoryId;
  static const Field<InsertTransactionTemplateSubTransaction, String>
  _f$categoryId = Field('categoryId', _$categoryId, key: r'category_id');
  static int _$amount(InsertTransactionTemplateSubTransaction v) => v.amount;
  static const Field<InsertTransactionTemplateSubTransaction, int> _f$amount =
      Field('amount', _$amount);
  static bool _$isInflow(InsertTransactionTemplateSubTransaction v) =>
      v.isInflow;
  static const Field<InsertTransactionTemplateSubTransaction, bool>
  _f$isInflow = Field('isInflow', _$isInflow, key: r'is_inflow');
  static String? _$payeeId(InsertTransactionTemplateSubTransaction v) =>
      v.payeeId;
  static const Field<InsertTransactionTemplateSubTransaction, String>
  _f$payeeId = Field('payeeId', _$payeeId, key: r'payee_id');
  static String? _$memo(InsertTransactionTemplateSubTransaction v) => v.memo;
  static const Field<InsertTransactionTemplateSubTransaction, String> _f$memo =
      Field('memo', _$memo);

  @override
  final MappableFields<InsertTransactionTemplateSubTransaction> fields = const {
    #templateId: _f$templateId,
    #categoryId: _f$categoryId,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #payeeId: _f$payeeId,
    #memo: _f$memo,
  };

  static InsertTransactionTemplateSubTransaction _instantiate(
    DecodingData data,
  ) {
    return InsertTransactionTemplateSubTransaction(
      templateId: data.dec(_f$templateId),
      categoryId: data.dec(_f$categoryId),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      payeeId: data.dec(_f$payeeId),
      memo: data.dec(_f$memo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertTransactionTemplateSubTransaction fromMap(
    Map<String, dynamic> map,
  ) {
    return ensureInitialized()
        .decodeMap<InsertTransactionTemplateSubTransaction>(map);
  }

  static InsertTransactionTemplateSubTransaction fromJson(String json) {
    return ensureInitialized()
        .decodeJson<InsertTransactionTemplateSubTransaction>(json);
  }
}

mixin InsertTransactionTemplateSubTransactionMappable {
  String toJson() {
    return InsertTransactionTemplateSubTransactionMapper.ensureInitialized()
        .encodeJson<InsertTransactionTemplateSubTransaction>(
          this as InsertTransactionTemplateSubTransaction,
        );
  }

  Map<String, dynamic> toMap() {
    return InsertTransactionTemplateSubTransactionMapper.ensureInitialized()
        .encodeMap<InsertTransactionTemplateSubTransaction>(
          this as InsertTransactionTemplateSubTransaction,
        );
  }

  InsertTransactionTemplateSubTransactionCopyWith<
    InsertTransactionTemplateSubTransaction,
    InsertTransactionTemplateSubTransaction,
    InsertTransactionTemplateSubTransaction
  >
  get copyWith =>
      _InsertTransactionTemplateSubTransactionCopyWithImpl<
        InsertTransactionTemplateSubTransaction,
        InsertTransactionTemplateSubTransaction
      >(this as InsertTransactionTemplateSubTransaction, $identity, $identity);
  @override
  String toString() {
    return InsertTransactionTemplateSubTransactionMapper.ensureInitialized()
        .stringifyValue(this as InsertTransactionTemplateSubTransaction);
  }

  @override
  bool operator ==(Object other) {
    return InsertTransactionTemplateSubTransactionMapper.ensureInitialized()
        .equalsValue(this as InsertTransactionTemplateSubTransaction, other);
  }

  @override
  int get hashCode {
    return InsertTransactionTemplateSubTransactionMapper.ensureInitialized()
        .hashValue(this as InsertTransactionTemplateSubTransaction);
  }
}

extension InsertTransactionTemplateSubTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertTransactionTemplateSubTransaction, $Out> {
  InsertTransactionTemplateSubTransactionCopyWith<
    $R,
    InsertTransactionTemplateSubTransaction,
    $Out
  >
  get $asInsertTransactionTemplateSubTransaction => $base.as(
    (v, t, t2) =>
        _InsertTransactionTemplateSubTransactionCopyWithImpl<$R, $Out>(
          v,
          t,
          t2,
        ),
  );
}

abstract class InsertTransactionTemplateSubTransactionCopyWith<
  $R,
  $In extends InsertTransactionTemplateSubTransaction,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? templateId,
    String? categoryId,
    int? amount,
    bool? isInflow,
    String? payeeId,
    String? memo,
  });
  InsertTransactionTemplateSubTransactionCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InsertTransactionTemplateSubTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertTransactionTemplateSubTransaction, $Out>
    implements
        InsertTransactionTemplateSubTransactionCopyWith<
          $R,
          InsertTransactionTemplateSubTransaction,
          $Out
        > {
  _InsertTransactionTemplateSubTransactionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<InsertTransactionTemplateSubTransaction> $mapper =
      InsertTransactionTemplateSubTransactionMapper.ensureInitialized();
  @override
  $R call({
    String? templateId,
    Object? categoryId = $none,
    int? amount,
    bool? isInflow,
    Object? payeeId = $none,
    Object? memo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (templateId != null) #templateId: templateId,
      if (categoryId != $none) #categoryId: categoryId,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (payeeId != $none) #payeeId: payeeId,
      if (memo != $none) #memo: memo,
    }),
  );
  @override
  InsertTransactionTemplateSubTransaction $make(CopyWithData data) =>
      InsertTransactionTemplateSubTransaction(
        templateId: data.get(#templateId, or: $value.templateId),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        amount: data.get(#amount, or: $value.amount),
        isInflow: data.get(#isInflow, or: $value.isInflow),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        memo: data.get(#memo, or: $value.memo),
      );

  @override
  InsertTransactionTemplateSubTransactionCopyWith<
    $R2,
    InsertTransactionTemplateSubTransaction,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertTransactionTemplateSubTransactionCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

