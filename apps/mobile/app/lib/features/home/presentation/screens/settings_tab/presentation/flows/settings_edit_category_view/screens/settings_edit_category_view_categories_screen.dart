import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../category_views/presentation/flows/create_category_view/screens/choose_categories_for_view_screen/choose_categories_for_view_screen.dart';
import '../../../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../state/settings_edit_category_view_cubit.dart';
import '../state/settings_edit_category_view_state.dart';
import 'settings_edit_category_view_name_screen.dart';

class SettingsEditCategoryViewCategoriesScreen extends HookWidget {
  const SettingsEditCategoryViewCategoriesScreen({super.key, required this.viewId});

  final String viewId;

  static String buildRoute(String viewId) {
    return '/settings/category_views/$viewId/edit';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsEditCategoryViewCubit.create(viewId: viewId),
      child: BlocBuilder<SettingsEditCategoryViewCubit, SettingsEditCategoryViewState>(
        builder: (context, state) {
          final view = state.categoryView;
          return switch (view) {
            Loaded(:final value) => ChooseCategoriesForViewScreen(
              existingCategoryView: value,
              onComplete: (payload) {
                context.read<CreateCategoryViewCubit>().setSelected(
                  categoryIds: payload.categoryIds,
                  categoryGroupIds: payload.categoryGroupIds,
                );
                GoRouter.of(context).go(SettingsEditCategoryViewNameScreen.buildRoute(viewId));
              },
            ),
            _ => Scaffold(
              appBar: AppBar(title: const Text('Loading...')),
              body: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          };
        },
      ),
    );
  }
}
