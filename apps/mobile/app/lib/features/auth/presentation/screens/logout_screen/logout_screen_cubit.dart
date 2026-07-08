import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';

import '../../../domain/use_cases/log_out.dart';
import 'logout_screen_state.dart';

class LogoutScreenCubit extends Cubit<LogoutScreenState> {
  LogoutScreenCubit({required LogOut logOut})
    : _logOut = logOut,
      super(LogoutScreenState.initial()) {
    unawaited(_triggerLogoutAfterDelay());
  }

  factory LogoutScreenCubit.create() {
    return LogoutScreenCubit(logOut: LogOut.create());
  }

  final LogOut _logOut;

  Future<void> _triggerLogoutAfterDelay() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(LogoutScreenState(executeLogout: true));
  }

  Future<Result<void, Exception>> logOut() async {
    return _logOut();
  }
}
