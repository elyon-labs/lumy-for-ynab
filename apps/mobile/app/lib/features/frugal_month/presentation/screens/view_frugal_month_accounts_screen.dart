import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_repository.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';

class ViewFrugalMonthAccountsScreenState {
  ViewFrugalMonthAccountsScreenState({required this.frugalMonthId, required this.accounts});

  factory ViewFrugalMonthAccountsScreenState.initial({required String frugalMonthId}) {
    return ViewFrugalMonthAccountsScreenState(frugalMonthId: frugalMonthId, accounts: []);
  }

  final String frugalMonthId;
  final List<Account> accounts;
}

class ViewFrugalMonthAccountsScreenCubit extends Cubit<ViewFrugalMonthAccountsScreenState> {
  ViewFrugalMonthAccountsScreenCubit({
    required String frugalMonthId,
    required WatchFrugalMonthData watchFrugalMonthData,
    required AccountsRepository accountsRepository,
  }) : _frugalMonthId = frugalMonthId,
       _accountsRepository = accountsRepository,
       _watchFrugalMonthData = watchFrugalMonthData,
       super(ViewFrugalMonthAccountsScreenState.initial(frugalMonthId: frugalMonthId)) {
    fetch();
  }

  factory ViewFrugalMonthAccountsScreenCubit.create(String frugalMonthId) {
    return ViewFrugalMonthAccountsScreenCubit(
      frugalMonthId: frugalMonthId,
      watchFrugalMonthData: WatchFrugalMonthData.create(),
      accountsRepository: inject(),
    );
  }

  final String _frugalMonthId;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final AccountsRepository _accountsRepository;
  final subs = CompositeSubscription();

  void fetch() {
    final frugalMonthDataStream = _watchFrugalMonthData(_frugalMonthId);
    final accountsStream = frugalMonthDataStream.switchMap((frugalMonthData) async* {
      yield* _accountsRepository.watch(AccountsWithIds(frugalMonthData.month.accountIds));
    });
    final sub = accountsStream.listen((accounts) {
      safeEmit(
        ViewFrugalMonthAccountsScreenState(frugalMonthId: _frugalMonthId, accounts: accounts),
      );
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ViewFrugalMonthAccountsScreen extends StatelessWidget {
  const ViewFrugalMonthAccountsScreen({super.key, required this.id});
  final String id;

  static String buildRoute(String id) {
    return '/budget/frugal_month/$id/settings/accounts';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewFrugalMonthAccountsScreenCubit.create(id),
      child: Scaffold(
        appBar: AppBar(title: const Text('Accounts')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: SafeArea(
            child:
                BlocBuilder<ViewFrugalMonthAccountsScreenCubit, ViewFrugalMonthAccountsScreenState>(
                  builder: (context, state) {
                    return VLayout(
                      spacing: 0,
                      children: [
                        for (final account in state.accounts) ...[
                          ListRow(
                            title: Text(account.name),
                            leading: CircleAvatar(
                              radius: Sizes.unit * 2,
                              backgroundColor: context.colors.good,
                              child: Text(
                                account.name.substring(0, 1).toUpperCase(),
                                style: context.text.title.copyWith(color: context.colors.onGood),
                              ),
                            ),
                            externalPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.edgePadding,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
