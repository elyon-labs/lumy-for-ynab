import 'package:flutter/material.dart';

GlobalKey<ScaffoldMessengerState> rootScaffoldKey = GlobalKey<ScaffoldMessengerState>();

extension RootScaffoldKeyX on GlobalKey<ScaffoldMessengerState> {
  void showSnackBar(SnackBar snackBar) {
    currentState?.showSnackBar(snackBar);
  }
}
