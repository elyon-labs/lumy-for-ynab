import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../../../../../common/presentation/categories/category_list.dart';
import '../../../../../../../../common/presentation/categories/category_row.dart';
import '../../../../../../../category_views/domain/models/category_view.dart';
import 'category_view_details_cubit.dart';
import 'category_view_details_screen_state.dart';
import 'edit_category_view_options_button.dart';

class CategoryViewDetailsScreen extends StatelessWidget {
  const CategoryViewDetailsScreen({super.key, required this.viewId});
  final String viewId;

  static String buildRoute(String viewId) {
    return '/settings/category_views/$viewId';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryViewDetailsScreenCubit.create(categoryViewId: viewId),
      child: BlocBuilder<CategoryViewDetailsScreenCubit, CategoryViewDetailsScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: _Title(state),
              actions: [EditCategoryViewOptionsButton(categoryViewId: viewId)],
            ),
            body: switch (state.view) {
              Loaded<CategoryView>(:final value) => _Body(
                view: value,
                categories: state.categories,
                categoryGroups: state.categoryGroups,
              ),
              _ => const Center(child: CircularProgressIndicator.adaptive()),
            },
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.state);

  final CategoryViewDetailsScreenState state;

  @override
  Widget build(BuildContext context) {
    return Text(switch (state.view) {
      Loaded(:final value) => value.name,
      Error() => 'Error',
      _ => 'Loading...',
    });
  }
}

class _Body extends HookWidget {
  const _Body({required this.view, required this.categories, required this.categoryGroups});

  final CategoryView view;
  final List<Category> categories;
  final List<CategoryGroup> categoryGroups;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return SingleChildScrollView(
      child: CategoryList(
        categories: categories.toList(),
        allCategoryGroups: categoryGroups,
        currencyFormat: currencyFormat,
        rowBuilder: (c) => CategoryRow(category: c),
      ),
    );
  }
}
