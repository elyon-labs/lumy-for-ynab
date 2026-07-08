import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../category_views/domain/models/category_view.dart';
import '../../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../../flows/settings_create_category_view/screens/settings_choose_categories_for_view_screen.dart';
import '../category_view_details_screen/category_view_details_screen.dart';
import 'category_views_list_screen_cubit.dart';
import 'category_views_list_screen_state.dart';

class CategoryViewsListScreen extends StatelessWidget {
  const CategoryViewsListScreen({super.key});

  static String route = '/settings/category_views';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryViewsListScreenCubit.create(),
      child: BlocBuilder<CategoryViewsListScreenCubit, CategoryViewsListScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Views'),
              actions: [
                IconButton(
                  tooltip: 'Add',
                  icon: const Icon(Ionicons.add_circle_outline),
                  onPressed: () {
                    context.read<CreateCategoryViewCubit>().reset();
                    GoRouter.of(context).go(SettingsChooseCategoriesForViewScreen.route);
                  },
                ).visible(state.categoryViews.isNotEmpty),
              ],
            ),
            body: _Body(state.categoryViews),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.categoryViews);
  final List<CategoryView> categoryViews;

  @override
  Widget build(BuildContext context) {
    if (categoryViews.isEmpty) {
      return const _EmptyBody();
    } else {
      return _ContentBody(categoryViews: categoryViews);
    }
  }
}

class _ContentBody extends StatelessWidget {
  const _ContentBody({required this.categoryViews});

  final List<CategoryView> categoryViews;

  @override
  Widget build(BuildContext context) {
    final children = categoryViews.map((c) {
      return ListRow(
        title: Text(c.name),
        onTap: () => GoRouter.of(context).go(CategoryViewDetailsScreen.buildRoute(c.id)),
      );
    }).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      child: ListSection(children: children),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SingleChildScrollView(
        child: Center(
          child: VLayout(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding * 2),
                child: VLayout(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('No views yet', textAlign: TextAlign.center, style: context.text.headline),
                    const Text(
                      'Create a view to quickly filter charts and other data by groups of categories.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.unit * 6),
                child: HStretch(
                  child: SecondaryButton(
                    onPressed: () {
                      context.read<CreateCategoryViewCubit>().reset();
                      GoRouter.of(context).go(SettingsChooseCategoriesForViewScreen.route);
                    },
                    child: const Text('Create view'),
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
