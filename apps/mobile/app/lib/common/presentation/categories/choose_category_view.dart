import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../features/category_views/domain/models/category_view.dart';
import '../../../features/category_views/domain/use_cases/watch_category_views.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/hooks/hook_bloc_builder.dart';
import '../../domain/categories/categories_repository.dart';
import '../../domain/categories/categories_view.dart';
import '../design_system/list_row.dart';

class ChooseCategoryViewState {
  ChooseCategoryViewState({required this.views});

  factory ChooseCategoryViewState.initial() {
    return ChooseCategoryViewState(views: []);
  }

  final List<CategoryView> views;
}

class ChooseCategoryViewCubit extends Cubit<ChooseCategoryViewState> {
  ChooseCategoryViewCubit({required WatchCategoryViews watchCategoryViews})
    : _watchCategoryViews = watchCategoryViews,
      super(ChooseCategoryViewState.initial()) {
    fetch();
  }

  factory ChooseCategoryViewCubit.create() {
    return ChooseCategoryViewCubit(watchCategoryViews: WatchCategoryViews.create());
  }

  final WatchCategoryViews _watchCategoryViews;
  final _subs = CompositeSubscription();

  void fetch() {
    final views = _watchCategoryViews();
    final sub = views.listen((value) => safeEmit(ChooseCategoryViewState(views: value)));
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

class ChooseCategoryView extends StatelessWidget {
  const ChooseCategoryView({
    super.key,
    required this.current,
    required this.onUpdateSetting,
    this.onTapCreateView,
    this.allowViewCreation = true,
  }) : assert(
         !allowViewCreation || onTapCreateView != null,
         'onCreateView must be provided when allowViewCreation is true',
       );

  final Option<String> current;
  final bool allowViewCreation;
  final VoidCallback? onTapCreateView;
  final ValueSetter<Option<String>> onUpdateSetting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseCategoryViewCubit.create(),
      child: HookBlocBuilder<ChooseCategoryViewCubit, ChooseCategoryViewState>(
        builder: (context, state) {
          final views = state.views;
          Iterable<Widget> buildRows() sync* {
            yield ListRow(
              title: const Text('All categories'),
              onTap: () {
                onUpdateSetting.call(const None());
              },
              trailing: const Icon(Ionicons.checkmark_circle_outline).visible(current.isNone()),
            );
            if (views.isNotEmpty) {
              yield const Divider();
            }
            for (final view in views) {
              yield VLayout(
                spacing: 0,
                children: [
                  _CategoryViewRow(view: view, onUpdateSetting: onUpdateSetting, current: current),
                  const Divider(),
                ],
              );
            }
            if (allowViewCreation) {
              yield* [
                const VSpace(space: Sizes.edgePadding),
                Padding(
                  padding: const EdgeInsets.only(left: Sizes.edgePadding, right: Sizes.edgePadding),
                  child: SecondaryButton(
                    onPressed: () {
                      onTapCreateView?.call();
                    },
                    child: const Text('Create view'),
                  ),
                ),
                const VSpace(space: Sizes.edgePadding),
              ];
            }
          }

          return VLayout(spacing: 0, children: buildRows().toList());
        },
      ),
    );
  }
}

class CategoryViewRowState {
  CategoryViewRowState({required this.categories});

  factory CategoryViewRowState.initial() {
    return CategoryViewRowState(categories: []);
  }

  final List<Category> categories;
}

class CategoryViewRowCubit extends Cubit<CategoryViewRowState> {
  CategoryViewRowCubit({required this.viewId, required this.categoriesRepo})
    : super(CategoryViewRowState.initial()) {
    fetch();
  }

  factory CategoryViewRowCubit.create({required String viewId}) {
    return CategoryViewRowCubit(viewId: viewId, categoriesRepo: inject());
  }

  final String viewId;
  final CategoriesRepository categoriesRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final categories = categoriesRepo.watchCategories(CategoriesInView(viewId));
    final sub = categories.listen((value) => safeEmit(CategoryViewRowState(categories: value)));
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class _CategoryViewRow extends StatelessWidget {
  const _CategoryViewRow({
    required this.view,
    required this.onUpdateSetting,
    required this.current,
  });

  final CategoryView view;
  final ValueSetter<Option<String>> onUpdateSetting;
  final Option<String> current;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryViewRowCubit.create(viewId: view.id),
      child: BlocBuilder<CategoryViewRowCubit, CategoryViewRowState>(
        builder: (context, state) {
          final categories = state.categories;
          final firstThree = categories.take(3).toList();
          final remaining = categories.skip(3).toList();
          return ListRow(
            key: ValueKey(view.id),
            title: Text(view.name),
            subtitle: categories.isEmpty
                ? null
                : Text(
                    firstThree.map((e) => e.name).join(', ') + (remaining.isNotEmpty ? '...' : ''),
                  ),
            onTap: () => onUpdateSetting.call(Some(view.id)),
            trailing: const Icon(
              Ionicons.checkmark_circle_outline,
            ).visible(current.toNullable() == view.id),
          );
        },
      ),
    );
  }
}
