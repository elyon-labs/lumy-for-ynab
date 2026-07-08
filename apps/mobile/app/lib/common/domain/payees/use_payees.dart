import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/_async_snapshot.dart';
import 'payees_repository.dart';
import 'payees_view.dart';

Async<List<Payee>> usePayees({PayeesView view = const AllPayees()}) {
  final repo = useMemoized(inject<PayeesRepository>);
  final stream = useMemoized(() => repo.watch(view), [view]);
  final value = useStream(stream);
  return value.toAsync();
}
