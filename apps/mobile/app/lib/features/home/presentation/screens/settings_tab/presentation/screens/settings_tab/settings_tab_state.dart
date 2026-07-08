import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../frugal_month/domain/models/frugal_month.dart';
import '../../../../../../../spend_tracker/domain/models/spend_tracker.dart';

part 'settings_tab_state.mapper.dart';

@MappableClass()
class SettingsTabState with SettingsTabStateMappable {
  SettingsTabState({
    required this.selectedBudget,
    required this.allBudgets,
    required this.spendTrackers,
    required this.shouldShowNullCurrencyTile,
    required this.themeMode,
    required this.pastFrugalMonths,
    required this.isLoading,
    required this.isUserAnonymous,
  });

  factory SettingsTabState.initial() {
    return SettingsTabState(
      selectedBudget: const None(),
      allBudgets: [],
      spendTrackers: [],
      shouldShowNullCurrencyTile: false,
      themeMode: ThemeMode.system,
      pastFrugalMonths: [],
      isLoading: true,
      isUserAnonymous: false,
    );
  }

  final Option<Budget> selectedBudget;
  final List<Budget> allBudgets;
  final List<SpendTracker> spendTrackers;
  final bool shouldShowNullCurrencyTile;
  final ThemeMode themeMode;
  final List<FrugalMonth> pastFrugalMonths;
  final bool isLoading;
  final bool isUserAnonymous;
}
