import 'package:ynab_api_models/ynab_api_models.dart';

extension ListPayeeX on Iterable<Payee> {
  Map<String, Payee> toMap() {
    return Map.fromEntries(map((e) => MapEntry(e.id, e)));
  }
}
