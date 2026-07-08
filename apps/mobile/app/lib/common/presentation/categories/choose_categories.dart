import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../ynab_api/_category.dart';
import '../../../ynab_api/_category_group.dart';
import '../design_system/list_row.dart';
import '../design_system/outlined_child.dart';

class ChooseCategories extends HookWidget {
  const ChooseCategories({
    super.key,
    required this.selectedCategoryIds,
    required this.selectedCategoryGroupIds,
    required this.options,
    this.allowCategoryGroupSelection = false,
    this.scrollController,
  });

  final ValueNotifier<List<String>> selectedCategoryIds;
  final ValueNotifier<List<String>> selectedCategoryGroupIds;
  final bool allowCategoryGroupSelection;
  final Iterable<CategoryGroup> options;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final validOptions = useRef(options.where((cg) => cg.categories.isNotEmpty));

    void addCategoryGroup(String groupId, List<String> categories) {
      if (!allowCategoryGroupSelection) return;
      if (!selectedCategoryGroupIds.value.contains(groupId)) {
        selectedCategoryGroupIds.value = {...selectedCategoryGroupIds.value, groupId}.toList();
        // Ensure categories in the group are not duplicated in categoryIds
        selectedCategoryIds.value = Set<String>.from(
          selectedCategoryIds.value.where((id) => !categories.contains(id)),
        ).toList();
      }
    }

    void removeCategoryGroup(String groupId, List<String> categories) {
      if (!allowCategoryGroupSelection) return;
      if (selectedCategoryGroupIds.value.contains(groupId)) {
        selectedCategoryGroupIds.value = Set<String>.from(
          selectedCategoryGroupIds.value.where((id) => id != groupId),
        ).toList();
      }
    }

    void addCategory(String categoryId, String groupId, List<String> groupCategories) {
      if (!selectedCategoryIds.value.contains(categoryId)) {
        selectedCategoryIds.value = {...selectedCategoryIds.value, categoryId}.toList();
      }
      // If any category is added, remove the group from the group selection
      if (allowCategoryGroupSelection) {
        if (groupCategories.every(selectedCategoryIds.value.contains)) {
          // Instead of adding category, add the group and remove all categories
          selectedCategoryGroupIds.value = {...selectedCategoryGroupIds.value, groupId}.toList();
          selectedCategoryIds.value = Set<String>.from(
            selectedCategoryIds.value.where((id) => !groupCategories.contains(id)),
          ).toList();
        } else {
          // Remove the group if it was selected
          selectedCategoryGroupIds.value = Set<String>.from(
            selectedCategoryGroupIds.value.where((id) => id != groupId),
          ).toList();
        }
      }
    }

    void removeCategory(String categoryId, String groupId, List<String> groupCategories) {
      if (selectedCategoryIds.value.contains(categoryId)) {
        selectedCategoryIds.value = Set<String>.from(
          selectedCategoryIds.value.where((id) => id != categoryId),
        ).toList();
      }
      if (allowCategoryGroupSelection) {
        // If the groupId was selected, add all *other* category ids to selectedCategoryIds
        if (selectedCategoryGroupIds.value.contains(groupId)) {
          selectedCategoryIds.value = <String>{
            ...selectedCategoryIds.value,
            ...groupCategories.where((id) => id != categoryId),
          }.toList();
          // Remove the group if all categories are removed
          selectedCategoryGroupIds.value = Set<String>.from(
            selectedCategoryGroupIds.value.where((id) => id != groupId),
          ).toList();
        }
      }
    }

    final rows = <Widget>[
      _SelectAllButton(
        selectedCategoryIds: selectedCategoryIds,
        selectedCategoryGroupIds: selectedCategoryGroupIds,
        allowCategoryGroupSelection: allowCategoryGroupSelection,
        options: validOptions.value,
      ),
      for (final categoryGroup in validOptions.value) ...[
        OutlinedChild(
          child: VLayout(
            spacing: 0,
            children: [
              _HeaderRow(
                categoryGroup: categoryGroup,
                onChanged: (selected) {
                  if (selected) {
                    addCategoryGroup(categoryGroup.id, categoryGroup.categoryIds);
                  } else {
                    removeCategoryGroup(categoryGroup.id, categoryGroup.categoryIds);
                  }
                },
                allowCategoryGroupSelection: allowCategoryGroupSelection,
                selectedCategoryGroupIds: selectedCategoryGroupIds,
                selectedCategoryIds: selectedCategoryIds,
              ),
              const Divider(indent: 0),
              VLayout(
                spacing: 0,
                children: [
                  for (final category in categoryGroup.categories) ...[
                    ...[
                      _ItemRow(
                        name: category.name,
                        isSelected:
                            selectedCategoryIds.value.contains(category.id) ||
                            selectedCategoryGroupIds.value.contains(categoryGroup.id),
                        onChanged: (selected) {
                          if (selected) {
                            addCategory(category.id, categoryGroup.id, categoryGroup.categoryIds);
                          } else {
                            removeCategory(
                              category.id,
                              categoryGroup.id,
                              categoryGroup.categoryIds,
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    ];

    return HEdgePadding(
      child: SingleChildScrollView(
        child: VLayout(spacing: Sizes.unit * 2, children: rows),
      ),
    );
  }
}

class _SelectAllButton extends StatelessWidget {
  const _SelectAllButton({
    required this.selectedCategoryIds,
    required this.selectedCategoryGroupIds,
    required this.allowCategoryGroupSelection,
    required this.options,
  });

  final ValueNotifier<List<String>> selectedCategoryIds;
  final ValueNotifier<List<String>> selectedCategoryGroupIds;
  final bool allowCategoryGroupSelection;
  final Iterable<CategoryGroup> options;

  @override
  Widget build(BuildContext context) {
    final categories = options.categories;
    final canSelectAll = switch (allowCategoryGroupSelection) {
      false => categories.length != selectedCategoryIds.value.length,
      true => options.length != selectedCategoryGroupIds.value.length,
    };

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          if (canSelectAll) {
            if (allowCategoryGroupSelection) {
              selectedCategoryGroupIds.value = options.ids;
            } else {
              selectedCategoryIds.value = categories.ids;
            }
          } else {
            selectedCategoryGroupIds.value = [];
            selectedCategoryIds.value = [];
          }
        },
        child: HLayout(
          children: [
            Text(canSelectAll ? 'Select all' : 'Deselect all'),
            if (canSelectAll) const Icon(Ionicons.ellipse_outline),
            if (!canSelectAll) const Icon(Ionicons.checkmark_circle_outline),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.categoryGroup,
    required this.onChanged,
    required this.allowCategoryGroupSelection,
    required this.selectedCategoryGroupIds,
    required this.selectedCategoryIds,
  });

  final CategoryGroup categoryGroup;
  final ValueSetter<bool> onChanged;
  final bool allowCategoryGroupSelection;
  final ValueNotifier<List<String>> selectedCategoryGroupIds;
  final ValueNotifier<List<String>> selectedCategoryIds;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        selectedCategoryGroupIds.value.contains(categoryGroup.id) ||
        categoryGroup.categoryIds.every(selectedCategoryIds.value.contains);

    return ListRow(
      implicitTrailing: false,
      onTap: allowCategoryGroupSelection ? () => onChanged(!isSelected) : null,
      title: Text(
        categoryGroup.name,
        overflow: TextOverflow.ellipsis,
        style: context.text.title.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: SizedBox(
        width: Sizes.unit * 3,
        height: Sizes.unit * 3,
        child: Checkbox(
          value: isSelected,
          onChanged: allowCategoryGroupSelection ? (v) => onChanged(v!) : null,
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.name, required this.isSelected, required this.onChanged});

  final String name;
  final bool isSelected;
  final ValueSetter<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: Text(name, overflow: TextOverflow.ellipsis),
      leading: SizedBox(
        width: Sizes.unit * 3,
        height: Sizes.unit * 3,
        child: Checkbox(value: isSelected, onChanged: (v) => onChanged(v!)),
      ),
      onTap: () => onChanged(!isSelected),
      implicitTrailing: false,
    );
  }
}
