import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../utils/_cubit.dart';
import '../../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../../domain/use_cases/request_ynab_access_token.dart';
import 'write_access_screen_state.dart';

class WriteAccessScreenCubit extends Cubit<WriteAccessScreenState> {
  WriteAccessScreenCubit({required RequestYnabAccessToken requestYnabAccessToken})
    : _requestYnabAccessToken = requestYnabAccessToken,
      super(WriteAccessScreenState.initial());

  factory WriteAccessScreenCubit.create() {
    return WriteAccessScreenCubit(requestYnabAccessToken: RequestYnabAccessToken.create());
  }

  final RequestYnabAccessToken _requestYnabAccessToken;

  Future<Result<YnabAccessToken, Exception>> requestWriteAccess() async {
    emit(state.copyWith(accessRequest: const Loading()));
    final result = await _requestYnabAccessToken(includeWriteScope: true);
    final newState = result.when(
      ok: (token) {
        return state.copyWith(accessRequest: const Idle());
      },
      err: (error) {
        return state.copyWith(accessRequest: Error(error));
      },
    );
    safeEmit(newState);
    return result;
  }
}
