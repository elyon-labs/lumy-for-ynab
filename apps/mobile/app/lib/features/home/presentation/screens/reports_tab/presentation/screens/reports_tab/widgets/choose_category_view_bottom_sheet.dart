import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../reports_choose_categories_for_view_screen.dart';
import 'reports_tab_category_view_button/reports_tab_category_view_button_cubit.dart';
import 'reports_tab_category_view_button/reports_tab_category_view_button_state.dart';

class ChooseCategoryViewBottomSheet extends StatelessWidget {
  const ChooseCategoryViewBottomSheet({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsTabCategoryMenuButtonCubit.create(),
      child: BlocBuilder<ReportsTabCategoryMenuButtonCubit, ReportsTabCategoryViewButtonState>(
        builder: (context, state) {
          final allViews = state.allViews.map<Widget>((v) {
            final isSelected = state.selected.mapOr((s) => s.id == v.id, false);
            return ListRow(
              visualDensity: VisualDensity.compact,
              implicitTrailing: false,
              onTap: () async {
                await $settings().setReportsCategoryView(Some(v.id));
                if (context.mounted) {
                  context.pop();
                }
              },
              isSelected: isSelected,
              trailing: isSelected ? const Icon(Ionicons.checkmark_circle_outline) : null,
              title: Text(v.name),
            );
          });

          return BottomSheetWithHeader(
            title: const HEdgePadding(child: Text('Filter reports')),
            builder: (context) {
              final isNoViewSelected = state.selected.isNone();
              return Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(Sizes.edgePadding),
                  child: SafeArea(
                    child: VLayout(
                      children: [
                        ListRow(
                          isSelected: isNoViewSelected,
                          visualDensity: VisualDensity.compact,
                          implicitTrailing: false,
                          onTap: () async {
                            await $settings().setReportsCategoryView(const None());
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          trailing: isNoViewSelected
                              ? const Icon(Ionicons.checkmark_circle_outline)
                              : null,
                          title: const Text('All categories'),
                        ),
                        ...allViews,
                        const VSpace(),
                        HEdgePadding(
                          child: SecondaryButton(
                            child: const Text('Add view'),
                            onPressed: () {
                              context
                                ..pop()
                                ..go(ReportsChooseCategoriesForViewScreen.route);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
