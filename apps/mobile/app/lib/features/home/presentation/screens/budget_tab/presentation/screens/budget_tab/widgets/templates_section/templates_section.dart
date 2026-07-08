import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../../../../../common/presentation/_color.dart';
import '../../../../../../../../../../common/presentation/modals/options_sheet.dart';
import '../../../../../../../../../../utils/_build_context.dart';
import '../../../../../../../../../auth/presentation/screens/write_access_screen/widgets/write_access_guard/write_access_guard.dart';
import '../../../../../../../../../templates/domain/models/transaction_template.dart';
import '../../../../../../../../../templates/presentation/screens/run_template_screen/run_template_screen.dart';
import '../../../../../../../../../templates/presentation/setup_template/screens/setup_template_screen/setup_template_screen.dart';
import 'templates_section_state.dart';

class TemplatesSection extends StatelessWidget {
  const TemplatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemplatesSectionCubit, TemplatesSectionState>(
      builder: (context, state) {
        final templates = state.templates;
        if (templates.isEmpty) return const SizedBox.shrink();
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              scrollDirection: Axis.horizontal,
              primary: false,
              child: VLayout(
                spacing: 0,
                children: [
                  HLayout(
                    spacing: Sizes.edgePadding,
                    children: templates.map((t) => _Template(template: t)).toList(),
                  ),
                  const VSpace(space: Sizes.unit * 2),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Row(
                  children: [
                    Container(
                      width: Sizes.edgePadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [context.colors.body.withAlphaOf(0), context.colors.body],
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      width: Sizes.edgePadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [context.colors.body.withAlphaOf(0), context.colors.body],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Template extends HookWidget {
  const _Template({required this.template});

  final TransactionTemplate template;

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (TemplatesSectionCubit cubit) => cubit.state.templateStatus[template.id],
    );
    final isLoading = status == const Loading();

    final runTemplateImmediately = useCallback(() async {
      if (!template.fireImmediately) return;
      final result = await context.read<TemplatesSectionCubit>().runTemplateImmediately(template);
      if (!context.mounted) return;
      switch (result) {
        case Ok<String, Exception>():
          context.showToast(Text('Template ${template.name} executed successfully'));
        case Err<String, Exception>(:final error):
          context.showToast(Text('Failed to execute template ${template.name}: $error'));
      }
    });

    final onTap = useCallback(() async {
      if (isLoading) return;
      if (template.fireImmediately) {
        await runTemplateImmediately();
      } else {
        context.go(RunTemplateScreen.buildRoute(template.id));
      }
    });

    return WriteAccessGuard(
      onAccessGranted: onTap,
      isBlocking: template.fireImmediately,
      child: Card(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
          child: InkWell(
            borderRadius: BorderRadius.circular(Sizes.unit * 1.5),
            onTap: onTap,
            onLongPress: () async {
              if (isLoading) return;
              await showModalBottomSheet(
                context: context,
                builder: (_) {
                  return _TemplateOptions(
                    onActionSelected: (value) async {
                      switch (value) {
                        case _TemplateAction.edit:
                          context.go(SetupTemplateScreen.buildEditRoute(template.id));
                        case _TemplateAction.delete:
                          await context.read<TemplatesSectionCubit>().deleteTemplate(template);
                      }
                    },
                  );
                },
                useRootNavigator: true,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(Sizes.edgePadding),
              child: VLayout(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: _AvatarChild(
                      isFireImmediately: template.fireImmediately,
                      isLoading: isLoading,
                    ),
                  ),
                  const VSpace(space: Sizes.unit / 2),
                  Text(template.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _TemplateAction { edit, delete }

class _TemplateOptions extends StatelessWidget {
  const _TemplateOptions({required this.onActionSelected});

  final ValueSetter<_TemplateAction> onActionSelected;
  @override
  Widget build(BuildContext context) {
    return OptionsSheet(
      options: [
        OptionsSheetButton(
          title: const Text('Edit'),
          onTap: () => onActionSelected(_TemplateAction.edit),
          isDestructive: false,
        ),
        OptionsSheetButton(
          title: const Text('Delete'),
          onTap: () => onActionSelected(_TemplateAction.delete),
          isDestructive: true,
        ),
      ],
    );
  }
}

class _AvatarChild extends StatelessWidget {
  const _AvatarChild({required this.isFireImmediately, required this.isLoading});

  final bool isFireImmediately;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CircularProgressIndicator.adaptive();
    return isFireImmediately
        ? const Icon(Ionicons.flash_outline)
        : const Icon(Ionicons.flash_off_outline);
  }
}
