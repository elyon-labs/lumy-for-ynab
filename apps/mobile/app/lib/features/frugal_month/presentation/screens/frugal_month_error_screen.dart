import 'package:flutter/material.dart';

import '../../../../common/presentation/error/error_screen.dart';

class FrugalMonthErrorScreen extends StatelessWidget {
  const FrugalMonthErrorScreen({super.key});

  static String route = '/budget/frugal_month_error';

  @override
  Widget build(BuildContext context) {
    return const ErrorScreen();
  }
}
