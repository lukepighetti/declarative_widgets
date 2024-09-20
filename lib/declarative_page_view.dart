import 'package:flutter/widgets.dart';

class DeclarativePageView<T> extends StatefulWidget {
  const DeclarativePageView({
    super.key,
    this.viewportFraction = 1,
    this.conflictResolution = ConflictResolution.user,
    required this.value,
    required this.onChange,
    required this.pages,
    required this.builder,
  });

  final double viewportFraction;

  final ConflictResolution conflictResolution;

  final T value;

  final ValueChanged<T> onChange;

  final List<T> pages;

  final Widget Function(BuildContext context, T value) builder;

  @override
  State<DeclarativePageView> createState() => _DeclarativePageViewState<T>();
}

class _DeclarativePageViewState<T> extends State<DeclarativePageView<T>> {
  late var page = widget.pages.indexOf(widget.value); // initial page

  var isAnimating = false;

  var userInteracting = false;
  void userIsInteracting(bool x) {
    setState(() => userInteracting = x);
    print("pointerIsDown($x)");
  }

  late final controller =
      PageController(viewportFraction: widget.viewportFraction);

  void onControllerUpdated() {
    final p = controller.page!.clamp(0, widget.pages.length).round();
    final v = widget.pages.elementAtOrNull(p);
    if (v == null) return;
    if (p != page) {
      page = p;

      /// updating this during fling is causing onValueUpdated to trigger
      /// TODO: get fling blocking time
      widget.onChange(v);
    }
  }

  void onValueUpdated(T x) {
    if (userInteracting) return;
    final i = widget.pages.indexOf(x);
    controller.animateToPage(
      i,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
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

enum ConflictResolution {
  user,
  animation,
}
