import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../utils/_cubit.dart';
import 'budgets_repository.dart';

class CurrencyFormatCubit extends Cubit<Option<CurrencyFormat>> {
  CurrencyFormatCubit({required this.budgetsRepo}) : super(const None()) {
    fetch();
  }

  factory CurrencyFormatCubit.create() {
    return CurrencyFormatCubit(budgetsRepo: inject());
  }

  final BudgetsRepository budgetsRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = budgetsRepo.watchCurrencyFormat().listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

extension CurrencyHookWidgetX on HookWidget {
  Option<CurrencyFormat> useCurrencyFormat() {
    final context = useContext();
    return context.watch<CurrencyFormatCubit>().state;
  }
}
