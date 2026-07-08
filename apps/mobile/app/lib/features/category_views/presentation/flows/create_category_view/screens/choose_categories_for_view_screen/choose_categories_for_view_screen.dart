import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/presentation/bottom_glow_container.dart';
import '../../../../../../../common/presentation/categories/choose_categories.dart';
import '../../../../../domain/models/category_view.dart';
import 'choose_categories_for_view_screen_cubit.dart';
import 'choose_categories_for_view_screen_state.dart';

typedef CategoriesForView = ({List<String> categoryIds, List<String> categoryGroupIds});

class ChooseCategoriesForViewScreen extends HookWidget {
  const ChooseCategoriesForViewScreen({
    super.key,
    required this.onComplete,
    this.existingCategoryView,
  });

  final CategoryView? existingCategoryView;
  final ValueSetter<CategoriesForView> onComplete;

  @override
  Widget build(BuildContext context) {
    final selectedCategoryIds = useState(existingCategoryView?.categoryIds ?? <String>[]);
    final selectedCategoryGroupIds = useState(existingCategoryView?.categoryGroupIds ?? <String>[]);

    return BlocProvider(
      create: (context) => ChooseCategoriesForViewScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose categories'),
          leading: BackButton(onPressed: () => GoRouter.of(context).pop()),
        ),
        body: VLayout(
          spacing: 0,
          children: [
            Expanded(
              child:
                  BlocBuilder<
                    ChooseCategoriesForViewScreenCubit,
                    ChooseCategoriesForViewScreenState
                  >(
                    builder: (context, state) {
                      return switch (state.categoryGroups) {
                        Loaded(:final value) => ChooseCategories(
                          selectedCategoryIds: selectedCategoryIds,
                          selectedCategoryGroupIds: selectedCategoryGroupIds,
                          allowCategoryGroupSelection: true,
                          options: value,
                        ),
                        _ => const Center(child: CircularProgressIndicator.adaptive()),
                      };
                    },
                  ),
            ),
            BottomGlowContainer(
              child: PrimaryButton(
                onPressed:
                    selectedCategoryIds.value.isNotEmpty ||
                        selectedCategoryGroupIds.value.isNotEmpty
                    ? () async {
                        onComplete((
                          categoryIds: selectedCategoryIds.value,
                          categoryGroupIds: selectedCategoryGroupIds.value,
                        ));
                      }
                    : null,
                child: const Text('Confirm Categories'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
