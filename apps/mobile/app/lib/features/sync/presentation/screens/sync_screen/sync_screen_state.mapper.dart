// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sync_screen_state.dart';

class SyncScreenStateMapper extends ClassMapperBase<SyncScreenState> {
  SyncScreenStateMapper._();

  static SyncScreenStateMapper? _instance;
  static SyncScreenStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyncScreenStateMapper._());
      TransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SyncScreenState';

  static bool _$hasSyncedData(SyncScreenState v) => v.hasSyncedData;
  static const Field<SyncScreenState, bool> _f$hasSyncedData = Field(
    'hasSyncedData',
    _$hasSyncedData,
    key: r'has_synced_data',
  );
  static List<LegacyCategoryView> _$categoryViews(SyncScreenState v) =>
      v.categoryViews;
  static const Field<SyncScreenState, List<LegacyCategoryView>>
  _f$categoryViews = Field(
    'categoryViews',
    _$categoryViews,
    key: r'category_views',
  );
  static List<Exception> _$categoryViewErrors(SyncScreenState v) =>
      v.categoryViewErrors;
  static const Field<SyncScreenState, List<Exception>> _f$categoryViewErrors =
      Field(
        'categoryViewErrors',
        _$categoryViewErrors,
        key: r'category_view_errors',
      );
  static SyncStatus _$categoryViewsSync(SyncScreenState v) =>
      v.categoryViewsSync;
  static const Field<SyncScreenState, SyncStatus> _f$categoryViewsSync = Field(
    'categoryViewsSync',
    _$categoryViewsSync,
    key: r'category_views_sync',
  );
  static List<LegacyFrugalMonth> _$frugalMonths(SyncScreenState v) =>
      v.frugalMonths;
  static const Field<SyncScreenState, List<LegacyFrugalMonth>> _f$frugalMonths =
      Field('frugalMonths', _$frugalMonths, key: r'frugal_months');
  static List<Exception> _$frugalMonthErrors(SyncScreenState v) =>
      v.frugalMonthErrors;
  static const Field<SyncScreenState, List<Exception>> _f$frugalMonthErrors =
      Field(
        'frugalMonthErrors',
        _$frugalMonthErrors,
        key: r'frugal_month_errors',
      );
  static SyncStatus _$frugalMonthsSync(SyncScreenState v) => v.frugalMonthsSync;
  static const Field<SyncScreenState, SyncStatus> _f$frugalMonthsSync = Field(
    'frugalMonthsSync',
    _$frugalMonthsSync,
    key: r'frugal_months_sync',
  );
  static List<LegacySpendTracker> _$spendTrackers(SyncScreenState v) =>
      v.spendTrackers;
  static const Field<SyncScreenState, List<LegacySpendTracker>>
  _f$spendTrackers = Field(
    'spendTrackers',
    _$spendTrackers,
    key: r'spend_trackers',
  );
  static List<Exception> _$spendTrackerErrors(SyncScreenState v) =>
      v.spendTrackerErrors;
  static const Field<SyncScreenState, List<Exception>> _f$spendTrackerErrors =
      Field(
        'spendTrackerErrors',
        _$spendTrackerErrors,
        key: r'spend_tracker_errors',
      );
  static SyncStatus _$spendTrackersSync(SyncScreenState v) =>
      v.spendTrackersSync;
  static const Field<SyncScreenState, SyncStatus> _f$spendTrackersSync = Field(
    'spendTrackersSync',
    _$spendTrackersSync,
    key: r'spend_trackers_sync',
  );
  static List<TransactionTemplate> _$transactionTemplates(SyncScreenState v) =>
      v.transactionTemplates;
  static const Field<SyncScreenState, List<TransactionTemplate>>
  _f$transactionTemplates = Field(
    'transactionTemplates',
    _$transactionTemplates,
    key: r'transaction_templates',
  );
  static List<Exception> _$transactionTemplateErrors(SyncScreenState v) =>
      v.transactionTemplateErrors;
  static const Field<SyncScreenState, List<Exception>>
  _f$transactionTemplateErrors = Field(
    'transactionTemplateErrors',
    _$transactionTemplateErrors,
    key: r'transaction_template_errors',
  );
  static SyncStatus _$transactionTemplatesSync(SyncScreenState v) =>
      v.transactionTemplatesSync;
  static const Field<SyncScreenState, SyncStatus> _f$transactionTemplatesSync =
      Field(
        'transactionTemplatesSync',
        _$transactionTemplatesSync,
        key: r'transaction_templates_sync',
      );
  static bool _$isComplete(SyncScreenState v) => v.isComplete;
  static const Field<SyncScreenState, bool> _f$isComplete = Field(
    'isComplete',
    _$isComplete,
    key: r'is_complete',
  );
  static List<Exception> _$errors(SyncScreenState v) => v.errors;
  static const Field<SyncScreenState, List<Exception>> _f$errors = Field(
    'errors',
    _$errors,
  );
  static bool _$isSyncing(SyncScreenState v) => v.isSyncing;
  static const Field<SyncScreenState, bool> _f$isSyncing = Field(
    'isSyncing',
    _$isSyncing,
    key: r'is_syncing',
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SyncScreenState> fields = const {
    #hasSyncedData: _f$hasSyncedData,
    #categoryViews: _f$categoryViews,
    #categoryViewErrors: _f$categoryViewErrors,
    #categoryViewsSync: _f$categoryViewsSync,
    #frugalMonths: _f$frugalMonths,
    #frugalMonthErrors: _f$frugalMonthErrors,
    #frugalMonthsSync: _f$frugalMonthsSync,
    #spendTrackers: _f$spendTrackers,
    #spendTrackerErrors: _f$spendTrackerErrors,
    #spendTrackersSync: _f$spendTrackersSync,
    #transactionTemplates: _f$transactionTemplates,
    #transactionTemplateErrors: _f$transactionTemplateErrors,
    #transactionTemplatesSync: _f$transactionTemplatesSync,
    #isComplete: _f$isComplete,
    #errors: _f$errors,
    #isSyncing: _f$isSyncing,
  };

  static SyncScreenState _instantiate(DecodingData data) {
    return SyncScreenState(
      hasSyncedData: data.dec(_f$hasSyncedData),
      categoryViews: data.dec(_f$categoryViews),
      categoryViewErrors: data.dec(_f$categoryViewErrors),
      categoryViewsSync: data.dec(_f$categoryViewsSync),
      frugalMonths: data.dec(_f$frugalMonths),
      frugalMonthErrors: data.dec(_f$frugalMonthErrors),
      frugalMonthsSync: data.dec(_f$frugalMonthsSync),
      spendTrackers: data.dec(_f$spendTrackers),
      spendTrackerErrors: data.dec(_f$spendTrackerErrors),
      spendTrackersSync: data.dec(_f$spendTrackersSync),
      transactionTemplates: data.dec(_f$transactionTemplates),
      transactionTemplateErrors: data.dec(_f$transactionTemplateErrors),
      transactionTemplatesSync: data.dec(_f$transactionTemplatesSync),
      isComplete: data.dec(_f$isComplete),
      errors: data.dec(_f$errors),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SyncScreenState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyncScreenState>(map);
  }

  static SyncScreenState fromJson(String json) {
    return ensureInitialized().decodeJson<SyncScreenState>(json);
  }
}

mixin SyncScreenStateMappable {
  String toJson() {
    return SyncScreenStateMapper.ensureInitialized()
        .encodeJson<SyncScreenState>(this as SyncScreenState);
  }

  Map<String, dynamic> toMap() {
    return SyncScreenStateMapper.ensureInitialized().encodeMap<SyncScreenState>(
      this as SyncScreenState,
    );
  }

  SyncScreenStateCopyWith<SyncScreenState, SyncScreenState, SyncScreenState>
  get copyWith =>
      _SyncScreenStateCopyWithImpl<SyncScreenState, SyncScreenState>(
        this as SyncScreenState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SyncScreenStateMapper.ensureInitialized().stringifyValue(
      this as SyncScreenState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SyncScreenStateMapper.ensureInitialized().equalsValue(
      this as SyncScreenState,
      other,
    );
  }

  @override
  int get hashCode {
    return SyncScreenStateMapper.ensureInitialized().hashValue(
      this as SyncScreenState,
    );
  }
}

extension SyncScreenStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyncScreenState, $Out> {
  SyncScreenStateCopyWith<$R, SyncScreenState, $Out> get $asSyncScreenState =>
      $base.as((v, t, t2) => _SyncScreenStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SyncScreenStateCopyWith<$R, $In extends SyncScreenState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    LegacyCategoryView,
    ObjectCopyWith<$R, LegacyCategoryView, LegacyCategoryView>
  >
  get categoryViews;
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get categoryViewErrors;
  ListCopyWith<
    $R,
    LegacyFrugalMonth,
    ObjectCopyWith<$R, LegacyFrugalMonth, LegacyFrugalMonth>
  >
  get frugalMonths;
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get frugalMonthErrors;
  ListCopyWith<
    $R,
    LegacySpendTracker,
    ObjectCopyWith<$R, LegacySpendTracker, LegacySpendTracker>
  >
  get spendTrackers;
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get spendTrackerErrors;
  ListCopyWith<
    $R,
    TransactionTemplate,
    TransactionTemplateCopyWith<$R, TransactionTemplate, TransactionTemplate>
  >
  get transactionTemplates;
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get transactionTemplateErrors;
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get errors;
  $R call({
    bool? hasSyncedData,
    List<LegacyCategoryView>? categoryViews,
    List<Exception>? categoryViewErrors,
    SyncStatus? categoryViewsSync,
    List<LegacyFrugalMonth>? frugalMonths,
    List<Exception>? frugalMonthErrors,
    SyncStatus? frugalMonthsSync,
    List<LegacySpendTracker>? spendTrackers,
    List<Exception>? spendTrackerErrors,
    SyncStatus? spendTrackersSync,
    List<TransactionTemplate>? transactionTemplates,
    List<Exception>? transactionTemplateErrors,
    SyncStatus? transactionTemplatesSync,
    bool? isComplete,
    List<Exception>? errors,
  });
  SyncScreenStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SyncScreenStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyncScreenState, $Out>
    implements SyncScreenStateCopyWith<$R, SyncScreenState, $Out> {
  _SyncScreenStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyncScreenState> $mapper =
      SyncScreenStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    LegacyCategoryView,
    ObjectCopyWith<$R, LegacyCategoryView, LegacyCategoryView>
  >
  get categoryViews => ListCopyWith(
    $value.categoryViews,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryViews: v),
  );
  @override
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get categoryViewErrors => ListCopyWith(
    $value.categoryViewErrors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryViewErrors: v),
  );
  @override
  ListCopyWith<
    $R,
    LegacyFrugalMonth,
    ObjectCopyWith<$R, LegacyFrugalMonth, LegacyFrugalMonth>
  >
  get frugalMonths => ListCopyWith(
    $value.frugalMonths,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(frugalMonths: v),
  );
  @override
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get frugalMonthErrors => ListCopyWith(
    $value.frugalMonthErrors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(frugalMonthErrors: v),
  );
  @override
  ListCopyWith<
    $R,
    LegacySpendTracker,
    ObjectCopyWith<$R, LegacySpendTracker, LegacySpendTracker>
  >
  get spendTrackers => ListCopyWith(
    $value.spendTrackers,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(spendTrackers: v),
  );
  @override
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get spendTrackerErrors => ListCopyWith(
    $value.spendTrackerErrors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(spendTrackerErrors: v),
  );
  @override
  ListCopyWith<
    $R,
    TransactionTemplate,
    TransactionTemplateCopyWith<$R, TransactionTemplate, TransactionTemplate>
  >
  get transactionTemplates => ListCopyWith(
    $value.transactionTemplates,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(transactionTemplates: v),
  );
  @override
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get transactionTemplateErrors => ListCopyWith(
    $value.transactionTemplateErrors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(transactionTemplateErrors: v),
  );
  @override
  ListCopyWith<$R, Exception, ObjectCopyWith<$R, Exception, Exception>>
  get errors => ListCopyWith(
    $value.errors,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(errors: v),
  );
  @override
  $R call({
    bool? hasSyncedData,
    List<LegacyCategoryView>? categoryViews,
    List<Exception>? categoryViewErrors,
    SyncStatus? categoryViewsSync,
    List<LegacyFrugalMonth>? frugalMonths,
    List<Exception>? frugalMonthErrors,
    SyncStatus? frugalMonthsSync,
    List<LegacySpendTracker>? spendTrackers,
    List<Exception>? spendTrackerErrors,
    SyncStatus? spendTrackersSync,
    List<TransactionTemplate>? transactionTemplates,
    List<Exception>? transactionTemplateErrors,
    SyncStatus? transactionTemplatesSync,
    bool? isComplete,
    List<Exception>? errors,
  }) => $apply(
    FieldCopyWithData({
      if (hasSyncedData != null) #hasSyncedData: hasSyncedData,
      if (categoryViews != null) #categoryViews: categoryViews,
      if (categoryViewErrors != null) #categoryViewErrors: categoryViewErrors,
      if (categoryViewsSync != null) #categoryViewsSync: categoryViewsSync,
      if (frugalMonths != null) #frugalMonths: frugalMonths,
      if (frugalMonthErrors != null) #frugalMonthErrors: frugalMonthErrors,
      if (frugalMonthsSync != null) #frugalMonthsSync: frugalMonthsSync,
      if (spendTrackers != null) #spendTrackers: spendTrackers,
      if (spendTrackerErrors != null) #spendTrackerErrors: spendTrackerErrors,
      if (spendTrackersSync != null) #spendTrackersSync: spendTrackersSync,
      if (transactionTemplates != null)
        #transactionTemplates: transactionTemplates,
      if (transactionTemplateErrors != null)
        #transactionTemplateErrors: transactionTemplateErrors,
      if (transactionTemplatesSync != null)
        #transactionTemplatesSync: transactionTemplatesSync,
      if (isComplete != null) #isComplete: isComplete,
      if (errors != null) #errors: errors,
    }),
  );
  @override
  SyncScreenState $make(CopyWithData data) => SyncScreenState(
    hasSyncedData: data.get(#hasSyncedData, or: $value.hasSyncedData),
    categoryViews: data.get(#categoryViews, or: $value.categoryViews),
    categoryViewErrors: data.get(
      #categoryViewErrors,
      or: $value.categoryViewErrors,
    ),
    categoryViewsSync: data.get(
      #categoryViewsSync,
      or: $value.categoryViewsSync,
    ),
    frugalMonths: data.get(#frugalMonths, or: $value.frugalMonths),
    frugalMonthErrors: data.get(
      #frugalMonthErrors,
      or: $value.frugalMonthErrors,
    ),
    frugalMonthsSync: data.get(#frugalMonthsSync, or: $value.frugalMonthsSync),
    spendTrackers: data.get(#spendTrackers, or: $value.spendTrackers),
    spendTrackerErrors: data.get(
      #spendTrackerErrors,
      or: $value.spendTrackerErrors,
    ),
    spendTrackersSync: data.get(
      #spendTrackersSync,
      or: $value.spendTrackersSync,
    ),
    transactionTemplates: data.get(
      #transactionTemplates,
      or: $value.transactionTemplates,
    ),
    transactionTemplateErrors: data.get(
      #transactionTemplateErrors,
      or: $value.transactionTemplateErrors,
    ),
    transactionTemplatesSync: data.get(
      #transactionTemplatesSync,
      or: $value.transactionTemplatesSync,
    ),
    isComplete: data.get(#isComplete, or: $value.isComplete),
    errors: data.get(#errors, or: $value.errors),
  );

  @override
  SyncScreenStateCopyWith<$R2, SyncScreenState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SyncScreenStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

