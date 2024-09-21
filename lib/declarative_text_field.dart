import 'package:declarative_widgets/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeclarativeTextField extends StatefulWidget {
  const DeclarativeTextField({
    super.key,
    required this.value,
    required this.onChange,
    this.focusNode,
  });

  final String value;

  final ValueChanged<String> onChange;

  final FocusNode? focusNode;

  @override
  State<DeclarativeTextField> createState() => _DeclarativeTextFieldState();
}

class _DeclarativeTextFieldState extends State<DeclarativeTextField> {
  late final controller = TextEditingController(text: widget.value);
  late final focusNode = widget.focusNode ?? FocusNode();

  final conflictResolution = ConflictResolution.user;

  void didControllerUpdate() {
    final text = controller.text;
    widget.onChange(text);
    print('didControllerUpdate $text');
  }

  void didValueUpdate(String x) {
    switch (conflictResolution) {
      case ConflictResolution.user:
        if (focusNode.hasFocus) return;
      case ConflictResolution.value:
        break;
    }
    controller.text = x;
    print('didValueUpdate $x');

    // TODO: handle TextEditingValue error
  }

  void didFocusUpdate() {
    print('didFocusUpdate ${focusNode.hasFocus}');
    if (focusNode.hasFocus) return;
    if (controller.text == widget.value) return;

    controller.text = widget.value;
  }

  @override
  void initState() {
    controller.addListener(didControllerUpdate);
    focusNode.addListener(didFocusUpdate);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DeclarativeTextField oldWidget) {
    if (widget.value != oldWidget.value) {
      didValueUpdate(widget.value);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.removeListener(didControllerUpdate);
    focusNode.removeListener(didFocusUpdate);
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
    );
  }
}
