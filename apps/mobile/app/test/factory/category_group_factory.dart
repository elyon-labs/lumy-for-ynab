import 'package:faker/faker.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'category_factory.dart';

final _faker = Faker();

abstract class CategoryGroupFactory {
  static CategoryGroup build({
    String? id,
    String? name,
    bool? isHidden,
    bool? isDeleted,
    List<Category>? categories,
  }) {
    return CategoryGroup(
      id: id ?? _faker.guid.guid(),
      name: name ?? _faker.lorem.word(),
      isHidden: isHidden ?? _faker.randomGenerator.boolean(),
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
      categories:
          categories ??
          List.generate(
            _faker.randomGenerator.integer(5, min: 1),
            (index) => CategoryFactory.build(),
          ),
    );
  }
}
