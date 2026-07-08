import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

final _faker = Faker();

abstract class TransactionFactory {
  static PastTransaction build({
    String? id,
    String? payeeName,
    String? payeeId,
    String? date,
    int? amount,
    String? accountId,
    String? categoryId,
    String? categoryName,
    String? memo,
    String? transferAccountId,
    String? transferTransactionId,
    String? matchedTransactionId,
    String? importId,
    bool? isDeleted,
    String? flagColor,
    List<SubTransaction>? subTransactions,
  }) {
    return PastTransaction(
      id: id ?? _faker.guid.guid(),
      payeeName: payeeName ?? _faker.person.name(),
      payeeId: payeeId ?? _faker.guid.guid(),
      date: date ?? DateFormat('yyyy-MM-dd').format(_faker.date.dateTime()),
      amount: amount ?? _faker.randomGenerator.integer(1000000),
      accountId: accountId ?? _faker.guid.guid(),
      categoryId: categoryId ?? _faker.guid.guid(),
      categoryName: categoryName ?? _faker.lorem.word(),
      memo: memo ?? _faker.lorem.sentence(),
      transferAccountId: transferAccountId ?? _faker.guid.guid(),
      transferTransactionId: transferTransactionId ?? _faker.guid.guid(),
      matchedTransactionId: matchedTransactionId ?? _faker.guid.guid(),
      importId: importId ?? _faker.guid.guid(),
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
      flagColor: flagColor ?? Flag.values[_faker.randomGenerator.integer(Flag.values.length)].name,
      subTransactions:
          subTransactions ??
          List.generate(
            _faker.randomGenerator.integer(10),
            (index) => SubTransactionFactory.build(),
          ),
    );
  }
}

abstract class SubTransactionFactory {
  static SubTransaction build({
    String? transactionId,
    String? id,
    String? payeeName,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? categoryName,
    String? memo,
    String? transferAccountId,
    String? transferTransactionId,
    bool? isDeleted,
  }) {
    return SubTransaction(
      transactionId: transactionId ?? _faker.guid.guid(),
      id: id ?? _faker.guid.guid(),
      payeeName: payeeName,
      payeeId: payeeId,
      amount: amount ?? _faker.randomGenerator.integer(1000000),
      categoryId: categoryId,
      categoryName: categoryName,
      memo: memo,
      transferAccountId: transferAccountId,
      transferTransactionId: transferAccountId,
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
    );
  }
}
