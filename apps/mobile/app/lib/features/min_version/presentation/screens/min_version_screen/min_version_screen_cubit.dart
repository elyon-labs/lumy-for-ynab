import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di.dart';
import '../../../../../app/environment/environment.dart';
import 'min_version_screen_state.dart';

class MinVersionScreenCubit extends Cubit<MinVersionScreenState> {
  MinVersionScreenCubit({required Environment environment})
    : super(
        MinVersionScreenState(
          iosStoreUrl: environment.iosStoreUrl,
          androidStoreUrl: environment.androidStoreUrl,
        ),
      );

  factory MinVersionScreenCubit.create() {
    return MinVersionScreenCubit(environment: inject());
  }
}
