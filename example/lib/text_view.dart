import 'package:flutter/material.dart';
import 'package:declarative_widgets/declarative_widgets.dart';

class TextView extends StatefulWidget {
  const TextView({super.key});

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  var value = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.abc),
                  onPressed: () => setState(() => value = 'abc'),
                ),
                IconButton(
                  icon: const Icon(Icons.timer_3),
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() => value = 'abc after 3s');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => value = ''),
                ),
              ],
            ),
            Text("value: $value"),
            DeclarativeTextField(
              value: value,
              onChange: (x) {
                print('onChange: $x');
                setState(() => value = x);
              },
            ),
          ],
        ),
      ),
    );
  }
}
