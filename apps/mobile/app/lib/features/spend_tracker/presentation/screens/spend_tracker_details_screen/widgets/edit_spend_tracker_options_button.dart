import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../../common/presentation/modals/options_sheet.dart';
import '../../../../../home/presentation/screens/reports_tab/presentation/screens/reports_edit_spend_tracker_query_screen/reports_edit_spend_tracker_query_screen.dart';
import '../../rename_spend_tracker_screen/rename_spend_tracker_screen.dart';
import '../spend_tracker_details_screen_cubit.dart';

enum EditSpendTrackerOption { edit, rename, delete }

class EditSpendTrackerOptionsButton extends StatelessWidget {
  const EditSpendTrackerOptionsButton({
    super.key,
    required this.spendTrackerId,
    required this.isAdvanced,
  });

  final String spendTrackerId;
  final bool isAdvanced;

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
            return EditSpendTrackerOptionsSheet(
              onRename: () async {
                GoRouter.of(context).go(RenameSpendTrackerScreen.buildRoute(spendTrackerId));
              },
              onEdit: isAdvanced
                  ? () {
                      context.go(
                        ReportsEditSpendTrackerQueryScreen.buildRoute(
                          spendTrackerId: spendTrackerId,
                        ),
                      );
                    }
                  : null,
              onDelete: () async {
                await context.showConfirmationDialog(
                  title: const Text('Delete Spend Tracker'),
                  body: const Text(
                    'Are you sure you want to delete this spend tracker? The transactions it tracks will not be deleted, '
                    'but if you want to track them again you will need to re-create this tracker.',
                  ),
                  confirmButton: DialogActionButton(
                    text: 'Delete',
                    isDestructive: true,
                    onPressed: () async {
                      await context.read<SpendTrackerDetailsScreenCubit>().delete();
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

class EditSpendTrackerOptionsSheet extends StatelessWidget {
  const EditSpendTrackerOptionsSheet({
    super.key,
    required this.onRename,
    required this.onDelete,
    required this.onEdit,
  });

  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return OptionsSheet(
      options: EditSpendTrackerOption.values
          .map((v) {
            return switch (v) {
              EditSpendTrackerOption.rename => OptionsSheetButton(
                title: const Text('Rename'),
                onTap: onRename,
                isDestructive: false,
              ),
              EditSpendTrackerOption.delete => OptionsSheetButton(
                title: const Text('Delete'),
                onTap: onDelete,
                isDestructive: true,
              ),
              EditSpendTrackerOption.edit =>
                onEdit == null
                    ? null
                    : OptionsSheetButton(
                        title: const Text('Edit query'),
                        onTap: onEdit!,
                        isDestructive: false,
                      ),
            };
          })
          .nonNulls
          .toList(),
    );
  }
}
