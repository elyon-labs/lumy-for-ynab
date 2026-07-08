import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../../../../category_views/domain/models/category_view.dart';
import '../choose_category_view_bottom_sheet.dart';
import 'reports_tab_category_view_button_cubit.dart';
import 'reports_tab_category_view_button_state.dart';

class ReportsTabCategoryViewButton extends HookWidget {
  const ReportsTabCategoryViewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsTabCategoryMenuButtonCubit.create(),
      child: SecondaryButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) {
              return DraggableScrollableSheet(
                expand: false,
                maxChildSize: 0.90,
                builder: (context, scrollController) {
                  return ChooseCategoryViewBottomSheet(scrollController: scrollController);
                },
              );
            },
          );
        },
        child: BlocBuilder<ReportsTabCategoryMenuButtonCubit, ReportsTabCategoryViewButtonState>(
          builder: (context, state) {
            return Text(
              switch (state.selected) {
                Some<CategoryView>(:final some) => some.name,
                None<CategoryView>() => 'All categories',
              },
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }
}
