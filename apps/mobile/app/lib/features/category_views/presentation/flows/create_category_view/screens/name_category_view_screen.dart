import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../domain/models/category_view.dart';

class NameCategoryViewScreen extends StatelessWidget {
  const NameCategoryViewScreen({super.key, required this.onComplete, this.existingCategoryView});

  final CategoryView? existingCategoryView;
  final ValueSetter<String> onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name your view')),
      body: _Body(existingCategoryView: existingCategoryView, onComplete: onComplete),
    );
  }
}

class _Body extends HookWidget {
  const _Body({required this.existingCategoryView, required this.onComplete});
  final CategoryView? existingCategoryView;
  final ValueSetter<String> onComplete;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController.fromValue(
      TextEditingValue(text: existingCategoryView?.name ?? ''),
    );
    final updates = useListenable(controller);
    final rows = [
      const VSpace(space: Sizes.unit * 2),
      _TextFieldRow(controller: controller, hintText: 'e.g Important'),
    ];
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(childCount: rows.length, (context, index) {
                final item = rows[index];
                return item.build(context);
              }),
            ),
          ],
        ),
        _SaveButton(
          shouldShow: updates.text.isNotEmpty,
          sourceId: () => updates.text,
          name: () => updates.text,
          onTap: () => onComplete(updates.text),
          isEditing: existingCategoryView != null,
        ),
      ],
    );
  }
}

class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({required this.controller, required this.hintText});

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return VEdgePadding(
      child: HEdgePadding(
        child: OutlinedChild(
          child: HEdgePadding(
            child: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(hintText: hintText),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.shouldShow,
    required this.sourceId,
    required this.name,
    required this.onTap,
    required this.isEditing,
  });
  final bool shouldShow;
  final ValueGetter<String> sourceId;
  final ValueGetter<String> name;
  final VoidCallback onTap;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedScale(
        scale: shouldShow ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.edgePadding),
            child: PrimaryButton(
              onPressed: !shouldShow ? null : onTap,
              child: Text(
                !shouldShow
                    ? 'Save'
                    : isEditing
                    ? 'Done'
                    : 'Create ${name()}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
