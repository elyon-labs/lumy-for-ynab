import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import '_build_context.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({
    super.key,
    this.title,
    this.actions,
    this.constraints = const BoxConstraints(maxWidth: 800),
    this.backgroundColor,
    this.automaticallyImplyLeading,
    required this.child,
  });

  final bool? automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final Widget child;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final GlobalKey _contentKey = GlobalKey();
  ScrollableState? _scrollable;

  @override
  void initState() {
    super.initState();
    _scheduleScrollableLookup();
  }

  @override
  void didUpdateWidget(covariant AppScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleScrollableLookup();
  }

  void _scheduleScrollableLookup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final BuildContext? context = _contentKey.currentContext;
      final ScrollableState? scrollable = context != null ? _findScrollable(context) : null;
      _scrollable = scrollable?.mounted ?? false ? scrollable : null;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      final context = notification.context;
      if (context == null) return false;
      final ScrollableState? candidate = Scrollable.maybeOf(context);
      if (candidate?.mounted ?? false) {
        _scrollable = candidate;
      }
    }
    return false;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }
    final ScrollableState? scrollable = (_scrollable?.mounted ?? false)
        ? _scrollable
        : _lookupScrollable();
    if (scrollable == null) {
      event.respond(allowPlatformDefault: true);
      return;
    }

    final double delta = _pointerDeltaFor(event, scrollable.widget.axisDirection);
    if (delta == 0) {
      event.respond(allowPlatformDefault: true);
      return;
    }

    final position = scrollable.position;
    if (!position.physics.shouldAcceptUserOffset(position)) {
      event.respond(allowPlatformDefault: true);
      return;
    }

    position.pointerScroll(delta);
  }

  ScrollableState? _lookupScrollable() {
    final BuildContext? context = _contentKey.currentContext;
    final ScrollableState? scrollable = context != null ? _findScrollable(context) : null;
    return scrollable?.mounted ?? false ? scrollable : null;
  }

  double _pointerDeltaFor(PointerScrollEvent event, AxisDirection axisDirection) {
    final Axis axis = switch (axisDirection) {
      AxisDirection.up || AxisDirection.down => Axis.vertical,
      AxisDirection.left || AxisDirection.right => Axis.horizontal,
    };

    double delta = axis == Axis.vertical ? event.scrollDelta.dy : event.scrollDelta.dx;
    if (axisDirection == AxisDirection.up || axisDirection == AxisDirection.left) {
      delta = -delta;
    }
    return delta;
  }

  // Finds the first scrollable descendant so gutter wheel events can delegate to it.
  ScrollableState? _findScrollable(BuildContext context) {
    ScrollableState? result;
    void visitor(Element element) {
      if (result != null) {
        return;
      }
      if (element is StatefulElement && element.state is ScrollableState) {
        result = element.state as ScrollableState;
        return;
      }
      element.visitChildElements(visitor);
    }

    context.visitChildElements(visitor);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final behavior = ScrollConfiguration.of(context).copyWith(scrollbars: false);
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.title != null || (widget.actions != null && widget.actions!.isNotEmpty)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                title: widget.title,
                actions: widget.actions,
                centerTitle: context.isDesktop,
                automaticallyImplyLeading: widget.automaticallyImplyLeading ?? !context.isDesktop,
              ),
            )
          : null,
      body: ScrollConfiguration(
        behavior: behavior,
        child: SafeArea(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerSignal: _handlePointerSignal,
            child: Scrollbar(
              thickness: UniversalPlatform.isMobile ? 0 : null,
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: widget.constraints,
                    child: KeyedSubtree(key: _contentKey, child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
