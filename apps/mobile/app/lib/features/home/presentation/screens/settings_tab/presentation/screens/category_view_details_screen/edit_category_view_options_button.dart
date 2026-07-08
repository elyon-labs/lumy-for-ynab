import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../../../../common/presentation/modals/options_sheet.dart';
import '../../flows/settings_edit_category_view/screens/settings_edit_category_view_categories_screen.dart';
import 'category_view_details_cubit.dart';

enum EditCategoryViewOption { edit, delete }

class EditCategoryViewOptionsButton extends StatelessWidget {
  const EditCategoryViewOptionsButton({super.key, required this.categoryViewId});

  final String categoryViewId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Ionicons.ellipsis_vertical),
      onPressed: () async {
        await showModalBottomSheet(
          showDragHandle: true,
          useRootNavigator: true,
          context: context,
          builder: (_) {
            return EditCategoryViewOptionsSheet(
              onEdit: () {
                context.go(SettingsEditCategoryViewCategoriesScreen.buildRoute(categoryViewId));
              },
              onDelete: () async {
                await context.showConfirmationDialog(
                  title: const Text('Delete Category View'),
                  body: const Text(
                    'Are you sure you want to delete this Category View? This cannot be undone.',
                  ),
                  confirmButton: DialogActionButton(
                    text: 'Delete',
                    isDestructive: true,
                    onPressed: () async {
                      await context.read<CategoryViewDetailsScreenCubit>().delete();
                      if (context.mounted) context.pop();
                    },
                  ),
                  cancelButton: DialogActionButton(text: 'Nevermind'),
                );
              },
            );
          },
        );
      },
    );
  }
}

class EditCategoryViewOptionsSheet extends StatelessWidget {
  const EditCategoryViewOptionsSheet({super.key, required this.onDelete, required this.onEdit});

  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return OptionsSheet(
      options: EditCategoryViewOption.values.map((v) {
        return switch (v) {
          EditCategoryViewOption.delete => OptionsSheetButton(
            title: const Text('Delete'),
            onTap: onDelete,
            isDestructive: true,
          ),
          EditCategoryViewOption.edit => OptionsSheetButton(
            title: const Text('Edit'),
            onTap: onEdit,
            isDestructive: false,
          ),
        };
      }).toList(),
    );
  }
}
