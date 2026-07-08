import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature_flags_cubit.dart';

extension FeatureFlagsBuildContextX on BuildContext {
  FeatureFlagState get featureFlags => watch<FeatureFlagsCubit>().state;
}
