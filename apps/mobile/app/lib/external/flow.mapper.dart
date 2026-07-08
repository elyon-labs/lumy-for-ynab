// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'flow.dart';

class FlowStateMapper extends ClassMapperBase<FlowState> {
  FlowStateMapper._();

  static FlowStateMapper? _instance;
  static FlowStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FlowStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FlowState';

  static String _$route(FlowState v) => v.route;
  static const Field<FlowState, String> _f$route = Field('route', _$route);

  @override
  final MappableFields<FlowState> fields = const {#route: _f$route};

  static FlowState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('FlowState');
  }

  @override
  final Function instantiate = _instantiate;

  static FlowState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FlowState>(map);
  }

  static FlowState fromJson(String json) {
    return ensureInitialized().decodeJson<FlowState>(json);
  }
}

mixin FlowStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  FlowStateCopyWith<FlowState, FlowState, FlowState> get copyWith;
}

abstract class FlowStateCopyWith<$R, $In extends FlowState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? route});
  FlowStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

