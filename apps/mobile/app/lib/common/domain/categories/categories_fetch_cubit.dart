import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/http_client.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/typedefs.dart';
import '../../../ynab_api/_category_group.dart';

class CategoriesFetchCubit extends Cubit<Async<List<Category>>> {
  CategoriesFetchCubit({
    required Settings settings,
    required HttpClient client,
    required LocalDatabase database,
  }) : _database = database,
       _client = client,
       _settings = settings,
       super(const Idle()) {
    unawaited(fetch());
  }

  factory CategoriesFetchCubit.create() {
    return CategoriesFetchCubit(
      settings: inject(),
      client: inject(ynabHttpClient),
      database: inject(),
    );
  }

  final Settings _settings;
  final HttpClient _client;
  final LocalDatabase _database;
  final _subs = CompositeSubscription();

  Future<void> fetch() async {
    if (_subs.isNotEmpty) await _subs.clear();

    final sub = _settings
        .watchSelectedBudgetId()
        .switchMap<Async<List<Category>>>(($budgetId) async* {
          if ($budgetId.isSome()) {
            final budgetId = $budgetId.unwrap();
            yield const Loading();
            final response = await _client.execute<Json>(
              GetRequest('/budgets/$budgetId/categories'),
            );

            switch (response) {
              case SuccessResponse<Json>():
                final json = response.response.data!;
                final parsed = CategoriesResponseMapper.fromMap(json);
                final categories = parsed.data.categoryGroups.categories.toList();
                if (parsed.data.categoryGroups.isEmpty) {
                  await _database.updateCategoryKnowledge(
                    parsed.data.serverKnowledge,
                    budgetId: budgetId,
                  );
                } else {
                  await _database.insertCategoryGroups(
                    parsed.data.categoryGroups,
                    budgetId: budgetId,
                    knowledge: parsed.data.serverKnowledge,
                  );
                }
                yield Loaded(categories);
              case ErrorResponse<Json>(:final error):
                yield Error(error);
            }
          }
        })
        .listen(safeEmit);
    _subs.add(sub);
  }
}
