import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef CubitGetter<State extends Object, T extends Cubit<State>> =
    T Function(BuildContext context);

void useCubitConnect<S extends Cubit<S1>, D extends Cubit<dynamic>, S1 extends Object>({
  required Future<void> Function(D, S1 state) onStateChange,
  List<Object> keys = const [],
}) {
  final context = useContext();
  final srcState = context.watch<S>().state;
  useEffect(() {
    final destCubit = context.read<D>();
    unawaited(onStateChange(destCubit, srcState));
    return null;
  }, [...keys, srcState]);
}
