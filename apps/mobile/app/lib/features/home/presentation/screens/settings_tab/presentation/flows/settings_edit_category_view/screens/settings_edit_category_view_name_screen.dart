import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../../utils/_build_context.dart';
import '../../../../../../../../category_views/presentation/flows/create_category_view/screens/name_category_view_screen.dart';
import '../../../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../../../screens/category_view_details_screen/category_view_details_screen.dart';
import '../state/settings_edit_category_view_cubit.dart';
import '../state/settings_edit_category_view_state.dart';

class SettingsEditCategoryViewNameScreen extends StatelessWidget {
  const SettingsEditCategoryViewNameScreen({super.key, required this.viewId});

  final String viewId;

  static String buildRoute(String viewId) {
    return '/settings/category_views/$viewId/edit/name';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsEditCategoryViewCubit.create(viewId: viewId),
      child: BlocBuilder<SettingsEditCategoryViewCubit, SettingsEditCategoryViewState>(
        builder: (context, state) {
          final view = state.categoryView;
          return switch (view) {
            Loaded(:final value) => NameCategoryViewScreen(
              existingCategoryView: value,
              onComplete: (name) async {
                context.read<CreateCategoryViewCubit>().setName(name);
                final result = await context.read<CreateCategoryViewCubit>().update(value);
                if (context.mounted) {
                  result.when(
                    ok: (_) {
                      GoRouter.of(context).go(CategoryViewDetailsScreen.buildRoute(viewId));
                    },
                    err: (err) {
                      context.showToast(const Text('Oops! Something went wrong'));
                    },
                  );
                }
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
