import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HookBlocBuilder<B extends StateStreamable<S>, S> extends StatelessWidget {
  const HookBlocBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) => HookBuilder(builder: (context) => builder(context, state)),
    );
  }
}
