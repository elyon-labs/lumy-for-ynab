import 'package:design/design.dart';
import 'package:design/layout/sizes.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../common/presentation/colored_dot.dart';

extension FlagX on Flag {
  Widget get icon {
    Widget flag(Color color) {
      return Icon(Ionicons.flag_outline, color: color);
    }

    return switch (this) {
      Flag.blue => flag(Colors.blue),
      Flag.green => flag(Colors.green),
      Flag.orange => flag(Colors.orange),
      Flag.purple => flag(Colors.purple),
      Flag.red => flag(Colors.red),
      Flag.yellow => flag(Colors.yellow),
    };
  }

  Widget get dot {
    Widget dot(Color color) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.unit / 4),
        child: ColoredDot(color: color, size: Sizes.unit * 2.5),
      );
    }

    return switch (this) {
      Flag.blue => dot(Colors.blue),
      Flag.green => dot(Colors.green),
      Flag.orange => dot(Colors.orange),
      Flag.purple => dot(Colors.purple),
      Flag.red => dot(Colors.red),
      Flag.yellow => dot(Colors.yellow),
    };
  }
}
