import 'package:declarative_widgets/declarative_page_view.dart';
import 'package:example/pages_view.dart';
import 'package:example/text_view.dart';
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
  var value = ExampleItems.pages;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'declarative_widgets',
      home: Scaffold(
        body: DeclarativePageView(
          value: value,
          onChange: (x) => setState(() => value = x),
          pages: ExampleItems.values,
          builder: (context, x) => switch (x) {
            ExampleItems.pages => const PagesView(),
            ExampleItems.text => const TextView(),
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: ExampleItems.values.indexOf(value),
          onTap: (i) {
            setState(() => value = ExampleItems.values[i]);
            //
          },
          items: [
            for (final x in ExampleItems.values)
              BottomNavigationBarItem(
                icon: const Icon(Icons.code),
                label: x.name,
              ),
          ],
        ),
      ),
    );
  }
}

enum ExampleItems {
  pages,
  text,
}
