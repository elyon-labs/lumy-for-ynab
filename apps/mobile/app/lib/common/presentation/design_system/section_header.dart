import 'package:design/design.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.text.title.copyWith(fontWeight: FontWeight.bold));
  }
}
