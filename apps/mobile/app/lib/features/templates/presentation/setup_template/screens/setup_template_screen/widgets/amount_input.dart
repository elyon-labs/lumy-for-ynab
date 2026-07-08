import 'dart:async';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../../../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../../../../common/presentation/_color.dart';
import '../../../../../../../common/presentation/currency.dart';
import '../../../../../../../common/presentation/currency/currency_input_formatter.dart';

class AmountInput extends StatefulHookWidget {
  const AmountInput({
    super.key,
    this.onChanged,
    required this.isInflow,
    this.controller,
    this.style,
    this.textAlign = TextAlign.center,
    this.autoFocus = true,
    this.disableScroll = false,
    this.initialValue,
    this.colorful = true,
    this.showCursor = true,
  });

  /// An optional controller for the text field. If not provided, one is created for you.
  final TextEditingController? controller;

  /// Called when the user changes the amount. The `int` amount is the amount in
  /// milliunits.
  final ValueSetter<int>? onChanged;

  /// Indicates whether the amount is an inflow (income) or outflow (expense).
  /// This is used to determine the color of the text.
  final bool isInflow;

  /// An optional style for the text field. You can provide this and still specify [colorful]
  /// as true if you want only the color dictated by the [Widget].
  final TextStyle? style;

  /// How the text field should be aligned.
  final TextAlign textAlign;

  /// Whether the text field should automatically focus when the screen is displayed.
  final bool autoFocus;

  /// Whether the text field should disable scrolling when the keyboard is open.
  final bool disableScroll;

  /// The initial value of the text field. If [controller] is provided, this is ignored.
  final int? initialValue;

  /// Whether the text field should use colors associated with [isInflow].
  final bool colorful;

  /// Whether the text field should show the cursor.
  final bool showCursor;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> with SingleTickerProviderStateMixin {
  final FocusNode _nodeText1 = FocusNode();
  late final AnimationController _bounce;
  late final Animation<double> _scale;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: context.colors.modal,
      actions: [KeyboardActionsItem(focusNode: _nodeText1, displayArrows: false)],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

    // 1.0 → 1.1 → 0.98 → 1.0 for a quick “boop” bounce
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.10), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.10, end: 0.98), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1), weight: 45),
    ]).animate(CurvedAnimation(parent: _bounce, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInflow != widget.isInflow) {
      unawaited(_bounce.forward(from: 0)); // trigger the bounce when the flag flips
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = context.watch<CurrencyFormatCubit>().state;
    // If one isn't provided, create a new one to avoid an Exception
    // see https://github.com/lzhuor/auto_size_text_field/issues/45
    final fallbackController = useTextEditingController.fromValue(
      TextEditingValue(text: (widget.initialValue ?? 0).format(currencyFormat)),
    );
    final textController = widget.controller ?? fallbackController;

    final color = widget.colorful
        ? widget.isInflow
              ? context.colors.good
              : context.colors.error
        : null;

    final effectiveStyle =
        widget.style?.copyWith(color: color) ??
        context.text.headline.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: context.text.headline.fontSize! * 1.5,
        );

    return KeyboardActions(
      disableScroll: widget.disableScroll,
      autoScroll: widget.autoFocus,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      config: _buildConfig(context),
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedDefaultTextStyle(
            duration: 300.milliseconds,
            style: effectiveStyle,
            curve: Curves.bounceInOut,
            child: AutoSizeTextField(
              focusNode: _nodeText1,
              controller: textController,
              showCursor: widget.showCursor,
              cursorHeight: effectiveStyle.fontSize,
              cursorWidth: 1,
              maxLines: 1,
              cursorColor: widget.isInflow
                  ? context.colors.good.withAlphaOf(0.5)
                  : context.colors.error.withAlphaOf(0.5),
              keyboardType: TextInputType.number,
              autofocus: widget.autoFocus,
              textAlign: widget.textAlign,
              // style: style,
              inputFormatters: [CurrencyInputFormatter(currencyFormat: currencyFormat)],
              onChanged: (value) {
                widget.onChanged?.call(value.toMilliUnits(currencyFormat));
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 0.format(currencyFormat),
                border: InputBorder.none,
                counterText: '',
                hintStyle: effectiveStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
