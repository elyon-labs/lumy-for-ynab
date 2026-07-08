import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';

extension AsyncSnapshotX<T extends Object> on AsyncSnapshot<T> {
  Async<T> toAsync() {
    if (hasData) {
      return Loaded(data!);
    }

    if (hasError) {
      return Error(error!);
    }

    return const Loading();
  }
}
