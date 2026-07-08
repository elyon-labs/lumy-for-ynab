class LogoutScreenState {
  LogoutScreenState({required this.executeLogout});

  factory LogoutScreenState.initial() {
    return LogoutScreenState(executeLogout: false);
  }

  final bool executeLogout;
}
