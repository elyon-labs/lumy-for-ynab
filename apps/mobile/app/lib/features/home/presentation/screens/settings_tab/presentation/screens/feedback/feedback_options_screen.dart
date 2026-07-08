import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../app/environment/environment.dart';
import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_build_context.dart';

class FeedbackOptionsScreenState {
  FeedbackOptionsScreenState({
    required this.feedbackBoardUrl,
    required this.supportEmail,
    required this.userId,
  });

  final String feedbackBoardUrl;
  final String supportEmail;
  final Async<Option<String>> userId;
}

class FeedbackOptionsScreenCubit extends Cubit<FeedbackOptionsScreenState> {
  FeedbackOptionsScreenCubit({required Environment environment, required Settings settings})
    : _settings = settings,
      super(
        FeedbackOptionsScreenState(
          feedbackBoardUrl: environment.feedbackBoardUrl,
          supportEmail: environment.supportEmail,
          userId: const Loading(),
        ),
      ) {
    fetch();
  }

  factory FeedbackOptionsScreenCubit.create() {
    return FeedbackOptionsScreenCubit(environment: inject(), settings: inject());
  }

  void fetch() {
    final sub = _settings.watchYnabUserId().listen((userId) {
      emit(
        FeedbackOptionsScreenState(
          feedbackBoardUrl: state.feedbackBoardUrl,
          supportEmail: state.supportEmail,
          userId: Loaded(Option.from(userId)),
        ),
      );
    });

    _subs.add(sub);
  }

  final Settings _settings;
  final _subs = CompositeSubscription();

  Future<void> openSupportEmail() async {
    final userId = state.userId.value.flatten().unwrapOr('unknown');
    final body = [
      '',
      '',
      'Please leave the below information as it will allow us to assist you faster. Thank you!',
      '',
      'User ID: $userId',
    ].join('\n');

    final uri = Uri(
      scheme: 'mailto',
      path: state.supportEmail,
      query: _encodeQueryParameters(<String, String>{'subject': 'Lumy Support', 'body': body}),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((entry) => '${_encodeQueryComponent(entry.key)}=${_encodeQueryComponent(entry.value)}')
        .join('&');
  }

  String _encodeQueryComponent(String value) {
    return Uri.encodeComponent(value).replaceAll('+', '%20');
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

class FeedbackOptionsScreen extends StatelessWidget {
  const FeedbackOptionsScreen({super.key});

  static String buildRoute() {
    return '/settings/feedback_options';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackOptionsScreenCubit.create(),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Feedback')),
        body: const VEdgePadding(
          child: ListSection(children: [_FeaturesAndBugsRow(), _SomethingElseRow()]),
        ),
      ),
    );
  }
}

class _SomethingElseRow extends StatelessWidget {
  const _SomethingElseRow();

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text('Something else'),
      subtitle: const Text('Need help or have a question? Send us a message.'),
      onTap: () => context.read<FeedbackOptionsScreenCubit>().openSupportEmail(),
    );
  }
}

class _FeaturesAndBugsRow extends StatelessWidget {
  const _FeaturesAndBugsRow();

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text('Features & bugs'),
      subtitle: const Text('Request a feature or report an issue on our feedback board'),
      onTap: () async {
        final state = context.read<FeedbackOptionsScreenCubit>().state;
        if (await canLaunchUrl(Uri.parse(state.feedbackBoardUrl))) {
          await launchUrl(Uri.parse(state.feedbackBoardUrl));
        } else if (context.mounted) {
          context.showToast(const Text('Could not open feedback board'));
        }
      },
    );
  }
}
