import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../common/presentation/design_system/list_row.dart';

enum AddConditionType { and, or, child }

class AddConditionBottomSheet extends StatelessWidget {
  const AddConditionBottomSheet({super.key, required this.onAdd});

  final ValueSetter<AddConditionType> onAdd;

  @override
  Widget build(BuildContext context) {
    void onTap(AddConditionType type) {
      onAdd(type);
      context.pop();
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return BottomSheetWithHeader(
          title: const VEdgePadding(child: Text('Add condition')),
          builder: (context) {
            return Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: VLayout(
                  spacing: 0,
                  children: [
                    const VSpace(space: Sizes.edgePadding),
                    ListRow(
                      implicitTrailing: false,
                      visualDensity: VisualDensity.compact,
                      title: const Text('Child condition'),
                      subtitle: const Text('A single condition that can be true or not true'),
                      onTap: () => onTap(AddConditionType.child),
                    ),
                    ListRow(
                      implicitTrailing: false,
                      visualDensity: VisualDensity.compact,
                      title: const Text('AND condition'),
                      subtitle: const Text('All conditions must be met'),
                      onTap: () => onTap(AddConditionType.and),
                    ),
                    ListRow(
                      implicitTrailing: false,
                      visualDensity: VisualDensity.compact,
                      title: const Text('OR condition'),
                      subtitle: const Text('At least one condition must be met'),
                      onTap: () => onTap(AddConditionType.or),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
