import 'dart:async';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Testimony {
  const Testimony({required this.text, required this.author});

  final String text;
  final String author;
}

class TestimonialRotator extends StatefulWidget {
  const TestimonialRotator({super.key, required this.testimonials});

  final List<Testimony> testimonials;

  @override
  State<TestimonialRotator> createState() => _TestimonialRotatorState();
}

class _TestimonialRotatorState extends State<TestimonialRotator> {
  int _currentIndex = 0;
  bool _showing = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      setState(() => _showing = false); // start zoom out

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.testimonials.length;
        _showing = true; // start zoom in
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = VLayout(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.testimonials[_currentIndex].text,
          textAlign: TextAlign.center,
          style: context.text.title,
        ),
        HLayout(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Sizes.unit / 2,
          children: [
            Icon(Icons.star, color: context.colors.muted, size: Sizes.unit * 2),
            Icon(Icons.star, color: context.colors.muted, size: Sizes.unit * 2),
            Icon(Icons.star, color: context.colors.muted, size: Sizes.unit * 2),
            Icon(Icons.star, color: context.colors.muted, size: Sizes.unit * 2),
            Icon(Icons.star, color: context.colors.muted, size: Sizes.unit * 2),
          ],
        ),
        Text(
          widget.testimonials[_currentIndex].author,
          style: TextStyle(color: context.colors.muted),
        ),
      ],
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showing
          ? text
                .animate(key: ValueKey(_currentIndex))
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
                .fadeIn(duration: 400.ms)
          : text
                .animate(key: ValueKey('_out_$_currentIndex'))
                .scale(begin: const Offset(1, 1), end: const Offset(0.8, 0.8))
                .fadeOut(duration: 400.ms),
    );
  }
}
