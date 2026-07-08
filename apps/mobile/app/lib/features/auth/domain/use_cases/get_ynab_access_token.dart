import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../data/repositories/auth_repository.dart';

class GetYnabAccessToken {
  GetYnabAccessToken({required AuthRepository repository}) : _repository = repository;

  factory GetYnabAccessToken.create() {
    return GetYnabAccessToken(repository: inject());
  }

  final AuthRepository _repository;

  Future<Option<YnabAccessToken>> call() async {
    final user = await _repository.watch.first;
    return user.accessToken;
  }
}
