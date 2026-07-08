import 'package:design/design.dart';
import 'package:flutter/material.dart';

class InitialFetchView extends StatelessWidget {
  const InitialFetchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: VLayout(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CircularProgressIndicator.adaptive(), VSpace(), Text('Just a sec...')],
        ),
      ),
    );
  }
}
