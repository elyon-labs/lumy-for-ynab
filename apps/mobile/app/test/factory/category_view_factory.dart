import 'package:faker/faker.dart';
import 'package:lumy/features/category_views/domain/models/category_view.dart';

final _faker = Faker();

abstract class CategoryViewFactory {
  static CategoryView build({
    String? id,
    String? name,
    String? budgetId,
    bool? isDeleted,
    List<String>? categoryGroupIds,
    List<String>? categoryIds,
  }) {
    return CategoryView(
      id: id ?? _faker.guid.guid(),
      name: name ?? _faker.lorem.word(),
      budgetId: budgetId ?? _faker.guid.guid(),
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
      categoryGroupIds:
          categoryGroupIds ??
          List.generate(_faker.randomGenerator.integer(10), (index) {
            return _faker.guid.guid();
          }),
      categoryIds:
          categoryIds ??
          List.generate(_faker.randomGenerator.integer(10), (index) {
            return _faker.guid.guid();
          }),
    );
  }
}
