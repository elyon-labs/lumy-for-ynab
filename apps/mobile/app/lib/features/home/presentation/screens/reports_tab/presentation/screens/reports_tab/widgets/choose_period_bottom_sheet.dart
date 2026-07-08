import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../../common/presentation/_color.dart';
import '../../../../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../../persistence/settings.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../../ynab_api/_budget.dart';
import '../../../../../../../../date_range/domain/models/chosen_period.dart';
import '../../../../../../../../date_range/domain/models/date_range.dart';

class ChoosePeriodBottomSheetState {
  ChoosePeriodBottomSheetState({
    required this.chosenPeriod,
    required this.minDate,
    required this.maxDate,
  });

  factory ChoosePeriodBottomSheetState.initial() {
    return ChoosePeriodBottomSheetState(
      chosenPeriod: const Loading(),
      minDate: today,
      maxDate: today,
    );
  }

  final Async<ChosenPeriod> chosenPeriod;
  final LocalDate minDate;
  final LocalDate maxDate;
}

class ChoosePeriodBottomSheetCubit extends Cubit<ChoosePeriodBottomSheetState> {
  ChoosePeriodBottomSheetCubit({required this.settings, required this.budgetsRepo})
    : super(ChoosePeriodBottomSheetState.initial()) {
    fetch();
  }

  factory ChoosePeriodBottomSheetCubit.create() {
    return ChoosePeriodBottomSheetCubit(settings: inject(), budgetsRepo: inject());
  }

  void fetch() {
    final chosenPeriodStream = settings.watchChosenPeriod();
    final selectedBudgetStream = budgetsRepo.watchSelected();
    final sub = Rx.combineLatest2(chosenPeriodStream, selectedBudgetStream, (period, budget) {
      final minDate = budget.mapOr((b) => b.firstMonthDate ?? today, today);
      final maxDate = budget.mapOr((b) => b.lastMonthDate ?? today, today);
      return ChoosePeriodBottomSheetState(
        chosenPeriod: Loaded(period),
        minDate: minDate,
        maxDate: maxDate,
      );
    }).listen(safeEmit);
    subs.add(sub);
  }

  final Settings settings;
  final BudgetsRepository budgetsRepo;
  final subs = CompositeSubscription();

  Future<void> setChosenPeriodType(ChosenPeriodType chosenPeriod) async {
    await settings.setChosenPeriodType(chosenPeriod);
  }

  Future<void> setCustomPeriod({required LocalDate startDate, required LocalDate endDate}) async {
    await settings.setCustomPeriod(dateRange: (from: startDate, to: endDate));
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChoosePeriodBottomSheet extends HookWidget {
  const ChoosePeriodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, controller) {
        return BlocProvider(
          create: (context) => ChoosePeriodBottomSheetCubit.create(),
          child: BlocBuilder<ChoosePeriodBottomSheetCubit, ChoosePeriodBottomSheetState>(
            builder: (context, state) {
              return BottomSheetWithHeader(
                title: const HEdgePadding(child: Text('Choose Period')),
                builder: (context) {
                  final period = state.chosenPeriod;
                  if (period.isLoading) {
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }

                  final chosenPeriod = period.unwrap();

                  return Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(Sizes.edgePadding),
                      child: VLayout(
                        spacing: 0,
                        children: [
                          _ChooseCustomPeriodDateRangeButton(
                            chosenPeriod: chosenPeriod,
                            minDate: state.minDate,
                            maxDate: state.maxDate,
                            shouldShow: chosenPeriod.type == ChosenPeriodType.custom,
                          ),
                          ...ChosenPeriodType.values.map((v) {
                            final isSelected = chosenPeriod.type == v;
                            final trailing = isSelected
                                ? const Icon(Ionicons.checkmark_circle_outline)
                                : null;

                            return ListRow(
                              title: Text(v.userFriendlyName),
                              onTap: () async {
                                await context
                                    .read<ChoosePeriodBottomSheetCubit>()
                                    .setChosenPeriodType(v);
                                // Close the bottom sheet after setting the custom period.
                                if (v != ChosenPeriodType.custom && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              isSelected: isSelected,
                              implicitTrailing: false,
                              trailing: trailing,
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ChooseCustomPeriodDateRangeButton extends StatelessWidget {
  const _ChooseCustomPeriodDateRangeButton({
    required this.chosenPeriod,
    required this.minDate,
    required this.maxDate,
    required this.shouldShow,
  });

  final ChosenPeriod chosenPeriod;
  final LocalDate minDate;
  final LocalDate maxDate;
  final bool shouldShow;

  @override
  Widget build(BuildContext context) {
    Future<void> showDateRangePicker() async {
      final range = await showAdaptiveDialog<DateRange>(
        barrierDismissible: true,
        context: context,
        builder: (_) =>
            _DateRangePickerDialog(chosenPeriod: chosenPeriod, minDate: minDate, maxDate: maxDate),
      );

      if (range != null && context.mounted) {
        await context.read<ChoosePeriodBottomSheetCubit>().setCustomPeriod(
          startDate: range.from,
          endDate: range.to,
        );
        // Close the bottom sheet after setting the custom period.
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    return Animate(
      target: shouldShow ? 1.0 : 0.0,
      effects: [
        VisibilityEffect(maintain: false, duration: 1.milliseconds),
        ScaleEffect(duration: 270.milliseconds, curve: Curves.easeOutBack),
      ],
      child: Center(
        child: HEdgePadding(
          child: HLayout(
            children: [
              Flexible(
                child: SecondaryButton(
                  onPressed: showDateRangePicker,
                  child: Text(
                    '${chosenPeriod.startDate.MMMdyyyy()} - ${chosenPeriod.endDate.MMMdyyyy()}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRangePickerDialog extends StatelessWidget {
  const _DateRangePickerDialog({
    required this.chosenPeriod,
    required this.minDate,
    required this.maxDate,
  });

  final ChosenPeriod chosenPeriod;
  final LocalDate minDate;
  final LocalDate maxDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VEdgePadding(
            child: SfDateRangePickerTheme(
              data: SfDateRangePickerThemeData(
                backgroundColor: Colors.transparent,
                headerBackgroundColor: Colors.transparent,
                todayHighlightColor: context.colors.foreground,
                todayCellTextStyle: TextStyle(color: context.colors.foreground),
                todayTextStyle: TextStyle(color: context.colors.foreground),
                selectionColor: context.colors.foreground,
                rangeSelectionColor: context.colors.foreground.withAlphaOf(0.10),
                endRangeSelectionColor: context.colors.foreground,
                startRangeSelectionColor: context.colors.foreground,
                selectionTextStyle: TextStyle(color: context.colors.body),
                rangeSelectionTextStyle: TextStyle(color: context.colors.foreground),
              ),
              child: SfDateRangePicker(
                todayHighlightColor: Colors.transparent,
                allowViewNavigation: false,
                initialDisplayDate: chosenPeriod.startDate.toDateTimeUnspecified(),
                initialSelectedRange: PickerDateRange(
                  chosenPeriod.startDate.toDateTimeUnspecified(),
                  chosenPeriod.endDate.toDateTimeUnspecified(),
                ),
                minDate: minDate.toDateTimeUnspecified(),
                maxDate: maxDate.toDateTimeUnspecified(),
                view: DateRangePickerView.year,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                  final startDate = (args.value as PickerDateRange).startDate;
                  final endDate = (args.value as PickerDateRange).endDate;

                  if (startDate != null && endDate != null) {
                    final startLocalDate = LocalDate.dateTime(startDate);
                    final endLocalDate = LocalDate.dateTime(endDate);
                    Navigator.of(context).pop((from: startLocalDate, to: endLocalDate));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
