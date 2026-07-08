import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/request_ynab_access_token.dart';
import 'link_ynab_screen_state.dart';

class LinkYnabScreenCubit extends Cubit<LinkYnabScreenState> {
  LinkYnabScreenCubit({required this.uri, required RequestYnabAccessToken requestYnabAccessToken})
    : _requestYnabAccessToken = requestYnabAccessToken,
      super(LinkYnabScreenState.initial(uri: uri));

  factory LinkYnabScreenCubit.create({required Uri? uri}) {
    return LinkYnabScreenCubit(uri: uri, requestYnabAccessToken: RequestYnabAccessToken.create());
  }

  final Uri? uri;

  final RequestYnabAccessToken _requestYnabAccessToken;

  Future<void> fetch() async {
    await _requestYnabAccessToken(includeWriteScope: false);
  }
}
