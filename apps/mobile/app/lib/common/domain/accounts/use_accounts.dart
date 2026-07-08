import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/_async_snapshot.dart';
import 'accounts_repository.dart';
import 'accounts_view.dart';

Async<List<Account>> useAccounts({AccountsView view = const AllAccounts()}) {
  final repo = useMemoized(inject<AccountsRepository>);
  final stream = useMemoized(() => repo.watch(view), [view]);
  final value = useStream(stream);
  return value.toAsync();
}
