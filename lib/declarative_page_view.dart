import 'package:flutter/widgets.dart';

class DeclarativePageView<T> extends StatefulWidget {
  const DeclarativePageView({
    super.key,
    this.viewportFraction = 1,
    // this.conflictResolution = ConflictResolution.user,
    required this.value,
    required this.onChange,
    required this.pages,
    required this.builder,
    this.physics,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOut,
  });

  final double viewportFraction;

  // final ConflictResolution conflictResolution;

  final T value;

  final ValueChanged<T> onChange;

  final List<T> pages;

  final Widget Function(BuildContext context, T value) builder;

  final ScrollPhysics? physics;

  final Duration duration;

  final Curve curve;

  @override
  State<DeclarativePageView> createState() => _DeclarativePageViewState<T>();
}

class _DeclarativePageViewState<T> extends State<DeclarativePageView<T>> {
  late var page = widget.pages.indexOf(widget.value); // initial page
  var isAnimating = false;
  var userInteracting = false;

  void userIsInteracting(bool x) {
    setState(() => userInteracting = x);
  }

  late final controller =
      PageController(viewportFraction: widget.viewportFraction);

  void onControllerUpdated() {
    final p = controller.page!.clamp(0, widget.pages.length).round();
    final v = widget.pages.elementAtOrNull(p);

    if (didRegister == false && controller.positions.isNotEmpty) {
      isScrollingNotifier.addListener(onScrollingUpdated);
      didRegister = true;
    }

    if (v == null) return;
    if (p != page) {
      page = p;
      widget.onChange(v);
    }
  }

  late final isScrollingNotifier = controller.position.isScrollingNotifier;
  var didRegister = false;

  void onScrollingUpdated() {
    final scrolling = isScrollingNotifier.value;
    if (scrolling == false) {
      userInteracting = false;
    }
  }

  void onValueUpdated(T x) {
    if (userInteracting) return;
    final i = widget.pages.indexOf(x);
    controller.animateToPage(
      i,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  void initState() {
    controller.addListener(onControllerUpdated);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DeclarativePageView<T> oldWidget) {
    if (widget.value != oldWidget.value) onValueUpdated(widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    isScrollingNotifier.removeListener(onScrollingUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => userIsInteracting(true),
      onPointerUp: (_) => userIsInteracting(false),
      onPointerCancel: (_) => userIsInteracting(false),
      onPointerPanZoomStart: (_) => userIsInteracting(true),
      onPointerPanZoomEnd: (_) => userIsInteracting(false),
      child: PageView(
        controller: controller,
        children: [
          for (final x in widget.pages) widget.builder(context, x),
        ],
      ),
    );
  }
}
