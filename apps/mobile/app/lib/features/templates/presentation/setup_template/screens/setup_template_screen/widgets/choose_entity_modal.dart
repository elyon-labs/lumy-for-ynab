import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../common/presentation/design_system/outlined_child.dart';
import 'choose_entities_modal_header.dart';

class ChooseEntityModal<T extends Searchable> extends HookWidget {
  factory ChooseEntityModal.single({
    Key? key,
    required Widget title,
    required List<T> entities,
    required Widget Function(T) builder,
    required VoidCallback onCancel,
    required ValueChanged<T> onSelected,
    required T? initialSelectedEntity,
  }) => ChooseEntityModal._(
    key: key,
    title: title,
    entities: entities,
    onCancel: onCancel,
    builder: builder,
    onSelected: onSelected,
    initialSelectedEntities: initialSelectedEntity != null ? [initialSelectedEntity] : [],
  );

  factory ChooseEntityModal.multiple({
    Key? key,
    required Widget title,
    required List<T> entities,
    required Widget Function(T) builder,
    required VoidCallback onCancel,
    required ValueSetter<T> onSelected,
    required ValueSetter<List<T>> onSelectedMultiple,
    required List<T> initialSelectedEntities,
  }) => ChooseEntityModal._(
    key: key,
    title: title,
    entities: entities,
    builder: builder,
    onCancel: onCancel,
    onSelected: onSelected,
    onSelectedMultiple: onSelectedMultiple,
    initialSelectedEntities: initialSelectedEntities,
  );

  const ChooseEntityModal._({
    super.key,
    required this.title,
    required this.entities,
    required this.builder,
    required this.initialSelectedEntities,
    this.onCancel,
    this.onSelected,
    this.onSelectedMultiple,
  });

  final Widget title;
  final List<T> entities;
  final Widget Function(T) builder;
  final VoidCallback? onCancel;
  final ValueChanged<T>? onSelected;
  final ValueChanged<List<T>>? onSelectedMultiple;
  final List<T> initialSelectedEntities;

  @override
  Widget build(BuildContext context) {
    final isMultiSelect = useState(initialSelectedEntities.length > 1);
    final multiSelectedEntities = useState(initialSelectedEntities);
    final searchInput = useState('');
    final filteredEntities = useMemoized(() => entities.search(searchInput.value.toLowerCase()), [
      searchInput.value,
      entities,
    ]);

    void toggleEntityForMultiselect(T entity) {
      if (multiSelectedEntities.value.contains(entity)) {
        multiSelectedEntities.remove(entity);
      } else {
        multiSelectedEntities.add(entity);
      }
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverVSpace(space: Sizes.edgePadding),
          SliverToBoxAdapter(
            child: ChooseEntitiesModalHeader(
              title: title,
              allowMultiSelect: onSelectedMultiple != null,
              onCancelTapped: () => onCancel?.call(),
              multiSelectChild: isMultiSelect.value ? const Text('Done') : const Text('Split'),
              onMultiSelectTapped: () {
                isMultiSelect.value = !isMultiSelect.value;
                if (!isMultiSelect.value) {
                  switch (multiSelectedEntities.value.length) {
                    case > 1:
                      onSelectedMultiple?.call(multiSelectedEntities.value);
                    case 1:
                      onSelected?.call(multiSelectedEntities.value.first);
                  }
                }
              },
            ),
          ),
          const SliverVSpace(space: Sizes.edgePadding * 2),
          SliverToBoxAdapter(
            child: HEdgePadding(
              child: OutlinedChild(
                child: HEdgePadding(
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Search'),
                    onChanged: (query) => searchInput.value = query,
                  ),
                ),
              ),
            ),
          ),
          const SliverVSpace(),
          SliverSafeArea(
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final entity = filteredEntities[index];
                return ListRow(
                  title: builder(entity),
                  onTap: () {
                    if (isMultiSelect.value) {
                      toggleEntityForMultiselect(entity);
                    } else {
                      onSelected?.call(entity);
                    }
                  },
                  implicitTrailing: false,
                  leading: isMultiSelect.value
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            shape: RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.circular(Sizes.borderRadius),
                            ),
                            value: multiSelectedEntities.value.contains(entity),
                            onChanged: (_) => toggleEntityForMultiselect(entity),
                          ),
                        )
                      : null,
                );
              }, childCount: filteredEntities.length),
            ),
          ),
        ],
      ),
    );
  }
}

extension _ListValueNotifierX<T> on ValueNotifier<List<T>> {
  void add(T obj) {
    value = List<T>.from(value)..add(obj);
  }

  void remove(T obj) {
    value = List<T>.from(value)..remove(obj);
  }
}
