import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BudgetTabBody extends StatelessWidget {
  const BudgetTabBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Stack(
          children: [
            VLayout(children: [children[0], children[1]]),
          ],
        ),
        ...children.skip(2),
      ]),
    );
  }
}
