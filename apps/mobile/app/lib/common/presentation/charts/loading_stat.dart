import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingStat extends StatelessWidget {
  const LoadingStat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(child: Bone.text(words: 1));
  }
}
