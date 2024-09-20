import 'package:declarative_widgets/declarative_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  var page = _ExamplePage.one;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'declarative_widgets',
      home: Scaffold(
        body: Column(
          children: [
            SafeArea(
              minimum: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() => page = _ExamplePage.one),
                  ),
                  Text(page.name),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() => page = _ExamplePage.two),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DeclarativePageView(
                value: page,
                onChange: (x) => setState(() => page = x),
                pages: _ExamplePage.values,
                builder: (context, value) {
                  return switch (value) {
                    _ExamplePage.one => Center(
                        child: Text(value.name),
                      ),
                    _ExamplePage.two => Center(
                        child: Text(value.name),
                      ),
                    _ExamplePage.three => Center(
                        child: Text(value.name),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ExamplePage {
  one,
  two,
  three,
}
